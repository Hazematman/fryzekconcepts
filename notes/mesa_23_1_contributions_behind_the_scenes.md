---
layout: post
title: "Igalia's Mesa 23.1 Contributions - Behind the Scenes"
date: "2023-05-11"
last_edit: "2023-05-11"
status: 2
categories: igalia graphics mesa
cover_image: "/assets/mesa3d.svg"
---
It's an exciting time for Mesa as its next major release is unveiled this week. Igalia has played an important role in this milestone, with Eric Engestrom managing the release and 11 other Igalians contributing over 110 merge requests. A sample of these contributions are detailed below.

## radv: Implement vk.check_status
As part of an effort to enhance the reliability of GPU resets on amdgpu, Tony implemented a GPU reset notification feature in the RADV Vulkan driver. This new function improves the robustness of the RADV driver. The driver can now check if the GPU has been reset by a userspace application, allowing the driver to recover their contexts, exit, or engage in some other appropriate action.

You can read more about Tony's changes in the link below

- [https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/22253](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/22253)

## turnip: KGSL backend rewrite
With a goal of improving feature parity of the KGSL kernel mode driver with its drm counterpart, Mark has been rewriting the backend for KGSL. These changes leverage the new, common backend Vulkan infrastructure inside Mesa and fix multiple bugs. In addition, they introduce support for importing/exporting sync FDs, pre-signalled fences, and timeline semaphore support.

If you're interested in taking a deeper dive into Mark's changes, you can read the following MR:

- [https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/21651](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/21651)

##  turnip: a7xx preparation, transition to C++
Danylo has adopted a significant role for two major changes inside turnip: 1)contributing to the effort to migrate turnip to C++ and 2)supporting the next generation a7xx Adreno GPUs from Qualcomm. A more detailed overview of Danylo's changes can be found in the linked MRs below:

- [https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/21931](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/21931)
- [https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/22148](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/22148)

## v3d/v3dv various fixes & CTS conformance
Igalia maintains the v3d OpenGL driver and v3dv Vulkan drive for broadcom videocore GPUs which can be found on devices such as the Raspberry Pi. Iago, Alex and Juan have combined their expertise to implement multiple fixes for both the v3d gallium driver and the v3dv vulkan driver on the Raspberry Pi. These changes include CPU performance optimizations, support for 16-bit floating point vertex attributes, and raising support in the driver to OpenGL 3.1 level functionality. This Igalian trio has also been addressing fixes for conformance issues raised in the Vulkan 1.3.5 conformance test suite (CTS). 

You can dive into some of their Raspberry Pi driver changes here:

- [https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/22131](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/22131)
- [https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/21361](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/21361)
- [https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/20787](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/20787)

## ci, build system, and cleanup
In addition to managing the 23.1 release, Eric has also implemented many fixes in Mesa's infrastructure. He has assisted with addressing a number of CI issues within Mesa on various drivers from v3d to panfrost. Eric also dedicated part of his time to general clean-up of the Mesa code (e.g. removing duplicate functions, fixing and improving the meson-based build system, and removing dead code). 

If you're interested in seeing some of his work, check out some of the MRs below:

- [https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/22410](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/22410)
- [https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/21504](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/21504)
- [https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/21558](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/21558)
- [https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/20180](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/20180)