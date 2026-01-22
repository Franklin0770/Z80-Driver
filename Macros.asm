	listing off ; We don't need macro listing
	page 0 ; We don't want form feeds

notdataregister function r,((charfromstr(r,0) <> 'd') && (charfromstr(r,0) <> 'D')) || ((charfromstr(r,1) < '0') && (charfromstr(r,1) > '7'))
notaddressregister function r,((charfromstr(r,0) <> 'a') && (charfromstr(r,0) <> 'A')) || ((charfromstr(r,1) < '0') && (charfromstr(r,1) > '6'))

; ---------------------------------------------------------------------------
; Z80 control from 68k macros
; ---------------------------------------------------------------------------

stopZ80: macro r1,r2
	if MOMCPUNAME <> "68000"
		fatal "This macro must be called from the 68k. You used this in the \{MOMCPUNAME}"
	endif

	if "r1" = ""	; Macro without registers
		move.w	#$100,(Z80_BUSREQ).l
	else	; Macro with registers (for faster execution)
		if "r2" = ""
			if notaddressregister("r1")
				fatal "The first argument of stopZ80 when invoked with one argument must be an address register. The register used was r1"
			endif
			move.w	#$100,(r1)
		else
			if notdataregister("r1")
				fatal "The first argument of stopZ80 when invoked with two arguments must be a data register. The register used was r1"
			elseif notaddressregister("r2")
				fatal "The second argument of stopZ80 when invoked with two arguments must be an address register. The register used was r2"
			endif
			move.w	r1,(r2)
		endif
	endif
	endm

waitZ80: macro r1,r2
	if MOMCPUNAME <> "68000"
		fatal "This macro must be called from the 68k. You used this in the \{MOMCPUNAME}"
	endif

	if "r1" = ""	; Macro without breaking registers
$$wait: 
	btst	#0,(Z80_BUSREQ).l
	bne.s	$$wait

	else	; Macro breaking registers (for faster execution)

	if notdataregister("r1")
		fatal "The first argument of waitZ80 must be a data register. The register used was r1"
	elseif notaddressregister("r2")
		fatal "The second argument of waitZ80 must be an address register. The register used was r2"
	endif

$$wait: 
	btst	r1,(r2)
	bne.s	$$wait
	endif
	endm

startZ80: macro r1,r2
	if MOMCPUNAME <> "68000"
		fatal "This macro must be called from the 68k. You used this in the \{MOMCPUNAME}"
	endif

	if "r1" = ""	; Macro without registers
		move.w	#0,(Z80_BUSREQ).l
	else	; Macro with registers (for faster execution)
		if "r2" = ""
			if notaddressregister("r1")
				fatal "The first argument of startZ80 when invoked with one argument must be an address register. The register used was r1"
			endif
			move.w	#0,(r1)
		else
			if notdataregister("r1")
				fatal "The first argument of startZ80 when invoked with two arguments must be a data register. The register used was r1"
			elseif notaddressregister("r2")
				fatal "The second argument of startZ80 when invoked with two arguments must be an address register. The register used was r2"
			endif
			move.w	r1,(r2)
		endif
	endif
	endm

assertZ80Reset:	macro r1,r2
	if MOMCPUNAME <> "68000"
		fatal "This macro must be called from the 68k. You used this in the \{MOMCPUNAME}"
	endif

	if "r1" = ""	; Macro without registers
		move.w	#0,(Z80_RESET).l
	else	; Macro with registers (for faster execution)
		if "r2" = ""
			if notaddressregister("r1")
				fatal "The first argument of assertZ80Reset when invoked with one argument must be an address register. The register used was r1"
			endif
			move.w	#0,(r1)
		else
			if notdataregister("r1")
				fatal "The first argument of assertZ80Reset when invoked with two arguments must be a data register. The register used was r1"
			elseif notaddressregister("r2")
				fatal "The second argument of assertZ80Reset when invoked with two arguments must be an address register. The register used was r2"
			endif
			move.w	r1,(r2)
		endif
	endif
	endm

