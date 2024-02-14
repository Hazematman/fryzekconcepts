---
title: "A Dive into Vulkanised 2024"
date: "2024-02-14"
last_edit: "2024-02-14"
status: 3
cover_image: "/assets/vulkanised_2024/vulkanized_logo_web.jpg"
categories: igalia graphics
---

![Vulkanized sign at google's office](/assets/vulkanised_2024/vulkanized_logo_web.jpg)

Last week I had an exciting opportunity to attend the Vulkanised 2024 conference. For those of you not familar with the event, it is ["The Premier Vulkan Developer Conference"](https://vulkan.org/events/vulkanised-2024) hosted by the Vulkan working group from Khronos. With the excitement out of the way, I decided to write about some of the interesting information that came out of the conference.

## A Few Presentations

My colleagues Iago, Stéphane, and Hyunjun each had the opportunity to present on some of their work into the wider Vulkan ecosystem.

![Stéphane and Hyujun presenting](/assets/vulkanised_2024/vulkan_video_web.jpg)

Stéphane & Hyunjun presented "Implementing a Vulkan Video Encoder From Mesa to Streamer". They jointly talked about the work they performed to implement the Vulkan video extensions in Intel's ANV Mesa driver as well as in GStreamer. This was an interesting presentation because you got to see how the new Vulkan video extensions affected both driver developers implementing the extensions and application developers making use of the extensions for real time video decoding and encoding. [Their presentation is available on vulkan.org](https://vulkan.org/user/pages/09.events/vulkanised-2024/vulkanised-2024-stephane-cerveau-ko-igalia.pdf).

![Iago presenting](/assets/vulkanised_2024/opensource_vulkan_web.jpg)

Later my colleague Iago presented jointly with Faith Ekstrand (a well-known Linux graphic stack contributor from Collabora) on "8 Years of Open Drivers, including the State of Vulkan in Mesa". They both talked about the current state of Vulkan in the open source driver ecosystem, and some of the benefits open source drivers have been able to take advantage of, like the common Vulkan runtime code and a shared compiler stack. You can check out [their presentation for all the details](https://vulkan.org/user/pages/09.events/vulkanised-2024/Vulkanised-2024-faith-ekstrand-collabora-Iago-toral-igalia.pdf).

Besides Igalia's presentations, there were several more which I found interesting, with topics such as Vulkan developer tools, experiences of using Vulkan in real work applications, and even how to teach Vulkan to new developers. Here are some highlights for some of them.

### [Using Vulkan Synchronization Validation Effectively](https://vulkan.org/user/pages/09.events/vulkanised-2024/vulkanised-2024-john-zulauf-lunarg.pdf)
John Zulauf had a presentation of the Vulkan synchronization validation layers that he has been working on. If you are not familiar with these, then you should really check them out. They work by tracking how resources are used inside Vulkan and providing error messages with some hints if you use a resource in a way where it is not synchronized properly. It can't catch every error, but it's a great tool in the toolbelt of Vulkan developers to make their lives easier when it comes to debugging synchronization issues. As John said in the presentation, synchronization in Vulkan is hard, and nearly every application he tested the layers on reveled a synchronization issue, no matter how simple it was. He can proudly say he is a vkQuake contributor now because of these layers.

### [6 Years of Teaching Vulkan with Example for Video Extensions](https://vulkan.org/user/pages/09.events/vulkanised-2024/vulkanised-2024-helmut-hlavacs.pdf)
This was an interesting presentation from a professor at the university of Vienna about his experience teaching graphics as well as game development to students who may have little real programming experience. He covered the techniques he uses to make learning easier as well as resources that he uses. This would be a great presentation to check out if you're trying to teach Vulkan to others.

### [Vulkan Synchronization Made Easy](https://vulkan.org/user/pages/09.events/vulkanised-2024/vulkanised-2024-grigory-dzhavadyan.pdf)
Another presentation focused on Vulkan sync, but instead of debugging it, Grigory showed how his graphics library abstracts sync away from the user without implementing a render graph. He presented an interesting technique that is similar to how the sync validation layers work when it comes ensuring that resources are always synchronized before use. If you're building your own engine in Vulkan, this is definitely something worth checking out.

### [Vulkan Video Encode API: A Deep Dive](https://vulkan.org/user/pages/09.events/vulkanised-2024/vulkanised-2024-tony-zlatinski-nvidia.pdf)
Tony at Nvidia did a deep dive into the new Vulkan Video extensions, explaining a bit about how video codecs work, and also including a roadmap for future codec support in the video extensions. Especially interesting for us was that he made a nice call-out to Igalia and our work on Vulkan Video CTS and open source driver support on slide (6) :)

## Thoughts on Vulkanised

Vulkanised is an interesting conference that gives you the intersection of people working on Vulkan drivers, game developers using Vulkan for their graphics backend, visual FX tool developers using Vulkan-based tools in their pipeline, industrial application developers using Vulkan for some embedded commercial systems, and general hobbyists who are just interested in Vulkan. As an example of some of these interesting audience members, I got to talk with a member of the Blender foundation about his work on the Vulkan backend to Blender.

Lastly the event was held at Google's offices in Sunnyvale. Which I'm always happy to travel to, not just for the better weather (coming from Canada), but also for the amazing restaurants and food that's in the Bay Area!

![Great bay area food](/assets/vulkanised_2024/food_web.jpg)
