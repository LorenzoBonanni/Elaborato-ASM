# Per compilare:
# gcc -m32 -c -o parking.o parking.c
# gcc -m32 -c -o parking_asm.o parking_asm.s 
# gcc -m32 -o c-asm parking.o parking_asm.o

.section .data # sezione variabili globali

lett_a: .ascii "A"
lett_b: .ascii "B"
lett_c: .ascii "C"
lett_term: .ascii "\0"
lett_acapo: .ascii "\n\n"
buffer_in: .ascii ""
var: .ascii "fine\n"

A: .long 0
B: .long 0
C: .long 0

.section .text # sezione istruzioni
.global on 
    
    on:
        movl 4(%esp), %esi
        movl $0, %edx
        xorl %ecx, %ecx
        # NON TOCCARE! METTO IN CL IL CARATTERE
        movb (%edx, %esi, 1), %cl
        cmp %cl, lett_a

    #a:
    #	movl $4, %eax
	#    movl $0, %ebx
	#    leal lett_a, %ecx
	#    movl $1, %edx
	#    int $0x80


    #fine:
    #    movl $4, %eax
	#    movl $0, %ebx
	#    leal fine, %ecx
	#    movl $5, %edx
	#    int $0x80
    #    ret