deassertZ80Reset: macro r1,r2
	if MOMCPUNAME <> "68000"
		fatal "This macro must be called from the 68k. You used this in the \{MOMCPUNAME}"
	endif

	if "r1" = ""	; Macro without registers
		move.w	#$100,(Z80_RESET).l
	else	; Macro with registers (for faster execution)
		if "r2" = ""
			if notaddressregister("r1")
				fatal "The first argument of deassertZ80Reset when invoked with one argument must be an address register. The register used was r1"
			endif
			move.w	#$100,(r1)
		else
			if notdataregister("r1")
				fatal "The first argument of deassertZ80Reset when invoked with two arguments must be a data register. The register used was r1"
			elseif notaddressregister("r2")
				fatal "The second argument of deassertZ80Reset when invoked with two arguments must be an address register. The register used was r2"
			endif
			move.w	r1,(r2)
		endif
	endif
	endm

; ---------------------------------------------------------------------------
; More efficient instructions
; ---------------------------------------------------------------------------

addaq: macro v0,r0
	if MOMCPUNAME <> "68000"
		error "This macro must be called from the 68k. You used this in the \{MOMCPU}."
	endif

	if notaddressregister("r0")
		error "The second argument of addaq must be an address register. The register used was r0."
	endif

	if (v0 >= 1) && (v0 <= 8)
		warning "It is recommended to use addq instead, since it spares 2 bytes."
	endif

	lea (v0,r0),r0
	endm
	
subaq: macro v0,r0
	if MOMCPUNAME <> "68000"
		error "This macro must be called from the 68k. You used this in the \{MOMCPU}."
	endif

	if notaddressregister("r0")
		error "The second argument of subaq must be an address register. The register used was r0."
	endif

	if (v0 >= 1) && (v0 <= 8)
		warning "It is recommended to use subq instead, since it spares 2 bytes."
	endif

	lea (-v0,r0),r0
	endm

; How to check string length: strlen(*string*) -> integer containing the string length
; How to check a substring in a string: substr(*string*,*starting index*,*ending index*) -> string containing the range provided
; How to check a character from a string charfromstr(*string*,*character position*) -> character

loadSamples: macro
	; --- 118 cycles in total ---
i set 0

	move.l	(a0)+,d0		; 12 cycles
	movep.l	d0,(i+(8*0),a1)	; 24 cycles

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*1),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*2),a1)
	; --- 238 cycles in total ---
i set 24

	while i < 152 * BUFFER_ITERATIONS

	if smoothPlayback
		move.b	(a2)+,(a3)
	elseif accurateSpeed
		addq.l	#1,a2
		nop
	endif

	move.l	(a0)+,d0
	movep.l d0,(i+(8*0),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*1),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*2),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*3),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*4),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*5),a1)

	move.l	(a0)+,d0

	if smoothPlayback
		move.b	(a2)+,(a3)
	elseif accurateSpeed
		addq.l	#1,a2
		nop
	endif

	movep.l	d0,(i+(8*6),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*7),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*8),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*9),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*10),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*11),a1)

	move.l	(a0)+,d0
	move.l	(a0)+,d1

	if smoothPlayback
		move.b	(a2)+,(a3)
	elseif accurateSpeed
		addq.l	#1,a2
		nop
	endif

	movep.l	d0,(i+(8*12),a1)
	movep.l	d1,(i+(8*13),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*14),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*15),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*16),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*17),a1)

	move.l	(a0)+,d0
	movep.l	d0,(i+(8*18),a1)

i set i + 152
	endm
	endm

loopTest: macro pitch
	lea	(YM2612_CONTROL|Z80_RAM),a2
	lea	(YM2612_DATA|Z80_RAM),a1
	move.b	#DAC_ENABLE,(a2)
	move.b	#$80,(a1)
	move.b	#DAC_IN,(a2)
	lea	Music,a0
