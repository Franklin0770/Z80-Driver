	align 2
	save
	listing on
	charset "Assets/character_mapping.bin"

StaticText:
	dfntxt "ROM Sample Index:", 0, 0
	dfntxt "68k Samples Per-frame:", 0, 1
	dfntxt "Z80 Samples Per-frame:", 0, 2
	dfntxt "Last 68k Sample:", 0, 3
	dfntxt "Z80 Refresh Register:", 0, 4
	dfntxt "Sample Rate:", 0, 5
	dfntxt "Frame Number:", 0, 6

	dfntxt "Press A to play a note", 0, 8
	dfntxt "Hold B to play a note every frame", 0, 9
	dfntxt "Press C to restart the music", 0, 10
	dfntxt "Press Right or Up to skip forward", 0, 11
	dfntxt "Press Left or Down to skip backward", 0, 12
	dfntxt "Press Start to pause or resume playback", 0, 13
	dfntxt "Hold Start to crash the program (5s)", 0, 14

PauseMessage:
	dfntxt "Playback paused.", 0, 18

HaltMessage:
	dfntxt "All CPUs are halted now.", 0, 18
	dfntxt "Please reset to re-listen.", 0, 19

PalWarning:
	dfntxt "Hey there, PAL!", 12, 10
	dfntxt "This video format isn't supported, yet.", 0, 12
	dfntxt "You can still continue, but it's", 3, 13
	dfntxt "discouraged since there's 0% chance ", 2, 14
	dfntxt "that this driver will work properly.", 1, 15
	dfntxt "Press A + B + C for the ear-wreckage", 2, 18

	restore

ValueInformation:
	dc.l sampleIndex1						; variable address
	dc.l vdpCoordinates(25,0)				; VDP coordinates
	dc.w PrintLong-UpdateDebugger.base-2	; jump offset

	dc.l m68kSamples
	dc.l vdpCoordinates(25,1)
	dc.w PrintWord-UpdateDebugger.base-2

	dc.l z80Samples
	dc.l vdpCoordinates(25,2)
	dc.w PrintWord-UpdateDebugger.base-2

	dc.l lastSample
	dc.l vdpCoordinates(25,3)
	dc.w PrintByte-UpdateDebugger.base-2

	dc.l randomByte
	dc.l vdpCoordinates(25,4)
	dc.w PrintByte-UpdateDebugger.base-2

	dc.l sampleRate
	dc.l vdpCoordinates(25,5)
	dc.w PrintWord-UpdateDebugger.base-2

	dc.l frameCount
	dc.l vdpCoordinates(25,6)
	dc.w PrintLong-UpdateDebugger.base-2

Messages:
	dfntxt "Unfortunately, the Sega Mega Drive", 0, 0
	dfntxt "has crashed! I'm sorry :(", 0, 1
	dfntxt "If you want to know more,", 0, 2
	dfntxt "there's some useful information:", 0, 3
	dfntxt "STOP_CODE: 0x", 2, 5
	
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
	Code11:	dc.b "(UNHANDLED_IRQ_LEVEL1)"
	Code12:	dc.b "(UNHANDLED_IRQ_LEVEL2)"
	Code13:	dc.b "(UNHANDLED_IRQ_LEVEL3)"
	Code14:	dc.b "(UNHANDLED_IRQ_LEVEL5)"
	Code15:	dc.b "(UNHANDLED_IRQ_LEVEL7)"
	Code16:	dc.b "(TRAP0_EXCEPTION)",$00
	Code17:	dc.b "(TRAP1_EXCEPTION)",$00
	Code18:	dc.b "(TRAP2_EXCEPTION)",$00
	Code19:	dc.b "(TRAP3_EXCEPTION)",$00
	Code20:	dc.b "(TRAP4_EXCEPTION)",$00
	Code21:	dc.b "(TRAP5_EXCEPTION)",$00
	Code22:	dc.b "(TRAP6_EXCEPTION)",$00
	Code23:	dc.b "(TRAP7_EXCEPTION)",$00
	Code24:	dc.b "(TRAP8_EXCEPTION)",$00
	Code25:	dc.b "(TRAP9_EXCEPTION)",$00
	Code26:	dc.b "(TRAP10_EXCEPTION)"
	Code27:	dc.b "(TRAP11_EXCEPTION)"
	Code28:	dc.b "(TRAP12_EXCEPTION)"
	Code29:	dc.b "(TRAP13_EXCEPTION)"
	Code30:	dc.b "(TRAP14_EXCEPTION)"
	Code31:	dc.b "(TRAP15_EXCEPTION)"
	Code32:	dc.b "(UNKNOWN_ERROR)",$00
	Code33:	dc.b "(MANUALLY_INITIATED_CRASH)"

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
	dc.l Code14
	dc.l Code15
	dc.l Code16
	dc.l Code17
	dc.l Code18
	dc.l Code19
	dc.l Code20
	dc.l Code21
	dc.l Code22
	dc.l Code23
	dc.l Code24
	dc.l Code25
	dc.l Code26
	dc.l Code27
	dc.l Code28
	dc.l Code29
	dc.l Code30
	dc.l Code31
	dc.l Code32
	dc.l Code33
	dc.l TextCodes
	
Message5:	dc.b "Registers dump:"

	align 2
RegisterDumpInformation:
	dc.w SetupRegisters.address-SetupRegisters
	dc.w SetupRegisters.ssp-SetupRegisters
	dc.w SetupRegisters.usp-SetupRegisters
	dc.w SetupRegisters.sr-SetupRegisters
	dc.w SetupRegisters.pc-SetupRegisters
	dc.w SetupRegisters.halt-SetupRegisters