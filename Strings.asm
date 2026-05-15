	align 2
	save
	listing off
	charset "Assets/character_mapping.bin"

StaticText:
	dfntxt "ROM Sample Index:", 0, 0
	dfntxt "Z80 Samples Per-frame:", 0, 1
	dfntxt "Last 68k Sample:", 0, 2
	dfntxt "Z80 Buffer Index (BC):", 0, 3
	dfntxt "Z80 PC Before Interrupt:", 0, 4
	dfntxt "Z80 Refresh Register:", 0, 5
	dfntxt "Frame Number:", 0, 6

	dfntxt "Press A to play a note", 0, 9
	dfntxt "Hold B to play a note every frame", 0, 10
	dfntxt "Press C to restart the music", 0, 11
	dfntxt "Press Right or Up to skip forward", 0, 12
	dfntxt "Press Left or Down to skip backward", 0, 13

HaltMessage:
	dfntxt "All CPUs are halted now.", 0, 18
	dfntxt "Please reset to re-listen.", 0, 19

	restore

ValueInformation:
	dc.l sampleIndex						; variable address
	dc.l vdpCoordinates(25,0)				; VDP coordinates
	dc.w PrintLong-UpdateDebugger.base-2	; jump offset

	dc.l z80Samples
	dc.l vdpCoordinates(25,1)
	dc.w PrintWord-UpdateDebugger.base-2

	dc.l lastSample
	dc.l vdpCoordinates(25,2)
	dc.w PrintByte-UpdateDebugger.base-2

	dc.l z80BufferIndex
	dc.l vdpCoordinates(25,3)
	dc.w PrintWord-UpdateDebugger.base-2

	dc.l z80InterruptPc
	dc.l vdpCoordinates(25,4)
	dc.w PrintWord-UpdateDebugger.base-2

	dc.l randomByte
	dc.l vdpCoordinates(25,5)
	dc.w PrintByte-UpdateDebugger.base-2

	dc.l frameCount
	dc.l vdpCoordinates(25,6)
	dc.w PrintLong-UpdateDebugger.base-2