;
; File generated by cc65 v 2.18 - Git b5f0c04
;
	.fopt		compiler,"cc65 v 2.18 - Git b5f0c04"
	.setcpu		"65C02"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.forceimport	__STARTUP__
	.import		_acia_init
	.import		_acia_puts
	.import		_acia_put_newline
	.import		_acia_getc
	.import		_format_zp
	.import		_vdp_init
	.import		_VDP_print_char
	.export		_print_f
	.export		_main

; ---------------------------------------------------------------
; void __near__ print_f (char *s)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_print_f: near

.segment	"CODE"

	jsr     pushax
	jsr     _acia_put_newline
	jsr     ldax0sp
	jsr     _acia_puts
	jmp     incsp2

.endproc

; ---------------------------------------------------------------
; void __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

.segment	"CODE"

	jsr     decsp3
	jsr     _format_zp
	jsr     _acia_init
	jsr     _vdp_init
	ldx     #$00
L000A:	lda     #$02
	ldy     #$01
	jsr     staxysp
L0005:	ldy     #$02
	jsr     ldaxysp
	cmp     #$10
	txa
	sbc     #$00
	bvc     L0009
	eor     #$80
L0009:	asl     a
	ldx     #$00
	bcc     L000A
	jsr     _acia_getc
	sta     (sp)
	jsr     _VDP_print_char
	ldy     #$01
	ldx     #$00
	tya
	jsr     addeqysp
	bra     L0005

.endproc

