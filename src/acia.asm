.include "io.inc65"
.include "macros_65C02.inc65"

.zeropage

tmpstack:			.res 1


.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.globalzp tmpstack

.export _acia_init
.export _acia_putc
.export _acia_puts
.export _acia_getc
.export _acia_put_newline



          .code

; void acia_init()
; Initialize the ACIA
_acia_init:        pha
        lda #(ACIA_PARITY_DISABLE | ACIA_ECHO_DISABLE | ACIA_TX_INT_DISABLE_RTS_LOW | ACIA_RX_INT_DISABLE | ACIA_DTR_LOW)
        sta ACIA_COMMAND
        lda #(ACIA_STOP_BITS_1 | ACIA_DATA_BITS_8 | ACIA_CLOCK_INT | ACIA_BAUD_19200)
        sta ACIA_CONTROL
        pla
        rts

; void acia_putc(char c)
; Send the character c to the serial line
; @in A (c) character to send
_acia_putc:         pha
@wait_txd_empty:    lda ACIA_STATUS
          and #ACIA_STATUS_TX_EMPTY
          beq @wait_txd_empty
          pla
          sta ACIA_DATA

          rts

; void acia_puts(const char * s)
; Send the zero terminated string pointed to by A/X
; @in A/X (s) pointer to the string to send
; @mod ptr1
_acia_puts:         phay
          sta ptr1
          stx ptr1 + 1
          ldy #0
@next_char:         lda (ptr1),y
          beq @eos
          jsr _acia_putc
          iny
          bne @next_char
@eos:               play
          rts
; void acia_put_newline()
; Send a newline character
_acia_put_newline:  pha
          lda #$0a
          jsr _acia_putc
          pla
          rts

; char acia_getc()
; Wait until a character was reveiced and return it
; @out A The received character
_acia_getc:
@wait_rxd_full:     lda ACIA_STATUS
          and #ACIA_STATUS_RX_FULL
          beq @wait_rxd_full
          lda ACIA_DATA
          rts

; Latest WDC 65C51 has a bug - Xmit bit in status register is stuck on
; IRQ driven transmit is not possible as a result - interrupts are endlessly triggered
; Polled I/O mode also doesn't work as the Xmit bit is polled - delay routine is the only option
; The following delay routine kills time to allow W65C51 to complete a character transmit
; 0.523 milliseconds required loop time for 19,200 baud rate
; MINIDLY routine takes 524 clock cycles to complete - X Reg is used for the count loop
; Y Reg is loaded with the CPU clock rate in MHz (whole increments only) and used as a multiplier
