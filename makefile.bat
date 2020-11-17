del .\output\*.*

cd .\src
cc65 -t none -O --cpu 65C02 main.c
ca65 --cpu 6502 main.s -o ..\output\main.o
ca65 --cpu 65C02 utils.asm -o ..\output\utils.o
ca65 --cpu 65C02 vectors.asm -o ..\output\vectors.o
ca65 --cpu 65C02 acia.asm -o ..\output\acia.o
ca65 --cpu 65C02 interrupts.asm -o ..\output\interrupts.o
ca65 --cpu 65C02 vdp_low.asm -o ..\output\vdp_low.o
ca65 --cpu 65C02 vdp.asm -o ..\output\vdp.o
ca65 --cpu 65C02 vdp_graph.asm -o ..\output\vdp_graph.o

move *.s ..\output

cd ..\output

ld65 -C ..\config\APP_RAM_DISK.cfg -m main.map main.o utils.o acia.o vdp_low.o vdp.o vdp_graph.o interrupts.o vectors.o ..\library\p65.lib -o ..\output\RAM.bin
