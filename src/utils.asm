.include "io.inc65"
.include "macros_65C02.inc65"

.zeropage


.smart		on
.autoimport	on
.case		on
.debuginfo	off
.importzp	sp, sreg, regsave, regbank
.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack	longbranch



.export _format_bank
.export _write_to_BANK
.export _switch_bank
.export _str_a_to_x
.export _format_zp
.code

_format_zp:	LDX #$FF
						LDA #$00

@clr:				STA $0,X
						DEX
						BNE @clr
						RTS

_format_bank:     	LDY #0
					LDA #<(BANKDISK)
					LDX #>(BANKDISK)
					STA ptr1
					STX ptr1 + 1

@write_BANK:		LDA #$0
					STA (ptr1), Y
					INY
					CPY #$0
					BNE @end_BANK
					INX
					STX ptr1 + 1
					CPX #$C0
					BNE @end_BANK
					RTS
@end_BANK:			JMP @write_BANK

_write_to_BANK:
					LDY #0
					LDA #<(BANKDISK)
					LDX #>(BANKDISK)
					STA ptr1
					STX ptr1 + 1

@write_BANK:		JSR _acia_getc
					;JSR _lcd_putc
					STA (ptr1), Y
					INY
					CPY #$0
					BNE @end_BANK
					INX
					STX ptr1 + 1
					CPX #$C0
					BNE @end_BANK
          INC BANK_BASE
					JMP _write_to_BANK
@end_BANK:			JMP @write_BANK


_switch_bank: INC BANK_BASE
              RTS


;****************************************
;* str_a_to_x
;* Convert accumulator to hex string
;* Input : A = Byte to convert
;* Output : A = High Char, X = Low Char
;* Regs affected : P
;****************************************
_str_a_to_x:
	pha					; Save the byte using later on
	and #$0f			; Mask low nibble
	clc
	adc #'0'			; Convert to UTF
	cmp #('9'+1)		; If A greater than '9' then
	bcc skip_a_f_1		; skip a-f adjustment
	adc #$26			; Add 27 (6+C) to get in to A-F range
skip_a_f_1:
	tax					; Low char is in X
	pla					; Get byte back
	lsr a				; Make high nibble low
	lsr a
	lsr a
	lsr a
	clc
	adc #'0'			; Convert to UTF
	cmp #('9'+1)		; If A greater than '9' then
	bcc skip_a_f_2		; skip a-f adjustment
	adc #$26			; Add 27 (6+C) to get in to A-F range
skip_a_f_2:	clc					; No error
						STA ACIA_DATA
						STX ACIA_DATA
						rts					; A high nibble

_delay:					LDX #$1
_delay1:				DEX
                BNE _delay1
                RTS
_delay2:				LDX #$FF
_delay3:				DEX
                BNE _delay3
                RTS
