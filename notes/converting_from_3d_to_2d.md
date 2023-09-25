---
layout: post
title: "Converting from 3D to 2D"
date: "2023-09-25"
last_edit: "2023-09-25"
status: 2
categories: igalia graphics
cover_image: "/assets/3d_to_2d.png"
---

Recently I've been working on a project where I needed to convert an application written in OpenGL to a software renderer. The matrix transformation code in OpenGL made use of the GLM library for matrix math, and I needed to convert the 4x4 matrices to be 3x3 matrices to work with the software renderer. There was some existing code to do this that was broken, and looked something like this:

```
glm::mat3 mat3x3 = glm::mat3(mat4x4);
```

Don't worry if you don't see the problem already, I'm going to illustrate in more detail with the example of a translation matrix. In 3D a standard translation matrix to translate by a vector `(x, y, z)` looks something like this:

```
[1 0 0 x]
[0 1 0 y]
[0 0 1 z]
[0 0 0 1]
```

Then when we multiply this matrix by a vector like `(a, b, c, 1)` the result is `(a + x, b + y, c + z, 1)`. If you don't understand why the matrix is 4x4 or why we have that extra 1 at the end don't worry, I'll explain that in more detail later.

Now using the existing conversion code to get a 3x3 matrix will simply take the first 3 columns and first 3 rows of the matrix and produce a 3x3 matrix from those. Converting the translation matrix above using this code produces the following matrix:

```
[1 0 0]
[0 1 0]
[0 0 1]
```

See the problem now? The `(x, y, z)` values disappeared! In the conversion process we lost these critical values from the translation matrix, and now if we multiply by this matrix nothing will happen since we are just left with the identity matrix. So if we can't use this simple "cast" function in GLM, what can we use?

Well one thing we can do is preserve the last column and last row of the matrix. So assume we have a 4x4 matrix like this:

```
[a b c d]
[e f g h]
[i j k l]
[m n o p]
```

Then preserving the last row and column we should get a matrix like this:

```
[a b d]
[e f h]
[m n p]
```

And if we use this conversion process for the same translation matrix we will get:

```
[1 0 x]
[0 1 y]
[0 0 1]
```

Now we see that the `(x, y)` part of the translation is preserved, and if we try to multiply this matrix by the vector `(a, b, 1)` the result will be `(a + x, b + y, 1)`. The translation is preserved in the conversion!

## Why do we have to use this conversion?

The reason the conversion is more complicated is hidden in how we defined the translation matrix and vector we wanted to translate. The vector was actually a 4D vector with the final component set to 1. The reason we do this is that we actually want to represent an affine space instead of just a vector space. An affine space being a type of space where you can have both points and vectors. A point is exactly what you would expect it to be just a point in space from some origin, and vector is a direction with magnitude but no origin. This is important because strictly speaking translation isn't actually defined for vectors in a normal vector space. Additionally if you try to construct a matrix to represent translation for a vector space you'll find that its impossible to derive a matrix to do this and that operation is not a linear function. On the other hand operations like translation are well defined in an affine space and do what you would expect.

To get around the problem of vector spaces, mathematicians more clever than I figured out you can implement an affine space in a normal vector space by increasing the dimension of the vector space by one, and by adding an extra row and column to the transformation matrices used. They called this a **homogeneous coordinate system**. This lets you say that a vector is actually just a point if the 4th component is 1, but if its 0 its just a vector. Using this abstraction one can implement all the well defined operations for an affine space (like translation!).

So using the "homogeneous coordinate system" abstraction, translation is an operation that defined by taking a point and moving it by a vector. Lets look at how that works with the translation matrix I used as an example above. If you multiply that matrix by a 4D vector where the 4th component is 0, it will just return the same vector. Now if we multiply by a 4D vector where the 4th component is 1, it will return the point translated by the vector we used to construct that translation matrix. This implements the translation operation as its defined in an affine space!

If you're interested in understanding more about homogeneous coordinate spaces, (like how the translation matrix is derived in the first place) I would encourage you to look at resources like ["Mathematics for Computer Graphics Applications"](https://books.google.ca/books/about/Mathematics_for_Computer_Graphics_Applic.html?id=YmQy799flPkC&redir_esc=y). They provide a much more detailed explanation than I am providing here. (The homogeneous coordinate system also has some benefits for representing projections which I won't get into here, but are explained in that text book.)

Now to finally answer the question about why we needed to preserve those final columns and vectors. Based on what we now know, we weren't actually just converting from a "3D space" to a "2D space" we were converting from a "3D homogeneous space" to a "2D homogeneous space". The process of converting from a higher dimension matrix to a lower dimensional matrix is lossy and some transformation details are going to be lost in process (like for example the translation along the z-axis). There is no way to tell what kind of space a given matrix is supposed to transform just by looking at the matrix itself. The matrix does not carry any information about about what space its operating in and any conversion function would need to know that information to properly convert that matrix. Therefore we need develop our own conversion function that preserves the transformations that are important to our application when moving from a "3D homogeneous space" to a "2D homogeneous space".

Hopefully this explanation helps if you are every working on converting 3D transformation code to 2D.
