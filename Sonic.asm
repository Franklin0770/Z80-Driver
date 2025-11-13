; Naming conventions:
; variableValue
; CONSTANT_VALUE
; MainRoutineAndLables
; sub_routine

	include "Constants.asm"
	include "Variables.asm"
	include "Macros.asm"

	listing purecode ; We sure want the listing file, but only the final code in expanded macros

	org 0

ROM_Start ; Vectors
		dc.l M68K_STACK			; Initial stack pointer value (SP value)
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
		dc.l ROM_Start							; Start address of ROM
		dc.l ROM_End								; End address of ROM
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
	; In the mean time, we can initialize the registers

	moveq	#10-1,d0
	moveq	#0,d1
	moveq	#$D2,d2
	moveq	#6,d3
	moveq	#$0F,d4
	moveq	#4,d5
	moveq	#9-1,d6	; 4 cycles

	lea	sampleIndex,a0
	lea	YM2612_68K_DATA0,a1	; 8 cycles
	lea	SampleBuffer|Z80_WRAM,a3	; 8 cycles
	lea	Sign3,a4
	lea	Sign4,a5
	lea	YM2612_68K_CTRL0,a6

	stopZ80	; Initiate Z80 stop, 20 cycles
	
$$timing_wait1:	; wait 100 cycles here
	dbf d0,$$timing_wait1

	;moveq	#0,d0
	;waitZ80	d0,a4	;let's say the Z80 may have completely stopped here. Fire hazard, maybe

	adda.w	(playedSamples|Z80_WRAM),a0	; 16 cycles
	move.l	a0,a2	; Sample index while executing 68k routine, 4 cycles
	move.b	#DAC_ENABLE,(a6)
	move.b	#$80,(a1)
	move.b	#DAC_OUT,(a6)

	jmp	LoopMusicRoutine

Continue_Int:
	move.b	d0,(lastADPCMValue)					; Back up the last ADPCM sample so the Z80 can start from there
	move.b	#Continue&$FF,(InfiniteLoop+1|Z80_WRAM)	; Unstuck Z80

	moveq	#18,d0 ; Timing that needs to be adjusted
$$timing_wait2:
	dbf	d0,$$timing_wait2
	
	startZ80

	move.l 	a0,d0
	move.l	d0,(sampleIndex).l	; Update sample index

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

	lea Z80_BUSREQ,a3
	lea Z80_RESET,a2

	move.w	#$100,d2	; Assert, stop
	moveq	#0,d1		; Deassert, start

	assertZ80Reset d1,a2	; Assert reset
	stopZ80 d2,a3			; Request bus
	deassertZ80Reset d2,a2	; Release reset

; We can do more stuff while the Z80 is theoretically stopping
	lea Z80_Code,a0
	lea Z80_WRAM,a1
	move.w	#(Z80_ROM_End-Z80_ROM_Start)-1,d0

$$copy_Z80_code:
	move.b	(a0)+,(a1)+
	dbf d0,$$copy_Z80_code

	assertZ80Reset d2,a2	; Assert reset

	lea CopyMusicRoutine,a0
	lea copyMusicRoutine,a1
	moveq	#((M68K_PROG_SIZE)-1)/4,d0

$$copy_68k_code:
	move.l	(a0)+,(a1)+
	dbf	d0,$$copy_68k_code

	deassertZ80Reset d2,a2	; Release reset
	startZ80 d1,a3			; Release bus

	move	#$2500,sr
HaltCPU:
	;stop #$2500	; Wait until next interrupt
	bra.s	HaltCPU

CopyMusicRoutine
	phase copyMusicRoutine
LoopMusicRoutine: ; 514 samples to buffer on Z80 (d0: accumulator, d1: ADPCM accumulator, d2: OP code, d3: contains 6, d4: contains $0F, d5: contains 4, d6: loop counter, a4: points to first sign, a5: points to second sign)
	move.b	(a0),d0
	and.b	d4,d0
	beq.s	Negate3		; If the first nibble is zero
Sign3
	add.b	d0,d1
	move.b	d1,(a1)		; First nibble
	bra.s	Continue3
Negate3:
	bchg.l	d3,d2
	move.b	d2,(a4)
	move.b	d2,(a5)
Continue3:
	move.l	(a2)+,d0
	movep.l	d0,0(a3)
	move.l	(a2)+,d0
	movep.l	d0,1(a3)
	move.l	(a2)+,d0
	movep.l	d0,8(a3)
	move.l	(a2)+,d0
	movep.l	d0,9(a3)
	move.b	(a0)+,d0
	lsr.b	d5,d0
	beq.s	Negate4		; If the second nibble is zero
Sign4
	add.b	d0,d1
	move.b	d1,(a1)		; Second nibble
	bra.s	Continue4
Negate4:
	bchg.l	d3,d2
	move.b	d2,(a4)
	move.b	d2,(a5)
Continue4:
	move.l	(a2)+,d0
	movep.l	d0,16(a3)
	move.l	(a2)+,d0
	movep.l	d0,17(a3)
	move.l	(a2)+,d0
	movep.l	d0,24(a3)
	move.l	(a2)+,d0
	movep.l	d0,25(a3)
	addaq	26,a3
	dbf d6,LoopMusicRoutine
	jmp	Continue_Int
	dephase
CopyMusicRoutine_End

Z80_Code:
	include "Driver.z80"

Music:
	;binclude "continuity_test.bin" ; Test with increasing bytes to make sure no samples get skipped
	;binclude "24. Time Rift Shift ~ Vs. Metal Sonic.raw" ; Great music right here
	;binclude "Don't Stand So Close To Me.raw" ; Another banger
	;binclude "music.pcm" ; Let's not talk about this

ROM_End