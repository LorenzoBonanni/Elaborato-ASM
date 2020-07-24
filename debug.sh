#!/bin/bash

gcc -m32 -c -o parking.o parking.c
gcc -m32 -c -o parking_asm.o parking_asm.s 
gcc -m32 -o c-asm parking.o parking_asm.o
edb --run c-asm testin.txt out.txt
