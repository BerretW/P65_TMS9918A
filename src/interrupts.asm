.include "io.inc65"
; ---------------------------------------------------------------------------
; interrupt.s
; ---------------------------------------------------------------------------
;
; Interrupt handler.
;
; Checks for a BRK instruction and returns from all valid interrupts.

;.import   _stop
.import   _acia_putc
.export   _irq_int, _nmi_int

.segment  "CODE"

.PC02                             ; Force 65C02 assembly mode

; ---------------------------------------------------------------------------
; Non-maskable interrupt (NMI) service routine

_nmi_int:   SEI
            RTI                    ; Return from all NMI interrupts

; ---------------------------------------------------------------------------
; Maskable interrupt (IRQ) service routine
_irq_int:   PHA;
            LDA IRQ_DATA
            JSR _acia_putc
            PLA

            RTI

;_irq_int1:  PHX                    ; Save X register contents to stack
;           TSX                    ; Transfer stack pointer to X
;           PHA                    ; Save accumulator contents to stack
;           INX                    ; Increment X so it points to the status
;           INX                    ;   register value saved on the stack
;           LDA $100,X             ; Load status register contents
;           AND #$10               ; Isolate B status bit
;           BNE break              ; If B = 1, BRK detected


; ---------------------------------------------------------------------------
; BRK detected, stop

;break:     JMP _stop              ; If BRK is detected, something very bad
                                  ;   has happened, so stop running
