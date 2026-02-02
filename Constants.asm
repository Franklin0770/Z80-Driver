; ---------------------------------
;      Code-specific constants
; ---------------------------------
BUFFER_ITERATIONS:	equ 7

; M68K: Motorola 68000 related constant
; Z80: Z80 related constant
; JOYx: controller related constant
; EXP: expansion related constant
; VDP: VDP memory map related constant
; VDP_REG: VDP register related constant
; PSG: PSG related constant
; YM2612: YM2612 related constant
; REG: miscellaneous Mega Drive register related constant
; SIZE: size of a memory space

; ---------------------------------
;		From: Motorola 68000
; ---------------------------------

; Mega Drive memory spaces
M68K:
.WRAM:		equ $FF0000		; 68000 memory start address
.STACK:		equ $FF0000		; 68000 stack
.PSG:		equ $C00011		; PSG port
JOY1:
.CTRL:		equ $A10009		; Controller 1 control port
.DATA:		equ $A10003   	; Controller 1 data port
.SER_TRAN:	equ $A1000E		; Controller 1 serial transmit
.SER_REC:	equ $A10010		; Controller 1 serial receive
.SER_CTRL:	equ $A10012		; Controller 1 serial control
JOY2:
.CTRL:		equ $A10005		; Controller 2 control port
.DATA:		equ $A1000B   	; Controller 2 data port
.SER_TRAN:	equ $A10014		; Controller 2 serial transmit
.SER_REC:	equ $A10016		; Controller 2 serial receive
.SER_CTRL:	equ $A10018		; Controller 2 serial control

EXP:
.CTRL:		equ $A1000D		; Expansion control port
.DATA:		equ $A10006		; Expansion data port
.SER_TRAN:	equ $A1001A		; Expansion serial transmit
.SER_REC:	equ $A1001C		; Expansion serial receive
.SER_CTRL:	equ $A1001E		; Expansion serial control

REG:
.SRAM:		equ $A130F1		; SRAM access register

.VERSION:		equ $A10001		; Version register
.MEMORYMODE:	equ $A11000		; Memory mode register

.TMSS:		equ $A14000		; TMSS "SEGA" register
.TMSS_CART:	equ $A14101		; TMSS cartridge register

.TIME:		equ $A13000		; TIME signal to cartridge ($00-$FF)
.32X:		equ $A130EC		; Becomes "MARS" when a 32X is attached

; VDP memory addresses
VDP:
.DATA:		equ $C00000		; VDP data port
.CTRL:		equ $C00004		; VDP control port and Status Register
.HVCOUNTER:	equ $C00008		; H/V counter
.DEBUG:		equ $C0001C		; Debug register

; VDP commands
VDP_CMD:
.VRAM:	equ	$40000000		; Video memory address command
.VSRAM:	equ $40000010		; Vertical scroll memory address command
.CRAM: 	equ $C0000000		; Color memory address command

.VDP_VRAM.DMA:	equ $40000080	; DMA video memory write command
.VSRAM_DMA:		equ $40000090	; DMA vertical scroll memory write command
.RAM_DMA:		equ $C0000080	; DMA color memory write command

; VDP registers
VDP_REG:
.MODE1:     equ $8000  ; Mode register #1
.MODE2:     equ $8100  ; Mode register #2
.MODE3:     equ $8B00  ; Mode register #3
.MODE4:     equ $8C00  ; Mode register #4

.PLANEA:    equ $8200  ; Plane A table address
.PLANEB:    equ $8400  ; Plane B table address
.SPRITE:    equ $8500  ; Sprite table address
.WINDOW:    equ $8300  ; Window table address
.HSCROLL:   equ $8D00  ; HScroll table address

.SIZE:      equ $9000  ; Plane A and B size
.WINX:      equ $9100  ; Window X split position
.WINY:      equ $9200  ; Window Y split position
.INCR:      equ $8F00  ; Autoincrement
.BGCOL:     equ $8700  ; Background color
.HRATE:     equ $8A00  ; HBlank interrupt rate

