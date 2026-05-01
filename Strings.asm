	align 2
	save
	listing off
	charset "Assets/character_mapping.bin"

DebugText:
	dfntxt "Sample Index: $", 0, 0
	dfntxt "Z80 Samples Per-frame: $", 0, 1
	dfntxt "Last 68k Sample: $", 0, 2
	dfntxt "Z80 Refresh Register: $", 0, 3
	dfntxt "Frame Number: $", 0, 4

	dfntxt "Press A to play a note", 0, 7
	dfntxt "Press B to play a note continuously", 0, 8
	dfntxt "Press C to restart the music", 0, 9

	restore

ValueInformation:
	dc.l sampleIndex					; Variable address
	dc.l vdpCoordinates(15,0)			; VDP coordinates
	dc.w PrintLong-PrintValues.Base-2	; Jump offset

	dc.l z80Samples
	dc.l vdpCoordinates(24,1)
	dc.w PrintWord-PrintValues.Base-2

	dc.l lastSample
	dc.l vdpCoordinates(18,2)
	dc.w PrintByte-PrintValues.Base-2

	dc.l randomByte
	dc.l vdpCoordinates(23,3)
	dc.w PrintByte-PrintValues.Base-2

	dc.l frameCount
	dc.l vdpCoordinates(15,4)
	dc.w PrintLong-PrintValues.Base-2