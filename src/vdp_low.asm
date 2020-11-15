.include "io.inc65"
.include "macros_65c02.inc65"

.zeropage

radek:			.res 1


.export _vdp_wr_reg
.export _vdp_wr_vram
.export _vdp_rd_vram
.export _vdp_rd_stat_reg
.export _vdp_wr_addr
.export _vdp_wr_vram_data

.zeropage
.smart		on
.autoimport	on
.case		on
.debuginfo	off
.importzp	sp, sreg, regsave, regbank
.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack	longbranch

.globalzp tmpstack



.code


;****************************************
;* _vdp_wr_reg
;* Write to Register A the value X
;* Input : A - Register Number, X - Data
;* Output : None
;* Regs affected : P
;****************************************
_vdp_wr_reg:
	sta VDP_MODE1
; Extra nop for fast CPU
	nop
	nop
	nop
	nop
	LDY #$00
	LDA (sp),y
	ora #$80
	sta VDP_MODE1
	eor #$80
	jmp incsp1

_vdp_rd_stat_reg:
		LDA VDP_MODE1
		RTS

_vdp_wr_vram:	JSR pusha

							LDY #$01
							LDA (sp),y
							STA VDP_MODE1

							LDY #$02
							LDA (sp),y
							ora #$40
							STA VDP_MODE1
							eor #$40

							LDY #$00
							LDA (sp),y
							STA VDP_MODE0
							JMP incsp3

_vdp_rd_vram:	STA VDP_MODE1
							STX VDP_MODE1
							LDA VDP_MODE0
							RTS

							;****************************************
							;* vdp_mem_wait
							;* Delay some time before a memory access,
							;* taking in to account mode 9918 needs up
							;* to 3.1uS for text mode, 8uS for graphics
							;* I and II
							;* @ 5.35Mhz	= 16 cycles for 3.1uS
							;*				= 43 cycles for 8uS
							;* Input : None
							;* Output : None
							;* Regs affected : None
							;****************************************
	vdp_mem_wait:
								phx								; 3
								ldx #8				; 3
								beq vdp_mem_wait_end			; 3
	vdp_mem_wait_loop:
								dex								; 2
								bne	vdp_mem_wait_loop			; 3
	vdp_mem_wait_end:
								plx								; 3
								rts

							;****************************************
							;* vdp_wr_addr
							;* Write to address in X (low) and A (high) - for writing
							;* Input : A - Address high byte, X - Address low byte
							;* Output : None
							;* Regs affected : P
							;****************************************
_vdp_wr_addr:
							stx VDP_MODE1
						; Extra nop for fast CPU
							nop
							nop
							nop
							nop
							ora #$40		; Required by VDP
							sta VDP_MODE1
							eor #$40		; Undo that bit
							rts
							;****************************************
							;* vdp_wr_vram
							;* Write VRAM byte in A
							;* Input : A - Byte to write
							;* Output : None
							;* Regs affected : None
							;****************************************
_vdp_wr_vram_data:nop
								nop
								nop
								sta VDP_MODE0
								bra vdp_mem_wait
