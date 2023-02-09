---
title: "2022 Graphics Team Contributions at Igalia"
date: "2023-02-02"
last_edit: "2023-02-02"
status: 3
cover_image: "/assets/igalia_logo.png"
categories: igalia graphics
---

This year I started a new job working with [Igalia's Graphics Team](https://www.igalia.com/technology/graphics). For those of you who don't know [Igalia](https://www.igalia.com/) they are a ["worker-owned, employee-run cooperative model consultancy focused on open source software"](https://en.wikipedia.org/wiki/Igalia).

As a new member of the team, I thought it would be a great idea to summarize the incredible amount of work the team completed in 2022. If you're interested keep reading!

## Vulkan 1.2 Conformance on RPi 4
One of the big milestones for the team in 2022 was [achieving Vulkan 1.2 conformance on the Raspberry Pi 4](https://www.khronos.org/conformance/adopters/conformant-products#submission_694). The folks over at the Raspberry Pi company wrote a nice [article](https://www.raspberrypi.com/news/vulkan-update-version-1-2-conformance-for-raspberry-pi-4/) about the achievement. Igalia has been partnering with the Raspberry Pi company to bring build and improve the graphics driver on all versions of the Raspberry Pi.

The Vulkan 1.2 spec ratification came with a few [extensions](https://registry.khronos.org/vulkan/specs/1.2-extensions/html/vkspec.html#versions-1.2) that were promoted to Core. This means a conformant Vulkan 1.2 driver needs to implement those extensions. Alejandro Piñeiro wrote this interesting [blog post](https://blogs.igalia.com/apinheiro/2022/05/v3dv-status-update-2022-05-16/) that talks about some of those extensions.

Vulkan 1.2 also came with a number of optional extensions such as `VK_KHR_pipeline_executable_properties`. My colleague Iago Toral wrote an excellent [blog post](https://blogs.igalia.com/itoral/2022/05/09/vk_khr_pipeline_executables/) on how we implemented that extension on the Raspberry Pi 4 and what benefits it provides for debugging.

## Vulkan 1.3 support on Turnip
Igalia has been heavily supporting the Open-Source Turnip Vulkan driver for Qualcomm Adreno GPUs, and in 2022 we helped it achieve Vulkan 1.3 conformance. Danylo Piliaiev on the graphics team here at Igalia, wrote a great [blog post](https://blogs.igalia.com/dpiliaiev/turnip-vulkan-1-3/) on this achievement! One of the biggest challenges for the Turnip driver is that it is a completely reverse-engineered driver that has been built without access to any hardware documentation or reference driver code.

With Vulkan 1.3 conformance has also come the ability to run more commercial games on Adreno GPUs through the use of the DirectX translation layers. If you would like to see more of this check out this [post](https://blogs.igalia.com/dpiliaiev/turnip-july-2022-update/) from Danylo where he talks about getting "The Witcher 3", "The Talos Principle", and "OMD2" running on the A660 GPU. Outside of Vulkan 1.3 support he also talks about some of the extensions that were implemented to allow "Zink" (the OpenGL over Vulkan driver) to run Turnip, and bring OpenGL 4.6 support to Adreno GPUs.

![](youtube:oVFWy25uiXA)

## Vulkan Extensions
Several developers on the Graphics Team made several key contributions to Vulkan Extensions and the Vulkan conformance test suite (CTS). My colleague Ricardo Garcia made an excellent [blog post](https://rg3.name/202212122137.html) about those contributions. Below I've listed what Igalia did for each of the extensions:

- VK_EXT_image_2d_view_of_3d
    - We reviewed the spec and are listed as contributors to this extension
- VK_EXT_shader_module_identifier
    - We reviewed the spec, contributed to it, and created tests for this extension
- VK_EXT_attachment_feedback_loop_layout
    - We reviewed, created tests and contributed to this extension 
- VK_EXT_mesh_shader
    - We contributed to the spec and created tests for this extension
- VK_EXT_mutable_descriptor_type
    - We reviewed the spec and created tests for this extension
- VK_EXT_extended_dynamic_state3
    - We wrote tests and reviewed the spec for this extension

## AMDGPU kernel driver contributions
Our resident "Not an AMD expert" Melissa Wen made several contributions to the AMDGPU driver. Those contributions include connecting parts of the [pixel blending and post blending code in AMD's `DC` module to `DRM`](https://lore.kernel.org/amd-gfx/20220329201835.2393141-1-mwen@igalia.com/) and [fixing a bug related to how panel orientation is set when a display is connected](https://lore.kernel.org/amd-gfx/20220804161349.3561177-1-mwen@igalia.com/). She also had a [presentation at XDC 2022](https://indico.freedesktop.org/event/2/contributions/50/), where she talks about techniques you can use to understand and debug AMDGPU, even when there aren't hardware docs available.

André Almeida also completed and submitted work on [enabled logging features for the new GFXOFF hardware feature in AMD GPUs](https://lore.kernel.org/dri-devel/20220714191745.45512-1-andrealmeid@igalia.com/). He also created a userspace application (which you can find [here](https://gitlab.freedesktop.org/andrealmeid/gfxoff_tool)), that lets you interact with this feature through the `debugfs` interface. Additionally, he submitted a [patch](https://lore.kernel.org/dri-devel/20220929184307.258331-1-contact@emersion.fr/) for async page flips (which he also talked about in his [XDC 2022 presentation](https://indico.freedesktop.org/event/2/contributions/61/)) which is still yet to be merged.

## Modesetting without Glamor on RPi
Christopher Michael joined the Graphics Team in 2022 and along with Chema Casanova made some key contributions to enabling hardware acceleration and mode setting on the Raspberry Pi without the use of [Glamor](https://www.freedesktop.org/wiki/Software/Glamor/) which allows making more video memory available to graphics applications running on a Raspberry Pi. 

The older generation Raspberry Pis (1-3) only have a maximum of 256MB of memory available for video memory, and using Glamor will consume part of that video memory. Christopher wrote an excellent [blog post](https://blogs.igalia.com/cmichael/2022/05/30/modesetting-a-glamor-less-rpi-adventure/) on this work. Both him and Chema also had a joint presentation at XDC 2022 going into more detail on this work.

## Linux Format Magazine Column
Our very own Samuel Iglesias had a column published in Linux Format Magazine. It's a short column about reaching Vulkan 1.1 conformance for v3dv & Turnip Vulkan drivers, and how Open-Source GPU drivers can go from a "hobby project" to the defacto driver for the platform. Check it out on page 7 of [issue #288](https://linuxformat.com/linux-format-288.html)!

## XDC 2022
X.Org Developers Conference is one of the big conferences for us here at the Graphics Team. Last year at XDC 2022 our Team presented 5 talks in Minneapolis, Minnesota. XDC 2022 took place towards the end of the year in October, so it provides some good context on how the team closed out the year. If you didn't attend or missed their presentation, here's a breakdown:

### ["Replacing the geometry pipeline with mesh shaders"](https://indico.freedesktop.org/event/2/contributions/48/) (Ricardo García)
Ricardo presents what exactly mesh shaders are in Vulkan. He made many contributions to this extension including writing 1000s of CTS tests for this extension with a [blog post](https://rg3.name/202210222107.html) on his presentation that should check out!

![](youtube:aRNJ4xj_nDs)

### ["Status of Vulkan on Raspberry Pi"](https://indico.freedesktop.org/event/2/contributions/68/) (Iago Toral)
Iago goes into detail about the current status of the Raspberry Pi Vulkan driver. He talks about achieving Vulkan 1.2 conformance, as well as some of the challenges the team had to solve due to hardware limitations of the Broadcom GPU.

![](youtube:GM9IojyzCVM)

### ["Enable hardware acceleration for GL applications without Glamor on Xorg modesetting driver"](https://indico.freedesktop.org/event/2/contributions/60/) (Jose María Casanova, Christopher Michael)
Chema and Christopher talk about the challenges they had to solve to enable hardware acceleration on the Raspberry Pi without Glamor.

![](youtube:Bo_MOM7JTeQ)

### ["I’m not an AMD expert, but..."](https://indico.freedesktop.org/event/2/contributions/50/) (Melissa Wen)
In this non-technical presentation, Melissa talks about techniques developers can use to understand and debug drivers without access to hardware documentation.

![](youtube:CMm-yhsMB7U)

### ["Async page flip in atomic API"](https://indico.freedesktop.org/event/2/contributions/61/) (André Almeida)
André talks about the work that has been done to enable asynchronous page flipping in DRM's atomic API with an introduction to the topic by explaining about what exactly is asynchronous page flip, and why you would want it.

![](youtube:qayPPIfrqtE)

## FOSDEM 2022
Another important conference for us is FOSDEM, and last year we presented 3 of the 5 talks in the graphics dev room. FOSDEM took place in early February 2022, these talks provide some good context of where the team started in 2022.

### [The status of Turnip driver development](https://archive.fosdem.org/2022/schedule/event/turnip/) (Hyunjun Ko)

Hyunjun presented the current state of the Turnip driver, also talking about the difficulties of developing a driver for a platform without hardware documentation. He talks about how Turnip developers reverse engineer the behaviour of the hardware, and then implement that in an open-source driver. He also made a companion [blog post](https://blogs.igalia.com/zzoon/graphics/mesa/2022/02/21/complement-story/) to checkout along with his presentation.

### [v3dv: Status Update for Open Source Vulkan Driver for Raspberry Pi 4](https://archive.fosdem.org/2022/schedule/event/v3dv/) (Alejandro Piñeiro)

Igalia has been presenting the status of the v3dv driver since December 2019 and in this presentation, Alejandro talks about the status of the v3dv driver in early 2022. He talks about achieving conformance, the extensions that had to be implemented, and the future plans of the v3dv driver.

### [Fun with border colors in Vulkan](https://archive.fosdem.org/2022/schedule/event/vulkan_borders/) (Ricardo Garcia)

Ricardo presents about the work he did on the `VK_EXT_border_color_swizzle` extension in Vulkan. He talks about the specific contributions he did and how the extension fits in with sampling color operations in Vulkan.

## GSoC & Igalia CE
Last year Melissa & André co-mentored contributors working on introducing KUnit tests to the AMD display driver. This project was hosted as a ["Google Summer of Code" (GSoC)](https://summerofcode.withgoogle.com/) project from the X.Org Foundation. If you're interested in seeing their work Tales da Aparecida, Maíra Canal, Magali Lemes, and Isabella Basso presented their work at the [Linux Plumbers Conference 2022](https://lpc.events/event/16/contributions/1310/) and across two talks at XDC 2022. Here you can see their [first](https://indico.freedesktop.org/event/2/contributions/65/) presentation and here you can see their [second](https://indico.freedesktop.org/event/2/contributions/164/) second presentation.

André & Melissa also mentored two ["Igalia Coding Experience" (CE)](https://www.igalia.com/coding-experience/) projects, one related to IGT GPU test tools on the VKMS kernel driver, and the other for IGT GPU test tools on the V3D kernel driver. If you're interested in reading up on some of that work, Maíra Canal [wrote about her experience](https://mairacanal.github.io/january-update-finishing-my-igalia-ce/) being part of the Igalia CE.

Ella Stanforth was also part of the Igalia Coding Experience, being mentored by Iago & Alejandro. They worked on the `VK_KHR_sampler_ycbcr_conversion` extension for the v3dv driver. Alejandro talks about their work in his [blog post here](https://blogs.igalia.com/apinheiro/2023/01/v3dv-status-update-2023-01/).

# Whats Next?
The graphics team is looking forward to having a jam-packed 2023 with just as many if not more contributions to the Open-Source graphics stack! I'm super excited to be part of the team, and hope to see my name in our 2023 recap post!

Also, you might have heard that [Igalia will be hosting XDC 2023](https://www.igalia.com/2022/xdc-2023) in the beautiful city of A Coruña! We hope to see you there where there will be many presentations from all the great people working on the Open-Source graphics stack, and most importantly where you can [dream in the Atlantic!](https://www.youtube.com/watch?v=7hWcu8O9BjM)

![Photo of A Coruña](https://www.igalia.com/assets/i/news/XDC-event-banner.jpg)