.DMALEN_L:  equ $9300  ; DMA length (low)
.DMALEN_H:  equ $9400  ; DMA length (high)
.DMASRC_L:  equ $9500  ; DMA source (low)
.DMASRC_M:  equ $9600  ; DMA source (mid)
.DMASRC_H:  equ $9700  ; DMA source (high)

; VRAM management (you can change these)
VDP_VRAM:
.PLANEA:	equ $E000	; Plane A name table address
.PLANEB:	equ $C000	; Plane B name table address
.SPRITE:	equ $F000	; Sprite name table address
.WINDOW:	equ $FFFF	; Window plane name table address
.HSCROLL:	equ $FFFF	; Plane x coordinate

; Z80 control from 68000
Z80_CTRL:
.WRAM:		equ $A00000  ; Z80 RAM start
.BUSREQ:	equ $A11100  ; Z80 bus request line
.RESET:		equ $A11200  ; Z80 reset line

; YM2612 memory addresses from 68000
YM2612_68K:
.CTRL0:	equ $A04000		; YM2612 bank 0 control port from 68000
.DATA0:	equ $A04001		; YM2612 bank 0 data port from 68000
.CTRL1:	equ $A04002		; YM2612 bank 1 control port from 68000
.DATA1:	equ $A04003		; YM2612 bank 1 data port from 68000

; ----------------------------
;		From: Zilog Z80
; ----------------------------

; Z80 side addresses
Z80:
.STACK:		equ $2000
.PSG:		equ $7F11	; PSG port from Z80 on 68k bus

; YM2612 memory addresses from Z80
YM2612:
.CTRL0:	equ $4000		; YM2612 bank 0 control port
.DATA0:	equ $4001		; YM2612 bank 0 data port
.CTRL1:	equ $4002		; YM2612 bank 1 control port
.DATA1:	equ $4003		; YM2612 bank 1 data port

; Z80 bus arbiter
Z80_BANK:
.CTRL:		equ $6000	; Bank selector (9 LSB serial writes)
.WINDOW:	equ $8000	; Access window (8000h-FFFFh)

; --------------------------
;		Generic Labels
; --------------------------

; Various memory spaces sizes in bytes
SIZE:
.WRAM: 		equ 65535	; 68000 RAM size (64 KB)
.VRAM:		equ 65535	; VDP VRAM size (64 KB)
.VSRAM:		equ 80		; VDP vertical scroll RAM size (80 bytes)
.CRAM:		equ 128		; VDP color RAM size (128 bytes, 64 colors)
.Z80WRAM:	equ 8192	; Z80 RAM size (8 KB)

; VDP name table addresses
NOFLIP: equ $0000  ; Don't flip (default)
HFLIP:  equ $0800  ; Flip horizontally
VFLIP:  equ $1000  ; Flip vertically
HVFLIP: equ $1800  ; Flip both ways (180° flip)

PAL0:   equ $0000  ; Use palette 0 (default)
PAL1:   equ $2000  ; Use palette 1
PAL2:   equ $4000  ; Use palette 2
PAL3:   equ $6000  ; Use palette 3

LOPRI:  equ $0000  ; Low priority (default)
HIPRI:  equ $8000  ; High priority

; Controller labels
JOY:
.C:	equ 5
.B:	equ 4
.R:	equ 3
.L:	equ 2
.D:	equ 1
.U:	equ 0

; YM2612 labels
LFO_ENABLE:		equ $22		; Enable Low Frequency Oscillator
TIMER_A_H:		equ $24		; Timer A frequency (high)
TIMER_A_L:		equ $25		; Timer A frequency (low)
TIMER_B:		equ $26		; Timer B frequency
CH3_TIMERCTRL:	equ $27		; Channel 3 Mode and Timer control
KEY_ON_OFF:		equ $28		; Key-on and Key-off
DAC_OUT:		equ $2A		; DAC output (or input)
DAC_ENABLE:		equ $2B		; DAC enable
DAC_BOOST:		equ $2C		; Undocumented debug register that amplifies the DAC channel output

