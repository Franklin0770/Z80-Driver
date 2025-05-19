; Naming conventions:
; variableValue
; CONSTANT_VALUE
; MainRoutineAndLables
; sub_routine
	
	cpu 68000
	
	supmode on ; We don't need warnings about privileged instructions

	include "Variables.asm"
	include "Constants.asm"
	include "Macros.asm"

	listing purecode ; We sure want the listing file, but only the final code in expanded macros

	org 0

RomStart ; Vectors
		dc.l SYS_STACK			; Initial stack pointer value (SP value)
		dc.l EntryPoint			; Start of program (PC value)
		dc.l BusError			; Bus error
		dc.l AddressError		; Address error
		dc.l IllegalInstruction	; Illegal instruction
		dc.l DivisionByZero		; Division by zero
		dc.l CHKException		; CHK exception
		dc.l TRAPVException		; TRAPV exception
		dc.l PrivilegeViolation	; Privilege violation
		dc.l TRACEException		; TRACE exception
		dc.l LineAEmulator		; Line-A emulator
		dc.l LineFEmulator		; Line-F emulator
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l SpuriousException	; Spurious exception
		dc.l GenericError		; IRQ level 1
		dc.l GenericError		; IRQ level 2
		dc.l GenericError		; IRQ level 3 
		dc.l GenericError		; IRQ level 4 (horizontal retrace interrupt)
		dc.l GenericError		; IRQ level 5
		dc.l VDP_VBlank			; IRQ level 6 (vertical retrace interrupt)
		dc.l GenericError		; IRQ level 7
		dc.l GenericError		; TRAP #00 exception
		dc.l GenericError		; TRAP #01 exception
		dc.l GenericError		; TRAP #02 exception
		dc.l GenericError		; TRAP #03 exception
		dc.l GenericError		; TRAP #04 exception
		dc.l GenericError		; TRAP #05 exception
		dc.l GenericError		; TRAP #06 exception
		dc.l GenericError		; TRAP #07 exception
		dc.l GenericError		; TRAP #08 exception
		dc.l GenericError		; TRAP #09 exception
		dc.l GenericError		; TRAP #10 exception
		dc.l GenericError		; TRAP #11 exception
		dc.l GenericError		; TRAP #12 exception
		dc.l GenericError		; TRAP #13 exception
		dc.l GenericError		; TRAP #14 exception
		dc.l GenericError		; TRAP #15 exception
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)
		dc.l GenericError		; Unused (reserved)

; ROM header
		dc.b "SEGA MEGA DRIVE",$20				; "$20" is padding
		dc.b "(C)BRO0 2024.OCT"					; Copyright(-ish), release year and month
		dc.b "Presentazione sistemi: 68k e x86"	; Domestic name
		dc.b "                "					; padding
		dc.b "Presentazione sistemi: 68k e x86"	; Overseas name
		dc.b "                "					; padding
		dc.b "AI-23456786-00"					; Serial number (I mashed the keyboard for this)
		dc.w $0000								; Empty checksum
		dc.b "J"								; Joypad type
		dc.b "               "					; padding
		dc.l RomStart							; Start address of ROM
		dc.l RomEnd								; End address of ROM
		dc.l $FF0000							; Start address of WRAM
		dc.l $FFFFFF 							; End address of WRAM
		dc.b "                                                                "
		dc.b "JU "								; Region support
		dc.b "             "					; padding for reserved space

; Error handler jump table

BusError:
	moveq	#1,d7
	stop #$2700

AddressError:
	moveq	#2,d7
	stop #$2700

IllegalInstruction:
	moveq	#3,d7
	stop #$2700

DivisionByZero:
	moveq	#4,d7
	stop #$2700

CHKException:
	moveq	#5,d7
	stop #$2700

TRAPVException:
	moveq	#6,d7
	stop #$2700

PrivilegeViolation:
	moveq	#7,d7
	stop #$2700

TRACEException:
	moveq	#8,d7
	stop #$2700

LineAEmulator:
	moveq	#9,d7
	stop #$2700

LineFEmulator:
	moveq	#10,d7
	stop #$2700

SpuriousException:
	moveq	#11,d7
	stop #$2700

GenericError:
	moveq	#12,d7
	stop #$2700

; a0: live samples, a2: Z80 samples

