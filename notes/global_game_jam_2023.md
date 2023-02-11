---
title: "Global Game Jam 2023 - GI Jam"
date: "2023-02-11"
last_edit: "2023-02-11"
status: 2
cover_image: "/assets/global_game_jam_2023/screen_shot_2.png"
categories: gamedev
---

At the beginning of this month I participated in the Games Institutes's
Global Game Jam event. [The Games
Institute](https://uwaterloo.ca/games-institute/) is an organization at
my local university (The University of Waterloo) that focuses on
games-based research. They host a game jam every school term and this
term's jam happened to coincide with the Global Game Jam. Since this
event was open to everyone (and it's been a few years since I've been a
student at UW 👴️), I joined up to try and stretch some of my more
creative muscles. The event was a 48-hour game jam that began on Friday,
February 3rd and ended on Sunday,February 5th.

The game we created is called [Turtle
Roots](https://globalgamejam.org/2023/games/turtle-roots-5), and it is a
simple resource management game. You play as a magical turtle floating
through the sky and collecting water in order to survive. The turtle can
spend some of its "nutrients" to grow roots which will allow it to
gather water and collect more nutrients. The challenge in the game is
trying to survive for as long as possible without running out of water.

<div class="gallery">
![](/assets/global_game_jam_2023/screen_shot_1.png)
![](/assets/global_game_jam_2023/screen_shot_2.png)
![](/assets/global_game_jam_2023/screen_shot_3.png)

Screenshots of Turtle Roots
</div>
 

The game we created is called [Turtle Roots](https://globalgamejam.org/2023/games/turtle-roots-5), and it is a 
simple resource management game. You play as a magical turtle floating through the sky and collecting water
in order to survive. The turtle can spend some of its “nutrients” to grow roots which will allow it to gather 
water and collect more nutrients. The challenge in the game is trying to survive for as long as possible without 
running out of water.

## The Team

I attended the event solo and quickly partnered up with two other people, who also attended solo. One member had 
already participated in a game jam before and specialized in art. The other member was attending a game jam for 
the first time and was looking for the best way they could contribute. Having particular skills for sound, they 
ended up creating all the audio in our game. This left me as the sole programmer for our team.

## My Game Jam Experiences

In recent years,I participated in a [Nintendo 64 homebrew game
jam](n64brew-gamejam-2021) and the
Puerto Rico Game Developers Association event for the global game jam,
submitting [Magnetic
Parkour](https://globalgamejam.org/2022/games/magnetic-parkour-6), I
also participated in [Ludum Dare](https://ldjam.com/) back around 2013
but unfortunately I've since lost the link to my submission. While in
high school, my friend and I participated in the "Ottawa Tech Jame"
(similar to a game jam), sort of worked like a game jam called "Ottawa
Tech Jam" submitting [Zorv Warz](http://www.fastquake.com/projects/zorvwarz/) and
[E410](http://www.fastquake.com/projects/worldseed/). As you can
probably tell, I really like gamedev. The desire to build my own video
games is actually what originally got me into programming. When I was
around 14 years old, I picked up a C++ programming book from the library
since I wanted to try to build my own game and I heard most game
developers use C++. I used some proprietary game development library
(that I can't recall the name of)to build 2D and 3D games in Windows
using C++. I didn't really get too far into it until high school when I
started to learn SFML, SDL, and OpenGL. I also dabbled with Unity during
that time as well. However,I've always had a strong desire to build most
of the foundation of the game myself without using an engine. You can
see this desire really come out in the work I did for Zorv Warz, E410,
and the N64 homebrew game jam. When working with a team, I feel it can
be a lot easier to use a game engine, even if it doesn't scratch the
same itch for me.

## The Tech Behind the Game

Lately I've had a growing interest in the game engine called
[Godot](https://godotengine.org/), and wanted to use this opportunity to
learn the engine more and build a game in it. Godot is interesting to me
as its a completely open source game engine, and as you can probably
guess from my [job](2022_igalia_graphics_team), open source software as well as 
free software is something I'm particularly interested in.

Godot is a really powerful game engine that handles a lot of complexity
for you. For example,it has a built in parallax background component,
that we took advantage of to add more depth to our game. This allows you
to control the background scrolling speed for different layer of the
background, giving the illusion of depth in a 2D game.

Another powerful feature of Godot is its physics engine. Godot makes it
really easy to create physics objects in your scene and have them do
interesting stuff. You might be wondering where physics comes into play
in our game, and we actually use it for the root animations. I set up a
sort of "rag doll" system for the roots to make them flop around in the
air as the player moves, really giving a lot more "life" to an otherwise
static game.

Godot has a built in scripting language called "GDScript" which is very
similar to Python. I've really grown to like this language. It has an
optional type system you can take advantage of that helps with reducing
the number of bugs that exist in your game. It also has great
connectivity with the editor. This proved useful as I could "export"
variables in the game and allow my team members to modify certain
parameters of the game without knowing any programming. This is super
helpful with balancing, and more easily allows non-technical members of
team to contribute to the game logic in a more concrete way.

Overall I'm very happy with how our game turned out. Last year I tried
to participate in a few more game jams, but due to a combination of lack
of personal motivation, poor team dynamics, and other factors, none of
those game jams panned out. This was the first game jam in a while where
I feel like I really connected with my team and I also feel like we made
a super polished and fun game in the end.
