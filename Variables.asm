; It is recommended to fill padding spaces with byte variables for the 68k,
; to avoid wasting memory space and make it uneven. With padding on,
; the assembler will automatically fill odd words and longs to make them even and to avoid crashing.

	org $FFFF0000
; 68000 variables
sampleIndex:	ds.l 1	; Samples after Z80 routine execution

	org $300
; Z80 variables (away from code)