$$loop:
	move.b	(a0)+,(a1)	; 12 cycles
	cmp.l	d0,d0		; 6 cycles
	rept pitch
	nop		; 4 cycles
	endm
	bra.w	$$loop	; 10 cycles
	endm

loadSamplesAlt: macro
	
; -------------------------
; BLOCK 0 (A1 base = 0)
; -------------------------

   move.b  (a2)+,(a3)

   move.l  (a0)+,d0
   movep.l d0,(0,a1)

   move.l  (a0)+,d0
   movep.l d0,(8,a1)

   move.l  (a0)+,d0
   movep.l d0,(16,a1)

   move.l  (a0)+,d0
   movep.l d0,(24,a1)

   move.l  (a0)+,d0
   movep.l d0,(32,a1)

   move.l  (a0)+,d0
   movep.l d0,(40,a1)

   move.l  (a0)+,d0

   move.b  (a2)+,(a3)

   movep.l d0,(48,a1)

   move.l  (a0)+,d0
   movep.l d0,(56,a1)

   move.l  (a0)+,d0
   movep.l d0,(64,a1)

   move.l  (a0)+,d0
   movep.l d0,(72,a1)

   move.l  (a0)+,d0
   movep.l d0,(80,a1)

   move.l  (a0)+,d0
   movep.l d0,(88,a1)

   move.l  (a0)+,d0
   move.l  (a0)+,d1

   move.b  (a2)+,(a3)

   movep.l d0,(96,a1)
   movep.l d1,(104,a1)

   move.l  (a0)+,d0
   movep.l d0,(112,a1)

   move.l  (a0)+,d0
   movep.l d0,(120,a1)

   move.l  (a0)+,d0
   movep.l d0,(128,a1)

   move.l  (a0)+,d0
   movep.l d0,(136,a1)

   move.l  (a0)+,d0
   movep.l d0,(144,a1)

; -------------------------
; BLOCK 1 (A1 base = 152)
; -------------------------

   move.b  (a2)+,(a3)

   move.l  (a0)+,d0
   movep.l d0,(152,a1)

   move.l  (a0)+,d0
   movep.l d0,(160,a1)

   move.l  (a0)+,d0
   movep.l d0,(168,a1)

   move.l  (a0)+,d0
   movep.l d0,(176,a1)

   move.l  (a0)+,d0
   movep.l d0,(184,a1)

   move.l  (a0)+,d0
   movep.l d0,(192,a1)

   move.l  (a0)+,d0

   move.b  (a2)+,(a3)

   movep.l d0,(200,a1)

   move.l  (a0)+,d0
   movep.l d0,(208,a1)

   move.l  (a0)+,d0
   movep.l d0,(216,a1)

   move.l  (a0)+,d0
   movep.l d0,(224,a1)

   move.l  (a0)+,d0
   movep.l d0,(232,a1)

   move.l  (a0)+,d0
   movep.l d0,(240,a1)

   move.l  (a0)+,d0
   move.l  (a0)+,d1

   move.b  (a2)+,(a3)

   movep.l d0,(248,a1)
   movep.l d1,(256,a1)

   move.l  (a0)+,d0
   movep.l d0,(264,a1)

   move.l  (a0)+,d0
   movep.l d0,(272,a1)

   move.l  (a0)+,d0
   movep.l d0,(280,a1)

   move.l  (a0)+,d0
   movep.l d0,(288,a1)

   move.l  (a0)+,d0
   movep.l d0,(296,a1)

