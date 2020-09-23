#!/bin/bash

gcc -m32 -c -o parking.o parking.c
gcc -m32 -c -o test_parking.o test_parking.s 
gcc -m32 -o c-asm parking.o test_parking.o
edb --run c-asm testin.txt out.txt
