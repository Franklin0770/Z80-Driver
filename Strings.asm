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
	dfntxt "Press Start + C to crash the program", 0, 15

PauseMessage:
	dfntxt "Playback paused.", 0, 20

HaltMessage:
	dfntxt "All CPUs are halted now.", 0, 20
	dfntxt "Please reset to re-listen.", 0, 21

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
	dfntxt "STOP_CODE: 0x", 0, 5
	
	align 2
	Code0:	dc.b "(BUS_ERROR)",$00
	Code1:	dc.b "(ADDRESS_ERROR)",$00
	Code2:	dc.b "(ILLEGALINSTRUCTION_EXCEPTION)"
	Code3:	dc.b "(DIVISIONBYZERO_EXCEPTION)"
	Code4:	dc.b "(CHECK_EXCEPTION)",$00
	Code5:	dc.b "(TRAPV_EXCEPTION)",$00
	Code6:	dc.b "(PRIVILEGE_VIOLATION)",$00
	Code7:	dc.b "(TRACE_EXCEPTION)",$00
	Code8:	dc.b "(LINE1010_EMU)"
	Code9:	dc.b "(LINE1111_EMU)"
	Code10:	dc.b "(SPURIOUS_EXCEPTION)"
	Code11:	dc.b "(TRAPxx_EXCEPTION)"
	Code12:	dc.b "(UNKNOWN_ERROR)",$00
	Code13:	dc.b "(MANUALLY_INITIATED_CRASH)"

TextCodes:
	dc.l Code0
	dc.l Code1
	dc.l Code2
	dc.l Code3
	dc.l Code4
	dc.l Code5
	dc.l Code6
	dc.l Code7
	dc.l Code8
	dc.l Code9
	dc.l Code10
	dc.l Code11
	dc.l Code12
	dc.l Code13
	dc.l TextCodes
	
Message5:	dc.b "Registers dump:"