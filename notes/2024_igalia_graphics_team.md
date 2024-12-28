---
title: "2024 Graphics Team Contributions at Igalia"
date: "2024-12-20"
last_edit: "2024-12-27"
status: 3
cover_image: "/assets/igalia_logo.png"
categories: igalia graphics
---

2024 has been an exciting year for the [Igalia's Graphics Team](https://www.igalia.com/technology/graphics). We've been making a lot of progress on Turnip, AMD display driver, the Raspberry Pi graphics stack, Vulkan video, and more.

## Vulkan Device Generated Commands

Igalia's Ricardo Garcia has been working hard on adding support for the new `VK_EXT_device_generated_commands` extension in the Vulkan Conformance Test Suite. He wrote an excellent blog post on the extension and on his work that you can read [here](https://rg3.name/202409270942.html). Ricardo also presented the extension at XDC 2024 in Montréal, which he also [blogged about](https://rg3.name/202411181555.html). Take a look and see what generating Vulkan commands directly on the GPU looks like!

## Raspberry Pi Enhancements & Performance Improvements

Our very own Maíra Canal made a big contribution to improve the graphics performance of Raspberry Pi 4 & 5 devices by introducing support for "Super Pages". She wrote an excellent and detailed blog post on what Super Pages are, how they improve performance, and comparing performance of different apps and games. You can read all the juicy details [here](https://mairacanal.github.io/unleashing-power-enabling-super-pages-on-RPi/).

She also worked on introducing CPU jobs to the Broadcom GPU kernel driver in Linux. These changes allow user space to implement jobs that get executed on the CPU in sync with the work on the GPU. She wrote a great blog post detailing what CPU jobs allow you to do and how they work that you can read [here](https://mairacanal.github.io/introducing-cpu-jobs-to-the-rpi/).

Christian Gmeiner on the Graphics team has also been working on adding Perfetto support to Broadcom GPUs. Perfetto is a performance tracing tool and support for it in Broadcom drivers will allow to developers to gain more insight into bottlenecks of their GPU applications. You can check out his changes to add support in the following MRs:
- [MR 31575](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/31575)
- [MR 32277](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/32277)
- [MR 31751](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/31751)

The Raspberry Pi team here at Igalia presented all of their work at XDC 2024 in Montréal. You can see a video below.

![](youtube:tlSFHkp6ODM)

## Linux Kernel 6.8

A number of Igalians made several contributions to the Linux 6.8 kernel release back in March of this year. Our colleague Maíra wrote a great blog post outlining these contributions that you can read [here](https://mairacanal.github.io/introducing-cpu-jobs-to-the-rpi/). To highlight some of these contributions:

- AMD HDR & Color Management
    - Melissa Wen has been working on improving and implementing HDR support in AMD's display driver as well as working on color management in the Linux display stack.
- Async Flip
    - André Almeida implemented support for asynchronous page flip in the atomic DRM modesetting API.
- V3D 7.1.x Kernel Driver
    - Iago Toral contributed a number of patches upstream to get the Broadcom DRM driver working with the latest Broadcom hardware used in the Raspberry Pi 5.
- GPU stats for the Raspberry Pi 4/5
    - José María "Chema" Casanova worked on adding GPU stats support to the latest Raspberry Pi hardware.

## Turnip Improvements

Dhruv Mark Collins has been very hard at work to try and bring performance parity between Qualcomm's proprietary driver and the open source Turnip driver. Two of his big contributions to this were improving the 2D buffer to image copies on A7XX devices, and implementing unidirectional Low Resolution Z (LRZ) on A7XX devices. You can see the MR for these changes [here](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/31401) and [here](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/29453).

A new member of the Igalia Graphics Team Karmjit Mahil has been working on different parts of the Turnip stack, but one notable improvement he made was to improve `fmulz` handling for Direct3D 9. You can check out his changes [here](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/31479) and read more about them.

Danylo Piliaiev has been hard at work adding support for the latest generation of Adreno GPUs. This included getting support for the [A750 working](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/26934), and then implementing performance improvements to bring it up to parity with other Adreno GPUs in Turnip. He also worked on implementing a number of Vulkan extensions and performance improvements such as:

- VK_KHR_shader_atomic_int64
    - [MR 27776](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/27776)
- VK_KHR_fragment_shading_rate
    - [MR 30905](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/30905)
- VK_KHR_8bit_storage
    - [MR 28254](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/28254)
- shaderInt8 feature
    - [MR 29875](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/29875)
- VK_KHR_shader_subgroup_rotate
    - [MR 31358](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/31358)
- VK_EXT_map_memory_placed
    - [MR 28928](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/28928)
- VK_EXT_legacy_dithering
    - [MR 30536](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/30536)
- VK_EXT_depth_clamp_zero_one
    - [MR 29387](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/29387)

## Display Next Hackfest & Display/KMS Meet-up

Igalia hosted the 2024 version of the Display Next Hackfest. This community event is a way to get Linux display developers together to work on improving the Linux display stack. Our Melissa Wen wrote a blog post about the event and what it was like to organize it. You can read all about it [here](https://melissawen.github.io/blog/2024/09/25/reflections-2024-display-next-hackfest).

![Display Next Hackfest](https://raw.githubusercontent.com/melissawen/melissawen.github.io/refs/heads/master/img/2024-ldnh/hackfest-room-0.jpg)

Just in-case you thought you couldn't get enough Linux display stack, Melissa also helped organize a Display/KMS meet-up at XDC 2024. She wrote all about that meet-up and the progress the community made on her blog [here](https://melissawen.github.io/blog/2024/11/19/summary-display-kms-meeting-xdc2024).

## AMD Display & AMDGPU

Melissa Wen has also been hard at work improving AMDGPU's display driver. She made a number of changes including [improving display debug log](https://lore.kernel.org/amd-gfx/ea31b795-5b75-40e6-846e-51dc6696f8bc@amd.com/#t) to include hardware color capabilities, [Migrating EDID handling to EDID common code](https://lore.kernel.org/amd-gfx/20240927230600.2619844-1-superm1@kernel.org/) and various bug fixes such as:

- Fixing null-pointer dereference on edid reading
    - [https://lore.kernel.org/amd-gfx/20240216122401.216860-1-mwen@igalia.com/](https://lore.kernel.org/amd-gfx/20240216122401.216860-1-mwen@igalia.com/)
- Checking dc_link before dereferencing
    - [https://lore.kernel.org/amd-gfx/20240227190828.444715-1-mwen@igalia.com/](https://lore.kernel.org/amd-gfx/20240227190828.444715-1-mwen@igalia.com/)
- Using mpcc_count to log MPC state
    - [https://lore.kernel.org/amd-gfx/20240412163928.118203-1-mwen@igalia.com/](https://lore.kernel.org/amd-gfx/20240412163928.118203-1-mwen@igalia.com/)
- Fixing cursor offset on rotation 180
    - [https://lore.kernel.org/amd-gfx/20240807075546.831208-22-chiahsuan.chung@amd.com/](https://lore.kernel.org/amd-gfx/20240807075546.831208-22-chiahsuan.chung@amd.com/)
- Fixes for kernel crashes since cursor overlay mode
    - [https://lore.kernel.org/amd-gfx/20241217205029.39850-1-mwen@igalia.com/](https://lore.kernel.org/amd-gfx/20241217205029.39850-1-mwen@igalia.com/)

Tvrtko Ursulin, a recent addition to our team, has been working on fixing issues in AMDGPU and some of the Linux kernel's common code. For example, he worked on fixing bugs in the DRM scheduler around missing locks, optimizing the re-lock cycle on the submit path, and cleaned up the code. On AMDGPU he worked on improving memory usage reporting, fixing out of bounds writes, and micro-optimized ring emissions. For DMA fence he simplified fence merging and resolved a potential memory leak. Lastly, on workqueue he fixed false positive sanity check warnings that AMDGPU & DRM scheduler interactions were triggering. You can see the code for some of changes below:
- [https://lore.kernel.org/amd-gfx/20240906180639.12218-1-tursulin@igalia.com/](https://lore.kernel.org/amd-gfx/20240906180639.12218-1-tursulin@igalia.com/)
- [https://lore.kernel.org/amd-gfx/20241008150532.23661-1-tursulin@igalia.com/](https://lore.kernel.org/amd-gfx/20241008150532.23661-1-tursulin@igalia.com/)
- [https://lore.kernel.org/amd-gfx/20241227111938.22974-1-tursulin@igalia.com/](https://lore.kernel.org/amd-gfx/20241227111938.22974-1-tursulin@igalia.com/)
- [https://lore.kernel.org/amd-gfx/20240813135712.82611-1-tursulin@igalia.com/](https://lore.kernel.org/amd-gfx/20240813135712.82611-1-tursulin@igalia.com/)
- [https://lore.kernel.org/amd-gfx/20240712152855.45284-1-tursulin@igalia.com/](https://lore.kernel.org/amd-gfx/20240712152855.45284-1-tursulin@igalia.com/)

## Vulkan & OpenGL Extensions

- `GL_EXT_texture_offset_non_const`
    - Ricardo was busy working on extending OpenGL by adding [this](https://github.com/KhronosGroup/GLSL/blob/main/extensions/ext/GL_EXT_texture_offset_non_const.txt) extension to GLSL as well as providing an implementation for it in [glslang](https://github.com/KhronosGroup/glslang/pull/3782)
- `VK_KHR_video_encode_av1` & `VK_KHR_video_decode_av1`
    - Igalia is listed as a contributor to these extensions and worked very hard to implement CTS support for the extensions.

## Etnaviv Improvements

Christian Gmeiner, one of the maintainers of the Etnaviv driver for Vivante GPUs, has been hard at work this year to make a number of big improvements to Etnaviv. This includes using hwdb to detect GPU features, which he wrote about [here](https://christian-gmeiner.info/2024-04-12-hwdb/). Another big improvement was migrating Etnaviv to use isaspec for the GPU isa description, allowing an assembler and disassembler to be generated from XML. This also allowed Etnaviv to reuse some common features in Mesa for assemblers/disassemblers and take advantage of the python code generation features others in the community have been working on. He wrote a detailed blog about it, that you can find [here](https://christian-gmeiner.info/2024-07-11-it-all-started-with-a-nop-part1/). On the same vein of Etnaviv infrastructure improvements, Christian has also been working on a new shader compiler, written in Rust, called "EBC". Christian presented this new shader compiler at XDC 2024 this year. You can check out his presentation below.

![](youtube:n_fn4evXeZo)

On the side of new features, Christian landed a big one in Mesa 24.03 for Etnaviv: Multiple Render Target (MRT) support! This allows games and applications to render to multiple render targets (think framebuffers) in a single graphics operations. This feature is heavily used by deferred rendering techniques, and is a requirement for later versions of desktop OpenGL and OpenGL ES 3. Keep an eye on [Christian's blog](https://christian-gmeiner.info/) to see any of his future announcements.

## Lavapipe/LLVMpipe, Android & ChromeOS

I had a busy year working on improving Lavapipe/LLVMpipe platform integration. This started with adding support for DMABUF import/export, so that the display handles from Android Window system could be properly imported and mapped. Next came Android window system integration for DRI software rendering backend in EGL, and lastly but most importantly came updating the documentation in Mesa for building Android support. I wrote all about this effort [here](android_swrast).

The latter half on the year had me working on improving lavapipe's integration with ChromeOs, and having Lavapipe work as a host Vulkan driver for Venus. You can see some of the changes I made in virglrenderer [here](https://gitlab.freedesktop.org/virgl/virglrenderer/-/merge_requests/1458) and crosvm [here](https://gitlab.freedesktop.org/Hazematman/crosvm/-/commit/9ee86e72edfb3a652148dd233ffca75847949558). This work is still ongoing.

## What's Next?

We're not planning to stop our 2024 momentum, and we're hopping for 2025 to be a great year for Igalia and the Linux graphics stack! I'm booked to present about [Lavapipe at Vulkanised 2025](https://www.vulkan.org/events/vulkanised-2025#agenda), where Ricardo will also present about Device-Generated Commands. Maíra & Chema will be presenting together at FOSDEM 2025 about improving performance on Raspberry Pi GPUs, and Melissa will also present about kworkflow there. We'll also be at XDC 2025, networking and presenting about all the work we are doing on the Linux graphics stack. Thanks for following our work this year, and here's to making 2025 an even better year for Linux graphics!