; -------------------------
; BLOCK 2 (A1 base = 304)
; -------------------------

   move.b  (a2)+,(a3)

   move.l  (a0)+,d0
   movep.l d0,(304,a1)

   move.l  (a0)+,d0
   movep.l d0,(312,a1)

   move.l  (a0)+,d0
   movep.l d0,(320,a1)

   move.l  (a0)+,d0
   movep.l d0,(328,a1)

   move.l  (a0)+,d0
   movep.l d0,(336,a1)

   move.l  (a0)+,d0
   movep.l d0,(344,a1)

   move.l  (a0)+,d0

   move.b  (a2)+,(a3)

   movep.l d0,(352,a1)

   move.l  (a0)+,d0
   movep.l d0,(360,a1)

   move.l  (a0)+,d0
   movep.l d0,(368,a1)

   move.l  (a0)+,d0
   movep.l d0,(376,a1)

   move.l  (a0)+,d0
   movep.l d0,(384,a1)

   move.l  (a0)+,d0
   movep.l d0,(392,a1)

   move.l  (a0)+,d0
   move.l  (a0)+,d1

   move.b  (a2)+,(a3)

   movep.l d0,(400,a1)
   movep.l d1,(408,a1)

   move.l  (a0)+,d0
   movep.l d0,(416,a1)

   move.l  (a0)+,d0
   movep.l d0,(424,a1)

   move.l  (a0)+,d0
   movep.l d0,(432,a1)

   move.l  (a0)+,d0
   movep.l d0,(440,a1)

   move.l  (a0)+,d0
   movep.l d0,(448,a1)

; -------------------------
; BLOCK 3 (A1 base = 456)
; -------------------------

   move.b  (a2)+,(a3)

   move.l  (a0)+,d0
   movep.l d0,(456,a1)

   move.l  (a0)+,d0
   movep.l d0,(464,a1)

   move.l  (a0)+,d0
   movep.l d0,(472,a1)

   move.l  (a0)+,d0
   movep.l d0,(480,a1)

   move.l  (a0)+,d0
   movep.l d0,(488,a1)

   move.l  (a0)+,d0
   movep.l d0,(496,a1)

   move.l  (a0)+,d0

   move.b  (a2)+,(a3)

   movep.l d0,(504,a1)

   move.l  (a0)+,d0
   movep.l d0,(512,a1)

   move.l  (a0)+,d0
   movep.l d0,(520,a1)

   move.l  (a0)+,d0
   movep.l d0,(528,a1)

   move.l  (a0)+,d0
   movep.l d0,(536,a1)

   move.l  (a0)+,d0
   movep.l d0,(544,a1)

   move.l  (a0)+,d0
   move.l  (a0)+,d1

   move.b  (a2)+,(a3)

   movep.l d0,(552,a1)
   movep.l d1,(560,a1)

   move.l  (a0)+,d0
   movep.l d0,(568,a1)

   move.l  (a0)+,d0
   movep.l d0,(576,a1)

   move.l  (a0)+,d0
   movep.l d0,(584,a1)

   move.l  (a0)+,d0
   movep.l d0,(592,a1)

   move.l  (a0)+,d0
   movep.l d0,(600,a1)

; -------------------------
; BLOCK 4 (A1 base = 608)
; -------------------------

   move.b  (a2)+,(a3)

   move.l  (a0)+,d0
   movep.l d0,(608,a1)

   move.l  (a0)+,d0
   movep.l d0,(616,a1)

   move.l  (a0)+,d0
   movep.l d0,(624,a1)

   move.l  (a0)+,d0
   movep.l d0,(632,a1)

   move.l  (a0)+,d0
   movep.l d0,(640,a1)

   move.l  (a0)+,d0
   movep.l d0,(648,a1)

   move.l  (a0)+,d0

   move.b  (a2)+,(a3)

   movep.l d0,(656,a1)

   move.l  (a0)+,d0
   movep.l d0,(664,a1)

   move.l  (a0)+,d0
   movep.l d0,(672,a1)

   move.l  (a0)+,d0
   movep.l d0,(680,a1)

   move.l  (a0)+,d0
   movep.l d0,(688,a1)

   move.l  (a0)+,d0
   movep.l d0,(696,a1)

   move.l  (a0)+,d0
   move.l  (a0)+,d1

   move.b  (a2)+,(a3)

   movep.l d0,(704,a1)
   movep.l d1,(712,a1)

   move.l  (a0)+,d0
   movep.l d0,(720,a1)

   move.l  (a0)+,d0
   movep.l d0,(728,a1)

   move.l  (a0)+,d0
   movep.l d0,(736,a1)

   move.l  (a0)+,d0
   movep.l d0,(744,a1)

   move.l  (a0)+,d0
   movep.l d0,(752,a1)

