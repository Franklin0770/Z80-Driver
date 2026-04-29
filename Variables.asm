; It is recommended to fill padding spaces with byte variables for the 68k,
; to avoid wasting memory space and make it uneven. With padding on,
; the assembler will automatically fill odd words and longs to make them even and to avoid crashing.

; --------------------------
;		Motorola 68000
; --------------------------

	org M68K.WRAM

sampleIndex:	ds.l 1	; Samples after Z80 routine execution
z80Samples:		ds.w 1
frameCount:		ds.l 1
lastSample:		ds.b 1
;shouldStop:		ds.b 1	; It's zero when the execution continues
noMoreFm:		ds.b 1
randomByte:		ds.b 1
controllerStatus:	ds.w 1

; ----------------------
;		Zilog Z80
; ----------------------

	padding	off
	
	org $501
playedSamples:		ds.w 1	; Little-endian
refreshRegister:	ds.b 1	; Refresh register

	org $1000
SampleBuffer	; Where the 68k buffers samples

	org	$1500
CommandBuffer	; Where the 68k buffers commands (both control and data)

	padding on