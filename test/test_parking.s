
# Per compilare:
# gcc -m32 -c -o parking.o parking.c
# gcc -m32 -c -o parking_asm.o parking_asm.s 
# gcc -m32 -o c-asm parking.o parking_asm.o

.section .data # sezione variabili globali
input: .ascii "0"
len: .long .-input

.section .text # sezione istruzioni
.global day 

    str_len:
        lodsb				# read byte of string, then automaticaly increment position in string (next byte)
        cmpb $0,%al			# if readed byte equal 0, so end of string reached
        jz   continue				
        incl %ecx			# counter
        jmp  str_len		# repeat procedure

    continue:
        decl %ecx

    day:
        movl 4(%esp), %esi
        xorl %eax, %eax
        xorl %ecx, %ecx
        jmp str_len
