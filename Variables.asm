; It is recommended to fill padding spaces with byte variables for the 68k,
; to avoid wasting memory space and make it uneven. With padding on,
; the assembler will automatically fill odd words and longs to make them even and to avoid crashing.

; --------------------------
;		Motorola 68000
; --------------------------

	org M68K_WRAM

sampleIndex:	ds.l 1	; Samples after Z80 routine execution
shouldStop:		ds.b 1	; It's zero when the execution continues

; ----------------------
;		Zilog Z80
; ----------------------

	padding	off
	org $501

playedSamples:	ds.w 1	; Little-endian

	org $1000
SampleBuffer

	padding on