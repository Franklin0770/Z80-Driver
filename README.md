# Codename FrankPCM: a high-tech audio driver
Hello there! I've finally found the time to write a README, where I explain the main objective of this software and its technicalities. Bare with me to know more, if you wish.

> Please note that this driver is still in experimentation and development. Not all features are here, at least for now.

## The purpose
So, as you might have read in the description, this driver aims to provide smooth 32000 Hz audio playback in the Sega Mega Drive, which nearly hits the hardware limit. Actually, due to CPU synchronization timing, the sample rate sits at ~31960 Hz, which is more or less the same, since the tiny quality loss is indistinguishable. A classic remark goes to most retro drivers written for games at the time: jittery and overall unbearable streaming sounds. This driver does its best to ensure none of this ever happens.
But obviously, what's a Mega Drive audio driver without proper FM glory? In fact, this driver also ensures FM and 8-bit command streaming, processed respectively by the both iconic YM2612 and SN76489 sound chips.

This source code also provides a useful text-based debugger that highlights the most important variables to tune timing and keep track of bugs or inconsistencies. Controls are available to tweak audio playback.

## The technical side
This driver mainly runs on both Mega Drive's CPUs, the Motorola 68000 and the Zilog Z80. It uses buffering logic to keep playback mid-frame.
The main idea resides on the 68k buffering a frame worth of samples to Z80's RAM, so the latter can write them to DAC with precise timing, by also avoiding DMA conflicts. To circumvent hardware stalls and general instability, the Z80 ROM bank feature isn't used at all (there was an attempt to use this, in another branch).
Sounds pretty standard, huh? The difference comes in the 68k buffering routine. Take a look at this example:
``` assembly
	move.b	(a5)+,(a6)	; output sample. 12

	move.l	(a0)+,d0	; get a long worth of samples
	movep.l d0,(0,a1)	; write it to Z80 RAM

	move.l	(a0)+,d0
	movep.l	d0,(8,a1)

	move.l	(a0)+,d0
	movep.l	d0,(16,a1)

	move.l	(a0)+,d0
	movep.l	d0,(24,a1)

	move.l	(a0)+,d0
	movep.l	d0,(32,a1)

	move.l	(a0)+,d0
	movep.l	d0,(40,a1)

	move.l	(a0)+,d0

	move.b	(a5)+,(a6)	; output sample. 12
	...
```
As you can see, not only the 68k takes cares of buffering, but also worries about DAC, because what happens when it goes into starvation? Not very listenable sounds get outputted. So, to keep PCM streaming alive, while the 68k does its calculations to buffer to Z80 RAM properly, it also constantly reminds itself to never miss a sample write.
But how is it possible to achieve perfect synchronization timing between the 68k and Z80 different clocks? You don't, actually. Or at least you get as close as possible. If you divide the CPU clock by the sample rate, you'll find this:

68k_clock / sample_rate = 7,670454 Hz / 32000 Hz = 239.7016875 Hz ≃ 240 Hz
z80_clock / sample_rate = 3,579545 Hz / 32000 Hz = 111.86078125 Hz ≃ 112 Hz

Frequency (Hz) is basically clock cycles so, as you may have noticed, the 68k should output a sample every 240 cycles, while the Z80 should do it every 112 cycles. The relative error is about 0.1244%, so it's pretty much perfect.

### Nice hardware tricks