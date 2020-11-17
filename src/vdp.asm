.include "io.inc65"
.include "macros_65c02.inc65"




.zeropage
_vdp_reg0:			.res 1
_vdp_reg1:			.res 1
.globalzp _vdp_reg0, _vdp_reg1

.smart		on
.autoimport	on
.case		on
.debuginfo	off
.importzp	sp, sreg, regsave, regbank
.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack	longbranch


.export _vdp_init
.export _vdp_fill_vram
.export _vdp_fill
.export _vdp_screen_mode0, _vdp_screen_mode1, _vdp_screen_mode2, _vdp_screen_mode3,_vdp_set_bgc

.code

_vdp_init:  JSR _vdp_clr_vram
            LDA #0
            STA _vdp_reg0
            STA _vdp_reg1


            LDX #$0
            STX _vdp_reg0
            LDA #$0
            JSR _vdp_wr_reg

            LDX #(VDP_16K | VDP_SBLANK)
            STX _vdp_reg1
            LDA #$1
            JSR _vdp_wr_reg
            RTS


_vdp_set_bgc:       TAX
                    LDA #$7
                    JSR _vdp_wr_reg
                    RTS

_vdp_screen_mode0:	LDA _vdp_reg0
                    AND #%11111101
                    STA _vdp_reg0

					          TAX
          					LDA #$0
          					JSR _vdp_wr_reg

          					LDA _vdp_reg1
          					AND #%11100111
          					STA _vdp_reg1

          				  TAX
          					LDA #$1
          					JSR _vdp_wr_reg
          					RTS

_vdp_screen_mode1:	LDA _vdp_reg0
                    AND #%11111101
                    STA _vdp_reg0
          					TAX
          					LDA #$0
          					JSR _vdp_wr_reg

          					LDA _vdp_reg1
          					AND #%11100111
          					ORA #VDP_GMODE1
          					STA _vdp_reg1

          					TAX
          					LDA #$1
          					JSR _vdp_wr_reg
          					RTS

_vdp_screen_mode2:	LDA _vdp_reg0
                    AND #%11111101
                    ORA #VDP_GMODE2
                    STA _vdp_reg0
          					TAX
          					LDA #$0
          					JSR _vdp_wr_reg

          					LDA _vdp_reg1
          					AND #%11100111
          					STA _vdp_reg1

          					TAX
          					LDA #$1
          					JSR _vdp_wr_reg
          					RTS

_vdp_screen_mode3:	LDA _vdp_reg0
                    AND #%11111101
                    STA _vdp_reg0
          					TAX
          					LDA #$0
          					JSR _vdp_wr_reg

          					LDA _vdp_reg1
          					AND #%11100111
          					ORA #VDP_GMODE3
          					STA _vdp_reg1

          					TAX
          					LDA #$1
          					JSR _vdp_wr_reg
          					RTS


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
