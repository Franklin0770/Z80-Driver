# Codename FrankPCM: a high-tech audio driver
Hello there! I've finally found the time to write a README, where I explain the main objective of this software and its technicalities. Bare with me to know more, if you wish.

> Please note that this driver is still in experimentation and development. Not all features are here, at least for now.

## The purpose
So, as you might have read in the description, this driver aims to provide smooth 32000 Hz audio playback in the Sega Mega Drive, which nearly hits the hardware limit. Actually, due to CPU synchronization timing, the sample rate sits at ~31960 Hz, which is more or less the same, since the tiny quality loss is indistinguishable. A classic remark goes to most retro drivers written for games at the time: jittery and overall unbearable streaming sounds. This driver does its best to ensure none of this ever happens.

You have two modes to achieve double simultaneous audio playback:
- By halving sample rate (to 15980 Hz), but keeping the bit-depth the same (to 8-bit);
- By halving the bit-depth (to 7-bit), but keeping the sample rate (to 31960 Hz).

But obviously, what's a Mega Drive audio driver without proper FM glory? In fact, this driver also ensures FM and 8-bit command streaming, processed respectively by the both iconic YM2612 and SN76489 sound chips.

This source code also provides a useful text-based debugger that highlights the most important variables to tune timing and keep track of bugs or inconsistencies. Controls are available to tweak audio playback.

## How to compile the code
This source code is meant to run on [Mega Driven Environment](https://marketplace.visualstudio.com/items?itemName=Brotherhood0.megaenvironment), a Visual Studio Code extension. Install Mega Driven Environment, open the repository as a folder and use the standard AS build to assemble (you don't need to tweak anything).
___
Welcome to the bottom of this README. If you want to know more, check the [wiki](https://github.com/Franklin0770/Z80-Driver/wiki) out to delve deeper into the technical nature of this audio driver!