VDP_VBlank:
	; 216 68k cycles for every 32 kHz sample
	stopZ80	; Initiate Z80 stop, 20 cycles
	lea Z80_BUSREQ,a4	; 8 cycles
	; In the mean time, we can initialize the registers
	move.l	(sampleIndex),a0	; 16 cycles
	move.l	a0,a2	; Sample index while executing 68k routine, 4 cycles
	addaq	26+1,a2	; Sample index after 68k routine execution (a0, at the end basically), 8 cycles

	lea	YM2612_DATA|Z80_RAM,a1	; 8 cycles
	lea	SampleBuffer|Z80_RAM,a3	; 8 cycles

	moveq	#27-1,d1	; 4 cycles
	cmp.l	d0,d0		; waste 6 cycles

	; 82 cycles

	moveq	#13-1,d0	; 4 cycles
$$timing_wait1:	; wait 130 cycles here
	dbf d0,$$timing_wait1

	;moveq	#0,d0
	;waitZ80	d0,a4	;let's say the Z80 may have completely stopped here. Fire hazard, maybe

$$copy_music: ; 514 samples to buffer on Z80
	move.b	(a0)+,(a1)	; Keep sample playback alive
	rept 19
	move.b	(a2)+,(a3)+	; Copy samples into sound RAM as fast as possible
	endm
	dbf d1,$$copy_music
	move.b	(a0),(a1)
	move.b	(a2),(a3)	; To ensure one sample doesn't get skipped, a2 shouldn't increase

	move.b	#LoopInit,((Wait68k&$FF)|Z80_RAM)+1	; Replaces "jp Wait68k" with "jp LoopInit", to make sure the Z80 starts to output samples again

	moveq	#18,d0 ; 20, theoretically, but less since the Z80 takes some time to wake up (need to make this more precise, though)
$$timing_wait2:
	dbf	d0,$$timing_wait2
	
	startZ80 a4	; Restart Z80 (d1: $00000000)

	move.l 	a2,d0
	move.l	d0,(sampleIndex)	; Update sample index relative to when the Z80 finishes the playback routine

	; DPLC loading queues
	rte


EntryPoint:
	lea		VDP_CTRL,a0

; VDP register setup
	move.l  #(VDPREG_MODE1|%00000000)<<16|VDPREG_MODE2|%00100000,(a0)	; Mode register #1 and Mode register #2
	move.l  #(VDPREG_MODE3|%00000000)<<16|VDPREG_MODE4|%00000000,(a0)	; Mode register #3 and Mode register #4
	
	move.l  #(VDPREG_PLANEA|(PLANEA_ADDR>>10))<<16|VDPREG_PLANEB|(PLANEB_ADDR>>13),(a0)	; Plane A and Plane B address
	move.l  #(VDPREG_SPRITE|(SPRITE_ADDR>>9))<<16|VDPREG_WINDOW|(WINDOW_ADDR>>10),(a0)	; Sprite and Window address
    move.w  #VDPREG_HSCROLL|(HSCROLL_ADDR>>10),(a0)										; HScroll address
    
    move.l  #(VDPREG_SIZE|$00)<<16|VDPREG_WINX|$00,(a0)		; Tilemap size and Window X split
    move.l  #(VDPREG_WINY|$00)<<16|VDPREG_INCR|$00,(a0)		; Window Y split and Autoincrement
    move.l  #(VDPREG_BGCOL|$00)<<16|VDPREG_HRATE|$FF,(a0)	; Background color and HBlank IRQ rate

; Start of ROM code

	lea (Z80_BUSREQ),a3
	lea (Z80_RESET),a2

	move.w	#$100,d2	; Assert, stop
	moveq	#0,d1		; Deassert, start

	assertZ80Reset d1,a2	; Assert reset
	stopZ80 d2,a3			; Request bus
	deassertZ80Reset d2,a2	; Release reset

; We can do more stuff while the Z80 is theoretically stopping
	lea Z80RomStart,a0
	lea Z80_RAM,a1
	move.l 	#Music,(sampleIndex)
	moveq	#(Z80RomEnd-Z80RomStart)-1,d0	; Mustn't go over $7F

$$copy_program:
	move.b	(a0)+,(a1)+
	dbf d0,$$copy_program

	assertZ80Reset d2,a2	; Assert reset

	moveq	#20,d0
$$wait:	; Wait for the YM2612
    dbf	d0,$$wait

	deassertZ80Reset d2,a2	; Release reset
	startZ80 d1,a3			; Release bus

	move	#$2500,sr
HaltCPU:
	;stop #$2500	; Wait until next interrupt
	bra.s	HaltCPU

	include "Driver.z80"

Music:
	binclude "assets/24. Time Rift Shift ~ Vs. Metal Sonic.raw"

RomEnd