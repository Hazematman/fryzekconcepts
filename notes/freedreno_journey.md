---
layout: post
title: "Journey Through Freedreno"
date: "2023-02-28"
last_edit: "2023-02-28"
status: 2
cover_image: "/assets/freedreno/glinfo_freedreno_preview.png"
categories: igalia graphics
---
![Android running Freedreno](/assets/freedreno/glinfo_freedreno.png)

As part of my training at Igalia I've been attempting to write a new backend for Freedreno that targets the proprietary "KGSL" kernel mode driver. For those unaware there are two "main" kernel mode drivers on Qualcomm SOCs for the GPU, there is the "MSM", and "KGSL". "MSM" is DRM compliant, and Freedreno already able to run on this driver. "KGSL" is the proprietary KMD that Qualcomm's proprietary userspace driver targets. Now why would you want to run freedreno against KGSL, when MSM exists? Well there are a few ones, first MSM only really works on an up-streamed kernel, so if you have to run a down-streamed kernel you can continue using the version of KGSL that the manufacturer shipped with your device. Second this allows you to run both the proprietary adreno driver and the open source freedreno driver on the same device just by swapping libraries, which can be very nice for quickly testing something against both drivers.

## When "DRM" isn't just "DRM"
When working on a new backend, one of the critical things to do is to make use of as much "common code" as possible. This has a number of benefits, least of all reducing the amount of code you have to write. It also allows reduces the number of bugs that will likely exist as you are relying on well tested code, and it ensures that the backend is mostly likely going to continue to work with new driver updates.

When I started the work for a new backend I looked inside mesa's `src/freedreno/drm` folder. This has the current backend code for Freedreno, and its already modularized to support multiple backends. It currently has support for the above mentioned MSM kernel mode driver as well as virtio (a backend that allows Freedreno to be used from within in a virtualized environment). From the name of this path, you would think that the code in this module would only work with kernel mode drivers that implement DRM, but actually there is only a handful of places in this module where DRM support is assumed. This made it a good starting point to introduce the KGSL backend and piggy back off the common code.

For example the `drm` module has a lot of code to deal with the management of synchronization primitives, buffer objects, and command submit lists. All managed at a abstraction above "DRM" and to re-implement this code would be a bad idea.

