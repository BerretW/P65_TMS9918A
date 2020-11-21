#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "acia.h"
#include "utils.h"
#include "vdp_low.h"
#include "vdp.h"

void print_f(char * s){
  acia_put_newline();
  acia_puts(s);
}





void main(void) {

  IRQ_enable();
  format_zp();
  acia_init();
  vdp_init();
  //vdp_screen_mode3();
  //
  //print_f("Appartus VDP Demo");
  //str_a_to_x(0xAC);

  //vdp_wr_reg( 0x1, 0xCF); //set text mode
  //vdp_wr_addr(0x1010);
while(1){

  VDP_print_char(acia_getc());

}
}
