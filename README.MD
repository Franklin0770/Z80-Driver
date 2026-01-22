# Notice: this logic is abandoned ad no longer in use

### The reason
Unfortunately, Z80-only logic is quite expensive for the hardware to be handled correctly. Tight-cycle loops, Z80 bank bus instabilities and overall insufficient throughput is pretty inconvenient.
This is due to the fact the DAC timing is strictly dependent on the Z80 bank bus, making it output samples inconsistently and unpredictably. Since 111 cycles is the target for 32+ kHz playback, this loop might do the trick:

```assembly
; DE: sample buffer
; HL: ROM bank window pointer (8000h-FFFFh)

; DE': sample buffer
; HL': YM2612 data bank 0 to DAC (4001h)

	; 111 cycles per iteration

$$LoadBuffer_2x:
	exx						; 4
	ld	a,(de)				; 7
	ld	(hl),a				; 7
	inc	de					; 6
	exx						; 4
	ld	a,(hl)				; 7
	ld	(de),a				; 7
	inc	hl					; 6
	inc	de					; 6
	ld	a,(hl)				; 7
	ld	(de),a				; 7
	inc	hl					; 6
	inc	de					; 6
	bit	7,h					; 8
	call z,$$NextBank		; 10
	djnz $$LoadBuffer_2x	; 13
```

...while it actually doesn't, because each time the Z80 accesses the bank window, there's a [3.3 cycle delay](https://plutiedev.com/mirror/kabuto-hardware-notes#bus-system), which makes the loop run slower (unfeasible for 32 kHz playback).
Checking if the window has surpassed the FFFFh limit each time we read ROM is quite heavy to keep a constant 111-cycle loop and to load the buffer in time. Furthermore, I think making the 68k buffer to RAM is faster than making it stall by the bus arbiter for longer with slower Z80 ROM reads. Haven't tried it yet, but I'll do some tests to make sure the previous design' buffering routine is faster.

Either way, this was a nice test which was needed to check if reserving all audio tasks to the Z80 was feasible or not. Now we know!
