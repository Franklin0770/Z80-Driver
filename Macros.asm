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
		fatal "This macro must be called from the 68k. You used this in the \{MOMCPUNAME}"
	endif

	if notaddressregister("r0")
		fatal "The second argument of addaq must be an address register. The register used was r0"
	elseif (v0) > $7FFF && (v0) < -$7FFF
		fatal "The first argument must be in range -$7FFF..$7FFF. Current value is v0"
	endif

	if (v0) >= 1 && (v0) <= 8
		warning "It is recommended to use addq instead, since it spares 2 bytes"
	endif

	lea v0(r0),r0
	endm
	
subaq: macro v0,r0
	if MOMCPUNAME <> "68000"
		fatal "This macro must be called from the 68k. You used this in the \{MOMCPUNAME}"
	endif

	if notaddressregister("r0")
		fatal "The second argument of subaq must be an address register. The register used was r0"
	elseif (v0) > $7FFF && (v0) < -$7FFF
		fatal "The first argument must be in range -$7FFF..$7FFF. Current value is v0"
	endif

	if (v0) >= 1 && (v0) <= 8
		warning "It is recommended to use subq instead, since it spares 2 bytes"
	endif

	lea -v0(r0),r0
	endm

; How to check string length: strlen(*string*) -> integer containing the string length
; How to check a substring in a string: substr(*string*,*starting index*,*ending index*) -> string containing the range provided
; How to check a character from a string charfromstr(*string*,*character position*) -> character