CH1_4_OP1_MUL_DT:	equ $30		; Channel 1/4 operator 1 Multiply and Detune
CH1_4_OP2_MUL_DT:	equ $38		; Channel 1/4 operator 2 Multiply and Detune
CH1_4_OP3_MUL_DT:	equ $34		; Channel 1/4 operator 3 Multiply and Detune
CH1_4_OP4_MUL_DT:	equ $3C		; Channel 1/4 operator 4 Multiply and Detune

CH2_5_OP1_MUL_DT:	equ $31		; Channel 2/5 operator 1 Multiply and Detune
CH2_5_OP2_MUL_DT:	equ $39		; Channel 2/5 operator 2 Multiply and Detune
CH2_5_OP3_MUL_DT:	equ $35		; Channel 2/5 operator 3 Multiply and Detune
CH2_5_OP4_MUL_DT:	equ $3D		; Channel 2/5 operator 4 Multiply and Detune

CH3_6_OP1_MUL_DT:	equ $32		; Channel 3/6 operator 1 Multiply and Detune
CH3_6_OP2_MUL_DT:	equ $3A		; Channel 3/6 operator 2 Multiply and Detune
CH3_6_OP3_MUL_DT:	equ $36		; Channel 3/6 operator 3 Multiply and Detune
CH3_6_OP4_MUL_DT:	equ $3E		; Channel 3/6 operator 4 Multiply and Detune

CH1_4_OP1_TL:	equ $40		; Channel 1/4 operator 1 Total Level
CH1_4_OP2_TL:	equ $48		; Channel 1/4 operator 2 Total Level
CH1_4_OP3_TL:	equ $44		; Channel 1/4 operator 3 Total Level
CH1_4_OP4_TL:	equ $4C		; Channel 1/4 operator 4 Total Level

CH2_5_OP1_TL:	equ $41		; Channel 2/5 operator 1 Total Level
CH2_5_OP2_TL:	equ $49		; Channel 2/5 operator 2 Total Level
CH2_5_OP3_TL:	equ $45		; Channel 2/5 operator 3 Total Level
CH2_5_OP4_TL:	equ $4D		; Channel 2/5 operator 4 Total Level

CH3_6_OP1_TL:	equ $42		; Channel 3/6 operator 1 Total Level
CH3_6_OP2_TL:	equ $4A		; Channel 3/6 operator 2 Total Level
CH3_6_OP3_TL:	equ $46		; Channel 3/6 operator 3 Total Level
CH3_6_OP4_TL:	equ $4E		; Channel 3/6 operator 4 Total Level

CH1_4_OP1_AR_RS:	equ $50		; Channel 1/4 operator 1 Attack Rate and Rate Scaling
CH1_4_OP2_AR_RS:	equ $58		; Channel 1/4 operator 2 Attack Rate and Rate Scaling
CH1_4_OP3_AR_RS:	equ $54		; Channel 1/4 operator 3 Attack Rate and Rate Scaling
CH1_4_OP4_AR_RS:	equ $5C		; Channel 1/4 operator 4 Attack Rate and Rate Scaling

CH2_5_OP1_AR_RS:	equ $51		; Channel 2/5 operator 1 Attack Rate and Rate Scaling
CH2_5_OP2_AR_RS:	equ $59		; Channel 2/5 operator 2 Attack Rate and Rate Scaling
CH2_5_OP3_AR_RS:	equ $55		; Channel 2/5 operator 3 Attack Rate and Rate Scaling
CH2_5_OP4_AR_RS:	equ $5D		; Channel 2/5 operator 4 Attack Rate and Rate Scaling

CH3_6_OP1_AR_RS:	equ $52		; Channel 3/6 operator 1 Attack Rate and Rate Scaling
CH3_6_OP2_AR_RS:	equ $5A		; Channel 3/6 operator 2 Attack Rate and Rate Scaling
CH3_6_OP3_AR_RS:	equ $56		; Channel 3/6 operator 3 Attack Rate and Rate Scaling
CH3_6_OP4_AR_RS:	equ $5E		; Channel 3/6 operator 4 Attack Rate and Rate Scaling