; -------------------------
; BLOCK 5 (A1 base = 760)
; -------------------------

   move.b  (a2)+,(a3)

   move.l  (a0)+,d0
   movep.l d0,(760,a1)

   move.l  (a0)+,d0
   movep.l d0,(768,a1)

   move.l  (a0)+,d0
   movep.l d0,(776,a1)

   move.l  (a0)+,d0
   movep.l d0,(784,a1)

   move.l  (a0)+,d0
   movep.l d0,(792,a1)

   move.l  (a0)+,d0
   movep.l d0,(800,a1)

   move.l  (a0)+,d0

   move.b  (a2)+,(a3)

   movep.l d0,(808,a1)

   move.l  (a0)+,d0
   movep.l d0,(816,a1)

   move.l  (a0)+,d0
   movep.l d0,(824,a1)

   move.l  (a0)+,d0
   movep.l d0,(832,a1)

   move.l  (a0)+,d0
   movep.l d0,(840,a1)

   move.l  (a0)+,d0
   movep.l d0,(848,a1)

   move.l  (a0)+,d0
   move.l  (a0)+,d1

   move.b  (a2)+,(a3)

   movep.l d0,(856,a1)
   movep.l d1,(864,a1)

   move.l  (a0)+,d0
   movep.l d0,(872,a1)

   move.l  (a0)+,d0
   movep.l d0,(880,a1)

   move.l  (a0)+,d0
   movep.l d0,(888,a1)

   move.l  (a0)+,d0
   movep.l d0,(896,a1)

   move.l  (a0)+,d0
   movep.l d0,(904,a1)

; -------------------------
; BLOCK 6 (A1 base = 912)
; -------------------------

   move.b  (a2)+,(a3)

   move.l  (a0)+,d0
   movep.l d0,(912,a1)

   move.l  (a0)+,d0
   movep.l d0,(920,a1)

   move.l  (a0)+,d0
   movep.l d0,(928,a1)

   move.l  (a0)+,d0
   movep.l d0,(936,a1)

   move.l  (a0)+,d0
   movep.l d0,(944,a1)

   move.l  (a0)+,d0
   movep.l d0,(952,a1)

   move.l  (a0)+,d0

   move.b  (a2)+,(a3)

   movep.l d0,(960,a1)

   move.l  (a0)+,d0
   movep.l d0,(968,a1)

   move.l  (a0)+,d0
   movep.l d0,(976,a1)

   move.l  (a0)+,d0
   movep.l d0,(984,a1)

   move.l  (a0)+,d0
   movep.l d0,(992,a1)

   move.l  (a0)+,d0
   movep.l d0,(1000,a1)

   move.l  (a0)+,d0
   move.l  (a0)+,d1

   move.b  (a2)+,(a3)

   movep.l d0,(1008,a1)
   movep.l d1,(1016,a1)

   move.l  (a0)+,d0
   movep.l d0,(1024,a1)

   move.l  (a0)+,d0
   movep.l d0,(1032,a1)

   move.l  (a0)+,d0
   movep.l d0,(1040,a1)

   move.l  (a0)+,d0
   movep.l d0,(1048,a1)

   move.l  (a0)+,d0
   movep.l d0,(1056,a1)

; -------------------------
; PARTIAL BLOCK (A1 base = 1064)
; -------------------------

   move.b  (a2)+,(a3)

   move.l  (a0)+,d0
   movep.l d0,(1064,a1)

   move.l  (a0)+,d0
   movep.l d0,(1072,a1)

	endm