## How to get Android to behave
One of this big struggles with getting the KGSL backend working was figuring out how I could get Android to load mesa instead of Qualcomm blob driver that is shipped with the device image. Thankfully a good chunk of this work has already been figured out when the Turnip developers (Turnip is the open source Vulkan implementation for Adreno GPUs) figured out how to get Turnip running on android with KGSL. Thankfully one of my coworkers [Danylo](https://blogs.igalia.com/dpiliaiev/) is one of those Turnip developers, and he gave me a lot of guidance on getting Android setup. One thing to watch out for is the outdated instructions [here](https://docs.mesa3d.org/android.html). These instructions *almost* work, but require some modifications. First if you're using a more modern version of the Android NDK, the compiler has been replaced with LLVM/Clang, so you need to change which compiler is being used. Second flags like `system` in the cross compiler script incorrectly set the system as `linux` instead of `android`. I had success using the below cross compiler script. Take note that the compiler paths need to be updated to match where you extracted the android NDK on your system.

```meson
[binaries]
ar = '/home/lfryzek/Documents/projects/igalia/freedreno/android-ndk-r25b-linux/android-ndk-r25b/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-ar'
c = ['ccache', '/home/lfryzek/Documents/projects/igalia/freedreno/android-ndk-r25b-linux/android-ndk-r25b/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android29-clang']
cpp = ['ccache', '/home/lfryzek/Documents/projects/igalia/freedreno/android-ndk-r25b-linux/android-ndk-r25b/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android29-clang++', '-fno-exceptions', '-fno-unwind-tables', '-fno-asynchronous-unwind-tables', '-static-libstdc++']
c_ld = 'lld'
cpp_ld = 'lld'
strip = '/home/lfryzek/Documents/projects/igalia/freedreno/android-ndk-r25b-linux/android-ndk-r25b/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strip'
# Android doesn't come with a pkg-config, but we need one for Meson to be happy not
# finding all the optional deps it looks for.  Use system pkg-config pointing at a
# directory we get to populate with any .pc files we want to add for Android
pkgconfig = ['env', 'PKG_CONFIG_LIBDIR=/home/lfryzek/Documents/projects/igalia/freedreno/android-ndk-r25b-linux/android-ndk-r25b/pkgconfig:/home/lfryzek/Documents/projects/igalia/freedreno/install-android/lib/pkgconfig', '/usr/bin/pkg-config']

[host_machine]
system = 'android'
cpu_family = 'arm'
cpu = 'armv8'
endian = 'little'
```

Another thing I had to figure out with Android, that was different with these instructions, was how I would get Android to load mesa versions of mesa libraries. That's when my colleague [Mark](https://www.igalia.com/team/mark) pointed out to me that Android is open source and I could just check the source code myself. Sure enough you have find the OpenGL driver loader in [Android's source code](https://android.googlesource.com/platform/frameworks/native/+/master/opengl/libs/EGL/Loader.cpp). From this code we can that Android will try to load a few different files based on some settings, and in my case it would try to load 3 different shaded libraries in the `/vendor/lib64/egl` folder, `libEGL_adreno.so` ,`libGLESv1_CM_adreno.so`, and `libGLESv2.so`. I could just replace these libraries with the version built from mesa and voilà, you're now loading a custom driver! This realization that I could just "read the code" was very powerful in debugging some more android specific issues I ran into, like dealing with gralloc.

Something cool that the opensource Freedreno & Turnip driver developers figured out was getting android to run test OpenGL applications from the adb shell without building android APKs. If you check out the [freedreno repo](https://gitlab.freedesktop.org/freedreno/freedreno), they have an `ndk-build.sh` script that can build tests in the `tests-*` folder. The nice benefit of this is that it provides an easy way to run simple test cases without worrying about the android window system integration. Another nifty feature about this repo is the `libwrap` tool that lets trace the commands being submitted to the GPU. 

## What even is Gralloc?
Gralloc is the graphics memory allocated in Android, and the OS will use it to allocate the surface for "windows". This means that the memory we want to render the display to is managed by gralloc and not our KGSL backend. This means we have to get all the information about this surface from gralloc, and if you look in `src/egl/driver/dri2/platform_android.c` you will see existing code for handing gralloc. You would think "Hey there is no work for me here then", but you would be wrong. The handle gralloc provides is hardware specific, and the code in `platform_android.c` assumes a DRM gralloc implementation. Thankfully the turnip developers had already gone through this struggle and if you look in `src/freedreno/vulkan/tu_android.c` you can see they have implemented a separate path when a Qualcomm msm implementation of gralloc is detected. I could copy this detection logic and add a separate path to `platform_android.c`.

## Working with the Freedreno community
When working on any project (open-source or otherwise), it's nice to know that you aren't working alone. Thankfully the `#freedreno` channel on `irc.oftc.net` is very active and full of helpful people to answer any questions you may have. While working on the backend, one area I wasn't really sure how to address was the synchronization code for buffer objects. The backend exposed a function called `cpu_prep`, This function was just there to call the DRM implementation of `cpu_prep` on the buffer object. I wasn't exactly sure how to implement this functionality with KGSL since it doesn't use DRM buffer objects.

I ended up reaching out to the IRC channel and Rob Clark on the channel explained to me that he was actually working on moving a lot of the code for `cpu_prep` into common code so that a non-drm driver (like the KGSL backend I was working on) would just need to implement that operation as NOP (no operation). 

## Dealing with bugs & reverse engineering the blob
I encountered a few different bugs when implementing the KGSL backend, but most of them consisted of me calling KGSL wrong, or handing synchronization incorrectly. Thankfully since Turnip is already running on KGSL, I could just more carefully compare my code to what Turnip is doing and figure out my logical mistake.

Some of the bugs I encountered required the backend interface in Freedreno to be modified to expose per a new per driver implementation of that backend function, instead of just using a common implementation. For example the existing function to map a buffer object into userspace assumed that the same `fd` for the device could be used for the buffer object in the `mmap` call. This worked fine for any buffer objects we created through KGSL but would not work for buffer objects created from gralloc (remember the above section on surface memory for windows comming from gralloc). To resolve this issue I exposed a new per backend implementation of "map" where I could take a different path if the buffer object came from gralloc.

While testing the KGSL backend I did encounter a new bug that seems to effect both my new KGSL backend and the Turnip KGSL backend. The bug is an `iommu fault` that occurs when the surface allocated by gralloc does not have a height that is aligned to 4. The blitting engine on a6xx GPUs copies in 16x4 chunks, so if the height is not aligned by 4 the GPU will try to write to pixels that exists outside the allocated memory. This issue only happens with KGSL backends since we import memory from gralloc, and gralloc allocates exactly enough memory for the surface, with no alignment on the height. If running on any other platform, the `fdl` (Freedreno Layout) code would be called to compute the minimum required size for a surface which would take into account the alignment requirement for the height. The blob driver Qualcomm didn't seem to have this problem, even though its getting the exact same buffer from gralloc. So it must be doing something different to handle the none aligned height.

Because this issue relied on gralloc, the application needed to running as an Android APK to get a surface from gralloc. The best way to fix this issue would be to figure out what the blob driver is doing and try to replicate this behavior in Freedreno (assuming it isn't doing something silly like switch to sysmem rendering). Unfortunately it didn't look like the libwrap library worked to trace an APK.

The libwrap library relied on a linux feature known as `LD_PRELOAD` to load `libwrap.so` when the application starts and replace the system functions like `open` and `ioctl` with their own implementation that traces what is being submitted to the KGSL kernel mode driver. Thankfully android exposes this `LD_PRELOAD` mechanism through its "wrap" interface where you create a propety called `wrap.<app-name>` with a value `LD_PRELOAD=<path to libwrap.so>`. Android will then load your library like would be done in a normal linux shell. If you tried to do this with libwrap though you find very quickly that you would get corrupted traces. When android launches your APK, it doesn't only launch your application, there are different threads for different android system related functions and some of them can also use OpenGL. The libwrap library is not designed to handle multiple threads using KGSL at the same time. After discovering this issue I created a [MR](https://gitlab.freedesktop.org/freedreno/freedreno/-/merge_requests/22) that would store the tracing file handles as TLS (thread local storage) preventing the clobbering of the trace file, and also allowing you to view the traces generated by different threads separately from each other.

With this is in hand one could begin investing what the blob driver is doing to handle this unaligned surfaces.

## What's next?
Well the next obvious thing to fix is the aligned height issue which is still open. I've also worked on upstreaming my changes with this [WIP MR](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/21570).

![Freedreno running 3d-mark](/assets/freedreno/3d-mark.png)