CH1_4_OP1_DR_AM:	equ $60		; Channel 1/4 operator 1 Decay Rate and Amplitude Modulation enable
CH1_4_OP2_DR_AM:	equ $68		; Channel 1/4 operator 2 Decay Rate and Amplitude Modulation enable
CH1_4_OP3_DR_AM:	equ $64		; Channel 1/4 operator 3 Decay Rate and Amplitude Modulation enable
CH1_4_OP4_DR_AM:	equ $6C		; Channel 1/4 operator 4 Decay Rate and Amplitude Modulation enable

CH2_5_OP1_DR_AM:	equ $61		; Channel 2/5 operator 1 Decay Rate and Amplitude Modulation enable
CH2_5_OP2_DR_AM:	equ $69		; Channel 2/5 operator 2 Decay Rate and Amplitude Modulation enable
CH2_5_OP3_DR_AM:	equ $65		; Channel 2/5 operator 3 Decay Rate and Amplitude Modulation enable
CH2_5_OP4_DR_AM:	equ $6D		; Channel 2/5 operator 4 Decay Rate and Amplitude Modulation enable

CH3_6_OP1_DR_AM:	equ $62		; Channel 3/6 operator 1 Decay Rate and Amplitude Modulation enable
CH3_6_OP2_DR_AM:	equ $6A		; Channel 3/6 operator 2 Decay Rate and Amplitude Modulation enable
CH3_6_OP3_DR_AM:	equ $66		; Channel 3/6 operator 3 Decay Rate and Amplitude Modulation enable
CH3_6_OP4_DR_AM:	equ $6E		; Channel 3/6 operator 4 Decay Rate and Amplitude Modulation enable

CH1_4_OP1_SR:	equ $70		; Channel 1/4 operator 1 Sustain Rate
CH1_4_OP2_SR:	equ $78		; Channel 1/4 operator 2 Sustain Rate
CH1_4_OP3_SR:	equ $74		; Channel 1/4 operator 3 Sustain Rate
CH1_4_OP4_SR:	equ $7C		; Channel 1/4 operator 4 Sustain Rate

CH2_5_OP1_SR:	equ $71		; Channel 2/5 operator 1 Sustain Rate
CH2_5_OP2_SR:	equ $79		; Channel 2/5 operator 2 Sustain Rate
CH2_5_OP3_SR:	equ $75		; Channel 2/5 operator 3 Sustain Rate
CH2_5_OP4_SR:	equ $7D		; Channel 2/5 operator 4 Sustain Rate

CH3_6_OP1_SR:	equ $72		; Channel 3/6 operator 1 Sustain Rate
CH3_6_OP2_SR:	equ $7A		; Channel 3/6 operator 2 Sustain Rate
CH3_6_OP3_SR:	equ $76		; Channel 3/6 operator 3 Sustain Rate
CH3_6_OP4_SR:	equ $7E		; Channel 3/6 operator 4 Sustain Rate

CH1_4_OP1_RR_SL:	equ $80		; Channel 1/4 operator 1 Release Rate and Sustain Level
CH1_4_OP2_RR_SL:	equ $88		; Channel 1/4 operator 2 Release Rate and Sustain Level
CH1_4_OP3_RR_SL:	equ $84		; Channel 1/4 operator 3 Release Rate and Sustain Level
CH1_4_OP4_RR_SL:	equ $8C		; Channel 1/4 operator 4 Release Rate and Sustain Level

CH2_5_OP1_RR_SL:	equ $81		; Channel 2/5 operator 1 Release Rate and Sustain Level
CH2_5_OP2_RR_SL:	equ $89		; Channel 2/5 operator 2 Release Rate and Sustain Level
CH2_5_OP3_RR_SL:	equ $85		; Channel 2/5 operator 3 Release Rate and Sustain Level
CH2_5_OP4_RR_SL:	equ $8D		; Channel 2/5 operator 4 Release Rate and Sustain Level

