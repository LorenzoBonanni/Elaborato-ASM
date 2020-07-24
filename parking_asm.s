# Per compilare:
# gcc -m32 -c -o parking.o parking.c
# gcc -m32 -c -o parking_asm.o parking_asm.s 
# gcc -m32 -o c-asm parking.o parking_asm.o

.section .data # sezione variabili globali

lett_a: .ascii "A"
lett_b: .ascii "B"
lett_c: .ascii "C"
lett_term: .ascii "\0"
lett_acapo: .ascii "\n"
trattino: .ascii "-"

A: .long 0
B: .long 0
C: .long 0
count: .long 0

.section .text # sezione istruzioni
.global day 
    
    day:
        movl 4(%esp), %esi
        movl 8(%esp), %edi
        movl $0, %edx
        xorl %ebx, %ebx
        xorl %eax, %eax
        on:
        # metto in bl il carattere presente a uno spiazzamento edx di esi
        movb (%edx, %esi, 1), %bl

        cmp lett_b, %bl
        jg c    # se carattere maggiore di b allora sarà c
        jl a    # se carattere minore di b allora sarà a 

    a:
        inc %edx
        xorl %ebx, %ebx
        movb (%edx, %esi, 1), %bl
        cmp trattino, %bl
        je a    # bl == '-' -> torna ad a
       
        subb %bl, $48   # trasforma il valore di bl da carattere ascii a numero
        cmp $0, %al
        je second_num
        first_num:
        movb %bl, %al
        mulb $10
        movw %ax, A
        jmp a
        second_num:
        addb A, %bl
        jmp day



    c:
        inc %edx
        movb (%edx, %esi, 1), %bl
        movb %cl, B
