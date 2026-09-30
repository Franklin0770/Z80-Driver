; It is recommended to fill padding spaces with byte variables for the 68k,
; to avoid wasting memory space and make it uneven. With padding on,
; the assembler will automatically fill odd words and longs to make them even and to avoid crashing.

; --------------------------
;		Motorola 68000
; --------------------------

	org M68K.WRAM

sampleIndex1:		ds.l 1	; Samples after Z80 routine execution
sampleIndex2:		ds.l 1
m68kSamples:		ds.w 1
z80Samples:			ds.w 1
sampleRate:			ds.w 1
frameCount:			ds.l 1
lastSample:			ds.b 1
shouldStop:			ds.b 1	; It's zero when the execution continues
noMoreFm:			ds.b 1
shouldPause:		ds.b 1
randomByte:			ds.b 1
SamplesEvery15Fr:	ds.w 1
FrameCounter15:		ds.b 1
controllerStatus:	ds.w 1
startHoldFrames:	ds.w 1
doublePcmMode:		ds.b 0

; ----------------------
;		Zilog Z80
; ----------------------

	padding off

	org $500
	odd
playedSamples:		ds.w 1	; Little-endian
refreshRegister:	ds.b 1	; Refresh register
	odd
bufferIndex:		ds.w 1	; BC in the last routine

	org $1000
SampleBuffer	; Where the 68k buffers samples

	org	$1500
CommandBuffer	; Where the 68k buffers commands (both control and data)

	padding on