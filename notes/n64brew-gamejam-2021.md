---
title: "N64Brew GameJam 2021"
date: "2021-12-10"
last_edit: "2023-01-20"
tags: 
  - "3d"
  - "homebrew"
  - "n64"
  - "n64brew"
  - "nintendo64"
cover_image: "/assets/2021-12-10-n64brew-gamejam-2021/bug_3.png"
status: 3
---

So this year, myself and two others decided to participate together in the N64Brew homebrew GameJam, where we were supposed to build a homebrew game that would run on a real Nintendo 64. The game jam took place from October 8th until December 8th and was the second GameJam in N64Brew history. Unfortunately, we never ended up finishing the game, but we did build a really cool tech demo. Our project was called "Bug Game", and if you want to check it out you can find it [here](https://hazematman.itch.io/bug-game). To play the game you'll need a flash cart to load it on a real Nintendo 64, or you can use an accurate emulator such as [ares](https://ares.dev/) or [cen64](https://github.com/n64dev/cen64). The reason an accurate emulator is required is that we made use of this new open source 3D microcode for N64 called "[ugfx](https://github.com/snacchus/libdragon/tree/ugfx)", created by the user Snacchus. This microcode is part of the Libdragon project, which is trying to build a completely open source library and toolchain to build N64 games, instead of relying on the official SDK that has been leaked to the public through liquidation auctions of game companies that have shut down over the years.

<div class="gallery">
![](/assets/2021-12-10-n64brew-gamejam-2021/bug_1.png)
![](/assets/2021-12-10-n64brew-gamejam-2021/bug_2.png)
![](/assets/2021-12-10-n64brew-gamejam-2021/bug_4.png)
![](/assets/2021-12-10-n64brew-gamejam-2021/bug_5.png)
![](/assets/2021-12-10-n64brew-gamejam-2021/bug_3.png)

Screenshots of Bug Game
</div>
    
## Libdragon and UGFX

Ugfx was a brand new development in the N64 homebrew scene. By complete coincidence, Snacchus happened to release it on September 21st, just weeks before the GameJam was announced. There have been many attempts to create an open source 3D microcode for the N64 (my [libhfx](https://github.com/Hazematman/libhfx) project included), but ugfx was the first project to complete with easily usable documentation and examples. This was an exciting development for the open source N64 brew community, as for the first time we could build 3D games that ran on the N64 without using the legally questionable official SDK. I jumped at the opportunity to use this and be one of the first fully 3D games running on Libdragon.

One of the "drawbacks" of ufgx was that it tried to follow a lot of the design decisions the official 3D microcode for Nintendo used. This made it easier for people familiar with the official SDK to jump ship over to libdragon, but also went against the philosophy of the libdragon project to provide simple easy to use APIs. The Nintendo 64 was notoriously difficult to develop for, and one of the reasons for that was because of the extremely low level interface that the official 3D microcodes provided. Honestly writing 3D graphics code on the N64 reminds me more of writing a 3D OpenGL graphics driver (like I do in my day job), than building a graphics application. Unnecessarily increasing the burden of entry to developing 3D games on the Nintendo 64. Now that ugfx has been released, there is an ongoing effort in the community to revamp it and build a more user friendly API to access the 3D functionality of the N64.

## Ease of development

One of the major selling points of libdragon is that it tries to provide a standard toolchain with access to things like the c standard library as well as the c++ standard library. To save time on the development of bug game, I decided to put that claim to test. When building a 3D game from scratch two things that can be extremely time consuming are implementing linear algebra operations, and implementing physics that work in 3D. Luckily for modern developers, there are many open source libraries you can use instead of building these from scratch, like [GLM](https://glm.g-truc.net/0.9.9/) for math operations and [Bullet](https://github.com/bulletphysics/bullet3) for physics. I don't believe anyone has tried to do this before, but knowing that libdragon provides a pretty standard c++ development environment I tried to build GLM and Bullet to run on the Nintendo 64 and I was successful! Both GLM and Bullet were able to run on real N64 hardware. This saved time during development as we were no longer concerned with having to build our own physics or math libraries. There were some tricks I needed to do to get bullet running on the hardware.

First bullet will allocate more memory for its internal pools than is available on the N64. This is an easy fix as you can adjust the heap sizes when you go to initialize Bullet using the below code:

```c++
btDefaultCollisionConstructionInfo constructionInfo = btDefaultCollisionConstructionInfo();
constructionInfo.m_defaultMaxCollisionAlgorithmPoolSize = 512;
constructionInfo.m_defaultMaxPersistentManifoldPoolSize = 512;
btDefaultCollisionConfiguration* collisionConfiguration = new btDefaultCollisionConfiguration(constructionInfo);
```

This lets you modify the memory pools and specify a size in KB for the pools to use. The above code will limit the internal pools to 1MB, allowing us to easily run within the 4MB of RAM that is available on the N64 without the expansion pak (an accessory to the N64 that increases the available RAM to 8MB).

The second issue I ran into with bullet was that the N64 floating point unit does not implement de-normalized floating point numbers. Now I'm not an expert in floating point numbers, but from my understanding, de-normalized numbers are a way to represent values between the smallest normal floating point number and zero. This allows floating point calculations to slowly fall towards zero in a more accurate way instead of rounding directly to zero. Since the N64 CPU does not implement de-normalized floats, if any calculations would have generated de-normalized float on the N64 they would instead cause a floating point exception. Because of the way the physics engine works, when two objects got very close together this would cause de-normalized floats to be generated and crash the FPU. This was a problem that had me stumped for a bit, I was concerned I would have to go into bullet's source code and modify and calculations to round to zero if the result would be small enough. This would have been a monumental effort! Thankfully after digging through the NEC VR4300 programmer's manual I was able to discover that there is a mode you can set the FPU to, which forces rounding towards zero if a de-normalized float would be generated. I enabled this mode and tested it out, and all my floating point troubles were resolved! I submitted a [pull request](https://github.com/DragonMinded/libdragon/pull/195) (that was accepted) to the libdragon project to have this implemented by default, so no one else will run into the same annoying problems I ran into.

## What's next?

If you decided to play our game you probably would have noticed that it's not very much of a game. Even though this is the case I'm very happy with how the project turned out, as it's one of the first 3D libdragon projects to be released. It also easily makes use of amazing open technologies like bullet physics, showcasing just how easy libdragon is to integrate with modern tools and libraries. As I mentioned before in this post there is an effort to take Snacchus's work and build an easier to use graphics API that feels more like building graphics applications and less like building a graphics driver. The effort for that has already started and I plan to contribute to it. Some of the cool features this effort is bringing are:

- A standard interface for display lists and microcode overlays. Easily allowing multiple different microcodes to seamless run on the RSP and swap out with display list commands. This will be valuable for using the RSP for audio and graphics at the same time.
- A new 3D microcode that takes some lessons learned from ugfx to build a more powerful and easier to use interface.

Overall this is an exciting time for Nintendo 64 homebrew development! It's easier than ever to build homebrew on the N64 without knowing about the arcane innards of the console. I hope that this continued development of libdragon will bring more people to the scene and allow us to see new and novel games running on the N64. One project I would be excited to start working on is using the serial port on modern N64 Flashcarts for networking, allowing the N64 to have online multiplayer through a computer connected over USB. I feel that projects like this could really elevate the kind of content that is available on the N64 and bring it into the modern era.