CH3_6_OP1_RR_SL:	equ $82		; Channel 3/6 operator 1 Release Rate and Sustain Level
CH3_6_OP2_RR_SL:	equ $8A		; Channel 3/6 operator 2 Release Rate and Sustain Level
CH3_6_OP3_RR_SL:	equ $86		; Channel 3/6 operator 3 Release Rate and Sustain Level
CH3_6_OP4_RR_SL:	equ $8E		; Channel 3/6 operator 4 Release Rate and Sustain Level

CH1_4_OP1_SSG_EG:	equ $90		; Channel 1/4 operator 1 envelope shape
CH1_4_OP2_SSG_EG:	equ $98		; Channel 1/4 operator 2 envelope shape
CH1_4_OP3_SSG_EG:	equ $94		; Channel 1/4 operator 3 envelope shape
CH1_4_OP4_SSG_EG:	equ $9C		; Channel 1/4 operator 4 envelope shape

CH2_5_OP1_SSG_EG:	equ $91		; Channel 2/5 operator 1 envelope shape
CH2_5_OP2_SSG_EG:	equ $99		; Channel 2/5 operator 2 envelope shape
CH2_5_OP3_SSG_EG:	equ $95		; Channel 2/5 operator 3 envelope shape
CH2_5_OP4_SSG_EG:	equ $9D		; Channel 2/5 operator 4 envelope shape

CH3_6_OP1_SSG_EG:	equ $92		; Channel 3/6 operator 1 envelope shape
CH3_6_OP2_SSG_EG:	equ $9A		; Channel 3/6 operator 2 envelope shape
CH3_6_OP3_SSG_EG:	equ $96		; Channel 3/6 operator 3 envelope shape
CH3_6_OP4_SSG_EG:	equ $9E		; Channel 3/6 operator 4 envelope shape

CH1_4_FREQ_H:	equ $A4		; Channel 1/4 frequency (high)
CH2_5_FREQ_H:	equ $A5		; Channel 2/5 frequency (high)
CH3_6_FREQ_H:	equ $A6		; Channel 3/6 frequency (high)

CH1_4_FREQ_L:	equ $A0		; Channel 1/4 frequency (low)
CH2_5_FREQ_L:	equ $A1		; Channel 2/5 frequency (low)
CH3_6_FREQ_L:	equ $A2		; Channel 3/6 frequency (low)

CH3_OP1_FREQ_H:		equ $AD		; Channel 3 operator 1 frequency (high)
CH3_OP2_FREQ_H:		equ $AE		; Channel 3 operator 2 frequency (high)
CH3_OP3_FREQ_H:		equ $AC		; Channel 3 operator 3 frequency (high)
CH3_OP4_FREQ_H:		equ $A6		; Channel 3 operator 4 frequency (high)

CH3_OP1_FREQ_L:		equ $A9		; Channel 3 operator 1 frequency (low)
CH3_OP2_FREQ_L:		equ $AA		; Channel 3 operator 2 frequency (low)
CH3_OP3_FREQ_L:		equ $A8		; Channel 3 operator 3 frequency (low)
CH3_OP4_FREQ_L:		equ $A2		; Channel 3 operator 4 frequency (low)

CH1_4_ALG_FB:	equ $B0		; Channel 1/4 Algorithm and Feedback
CH2_5_ALG_FB:	equ $B1		; Channel 2/5 Algorithm and Feedback
CH3_6_ALG_FB:	equ $B2		; Channel 3/6 Algorithm and Feedback

CH1_4_PAN_PMS_AMS:	equ $B4		; Channel 1/4 Panning, Phase Modulation Sensitivity and Amplitude Modulation Sensitivity
CH2_5_PAN_PMS_AMS:	equ $B5		; Channel 2/5 Panning, Phase Modulation Sensitivity and Amplitude Modulation Sensitivity
CH3_6_PAN_PMS_AMS:	equ $B6		; Channel 3/6 Panning, Phase Modulation Sensitivity and Amplitude Modulation Sensitivity

; Generic addresses for macros
OP1:	equ %0000
OP2:	equ %1000
OP3:	equ %0100
OP4:	equ %1100

CH1_4:	equ %0000
CH2_5:	equ %0001
CH3_6:	equ %0010