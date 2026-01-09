; It is recommended to fill padding spaces with byte variables for the 68k,
; to avoid wasting memory space and make it uneven. With padding on,
; the assembler will automatically fill odd words and longs to make them even and to avoid crashing.

	org $FFFF0000
; 68000 variables

WRAM_Code:	ds.b $1000

	cpu	Z80

	org 500h
; Z80 variables (away from code)

sampleIndex_High:	ds 1
sampleIndex_Low:	ds 2	; Little-endian

	org	1000h
sampleBuffer:	ds 512