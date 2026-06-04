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
	dfntxt "Press Start to pause or resume playback", 0, 14

PauseMessage:
	dfntxt "Playback paused.", 0, 19

HaltMessage:
	dfntxt "All CPUs are halted now.", 0, 19
	dfntxt "Please reset to re-listen.", 0, 20

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

Messages:
	dfntxt "Unfortunately, the Sega Mega Drive", 0, 0
	dfntxt "has crashed! I'm sorry :(", 0, 1
	dfntxt "If you want to know more,", 0, 2
	dfntxt "there's some useful information:", 0, 3
	dfntxt "STOP_CODE: 0x", 0, 4
	
TextCodes:
	dc.b 11
	dc.b "(BUS_ERROR)"
	dc.b 15
	dc.b "(ADDRESS_ERROR)"
	dc.b "(ILLEGALINSTRUCTION_EXCEPTION)"
	dc.b "(DIVISIONBYZERO_EXCEPTION)"
	dc.b "(CHECK_EXCEPTION)"
	dc.b "(TRAPV_EXCEPTION)"
	dc.b "(PRIVILEGE_VIOLATION)"
	dc.b "(TRACE_EXCEPTION)"
	dc.b "(LINE1010_EMU)"
	dc.b "(LINE1111_EMU)"
	dc.b "(SPURIOUS_EXCEPTION)"
	dc.b "(TRAPxx_EXCEPTION)"
	dc.b "(UNKNOWN_ERROR)"
	dc.b "(MANUALLY_INITIATED_CRASH)"
	
Message5:	dc.b "Registers dump:"