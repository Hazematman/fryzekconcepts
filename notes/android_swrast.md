---
title: Software Rendering and Android
date: "2024-06-27"
last_edit: "2024-06-27"
status: 3
categories: igalia graphics
cover_image: "/assets/2024-06-27-android-swrast/lavapipe_thumbnail.png"
---

My current project at Igalia has had me working on Mesa's software renderers, llvmpipe and lavapipe. I've
been working to get them running on Android, and I wanted to document the progress I've made, the challenges
I've faced, and talk a little bit about the development process for a project like this. My work is not
totally merged into upstream mesa yet, but you can see the MRs I made here:

- [MR !29344](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/29344)
- [MR !29785](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/29785)
- [MR !27805](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/27805)
- [MR !28735](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/28735)

## Setting up an Android development environment

Getting system level software to build and run on Android is unfortunately not straightforward. Since we are doing
software rendering we don't need a physical device and instead we can make use of the Android emulator, and if you
didn't know Android has two emulators, the common one most people use is "goldfish" and the other lesser known
is "cuttlefish". For this project I did my work on the cuttlefish emulator as its meant for testing the
Android OS itself instead of just Android apps and is more reflective of real hardware. The cuttlefish emulator
takes a little bit more work to setup, and I've found that it only works properly in Debian based linux distros.
I run Fedora, so I had to run the emulator in a debian VM.

Thankfully Google has good instructions for building and running cuttlefish, which you can find [here](https://source.android.com/docs/devices/cuttlefish/get-started).
The instructions show you how to setup the emulator using nightly build images from Google. We'll also need to
setup our own Android OS images so after we've confirmed we can run the emulator, we need to start looking at
building AOSP.

For building our own AOSP image, we can also follow the instructions from Google [here](https://source.android.com/docs/setup/build/building).
For the target we'll want `aosp_cf_x86_64_phone-trunk_staging-eng`. At this point it's a good idea to verify that
you can build the image, which you can do by following the rest of the instructions on the page. Building
AOSP from source does take a while though, so prepare to wait potentially an entire day for the image to build.
Also if you get errors complaining that you're out of memory, you can try to reduce the number of parallel builds.
Google officially recommends to have 64GB of RAM, and I only had 32GB so some packages had to be built with the
parallel builds set to 1 so I wouldn't run out of RAM.

For running this custom-built image on Cuttlefish, you can just copy all the `*.img` files from `out/target/product/vsoc_x86_64/`
to the root cuttlefish directory, and then launch cuttlefish. If everything worked successfully you should be
able to see your custom built AOSP image running in the cuttlefish webui.

## Building Mesa targeting Android

Working from the changes in MR [!29344](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/29344)
building llvmpipe or lavapipe targeting Android should just work™️. To get to that stage required a few
changes. First llvmpipe actually already had some support on Android, as long as it was running on a device
that supports a DRM display driver. In that case it could use the `dri` window system integration which already
works on Android. I wanted to get llvmpipe (and lavapipe) running without dri, so I had to add support for
Android in the `drisw` window system integration.

To support Android in `drisw`, this mainly meant adding support for importing dmabuf as framebuffers. The
Android windowing system will provide us with a "gralloc" buffer which inside has a dmabuf fd that represents
the framebuffer. Adding support for importing dmabufs in drisw means we can import and begin drawing to these
frame buffers. Most the changes to support that can be found in [`drisw_allocate_textures`](https://gitlab.freedesktop.org/mesa/mesa/-/blob/9705df53408777d493eab19e5a58c432c1e75acb/src/gallium/frontends/dri/drisw.c#L405)
and the underlying changes to llvmpipe to support importing dmabufs in MR [!27805](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/27805).
The EGL Android platform code also needed some changes to use the `drisw` window system code. Previously this
code would only work with true dri drivers, but with some small tweaks it was possible to get to have it
initialize the drisw window system and then using it for rendering if no hardware devices are available.

For lavapipe the changes were a lot simpler. The Android Vulkan loader requires your driver to have
`HAL_MODULE_INFO_SYM` symbol in the binary, so that got created and populated correctly, following other Vulkan
drivers in Mesa like turnip. Then the image creation code had to be modified to support the
`VK_ANDROID_native_buffer` extension which allows the Android Vulkan loader to create images using Android native
buffer handles. Under the hood this means getting the dmabuf fd from the native buffer handle. Thankfully mesa
already has some common code to handle this, so I could just use that. Some other small changes were also
necessary to address crashes and other failures that came up during testing.

With the changes out of of the way we can now start building Mesa on Android. For this project I had to update
the Android documentation for Mesa to include steps for building LLVM for Android since the version Google ships
with the NDK is missing libraries that llvmpipe/lavapipe need to function. You can see the updated documentation
[here](https://gitlab.freedesktop.org/mesa/mesa/-/blob/9705df53408777d493eab19e5a58c432c1e75acb/docs/drivers/llvmpipe.rst)
and [here](https://gitlab.freedesktop.org/mesa/mesa/-/blob/9705df53408777d493eab19e5a58c432c1e75acb/docs/android.rst).
After sorting out LLVM, building llvmpipe/lavapipe is the same as building any other Mesa driver for Android: we
setup a cross file to tell meson how to cross compile and then we run meson. At this point you could manual modify
the Android image and copy these files to the vm, but I also wanted to support building a new AOSP image directly
including the driver. In order to do that you also have to rename the driver binaries to match Android's naming
convention, and make sure SO_NAME matches as well. If you check out [this](https://gitlab.freedesktop.org/mesa/mesa/-/blob/9705df53408777d493eab19e5a58c432c1e75acb/docs/android.rst?plain=1#L183)
section of the documentation I wrote, it covers how to do that.

If you followed all of that you should have built an version of llvmpipe and lavapipe that you can run on
Android's cuttlefish emulator.

![Android running lavapipe](/assets/2024-06-27-android-swrast/lavapipe.png)
