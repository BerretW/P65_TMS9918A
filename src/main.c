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

void vdp_set_bg(char color_id){
  vdp_wr_reg( 0x7, color_id);
}
int nasobek(int cislo){
  return cislo *4;

}


void main(void) {

  int i;
  char c;
  vdp_init();
  vdp_wr_reg( 0x1, 0xCF); //set text mode
  //print_f("Appartus VDP Demo");
  //str_a_to_x(0xAC);
  //vdp_wr_addr(0x1010);

while(1){


for (i = 0; i<=0x0F; ++i){
  c = acia_getc();
  //acia_putc(i+0x30);
  vdp_set_bg(i);
//  vdp_wr_vram(0xFFF,c);
  vdp_fill(c);
}
}
}
