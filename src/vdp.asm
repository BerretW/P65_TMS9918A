.include "io.inc65"
.include "macros_65c02.inc65"




.zeropage

vdp_reg0:			.res 1
vdp_reg1:			.res 1
vdp_reg2:			.res 1
vdp_reg3:			.res 1
vdp_reg4:			.res 1
vdp_reg5:			.res 1
vdp_reg6:			.res 1
vdp_reg7:			.res 1
.smart		on
.autoimport	on
.case		on
.debuginfo	off
.importzp	sp, sreg, regsave, regbank
.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack	longbranch

.globalzp vdp_reg0,vdp_reg1,vdp_reg2,vdp_reg3,vdp_reg4,vdp_reg5,vdp_reg6,vdp_reg7

.export _vdp_init
.export _vdp_fill_vram
.export _vdp_fill

.code

_vdp_init:  JSR _vdp_clr_vram
            LDA #0
            STA vdp_reg0
            STA vdp_reg1
            STA vdp_reg2
            STA vdp_reg3
            STA vdp_reg4
            STA vdp_reg5
            STA vdp_reg6
            STA vdp_reg7

            RTS

_vdp_screenmode:


_vdp_fill_vram: JSR _vdp_wr_vram_data
                dex
                bne _vdp_fill_vram
                dey
                bne _vdp_fill_vram
                rts

_vdp_fill:      PHA
                LDX #$0
                LDA #$0
                JSR _vdp_wr_addr
                PLA
                LDY #$40
                JSR _vdp_fill_vram
                RTS

  _vdp_clr_vram:LDA #$0
                JSR _vdp_fill
                RTS
