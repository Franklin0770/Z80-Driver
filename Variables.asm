; It is recommended to fill padding spaces with byte variables for the 68k,
; to avoid wasting memory space and make it uneven. With padding on,
; the assembler will automatically fill odd words and longs to make them even and to avoid crashing.

	org M68K_WRAM
; 68000 variables
sampleIndex:	ds.l	1
copyMusicRoutine:

	org $1500
; Z80 variables (away from code and buffers)
playedSamples:	ds.w 1	; Samples after Z80 routine execution
lastADPCMValue:	ds.b 1	; 68k's ADPCM accumulator to share to the Z80