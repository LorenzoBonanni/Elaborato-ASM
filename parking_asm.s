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
        on:
        # se count è tre ho settato il valore iniziale di tutti i parcheggi
        cmp $3, count
        je normale
        # metto in bl il carattere presente a uno spiazzamento edx di esi
        movb (%edx, %esi, 1), %bl

        cmp lett_b, %bl
        jg c    # se carattere maggiore di b allora sarà c
        jl a    # se carattere minore di b allora sarà a 
        je b

    a:
        inc %edx
        # xorb %bl, %bl
        movb (%edx, %esi, 1), %bl
        cmp trattino, %bl
        je a    # bl == '-' -> torna ad a

        cmp lett_acapo, %bl
        subb $48, %bl   # trasforma il valore di bl da carattere ascii a numero
        je a    # bl == '\n' -> vai a continue
        cmp $0, %bh
        jne continue
        movb %bl, %bh
        jmp a

        continue:
        movb $10, %al
        mulb %bh    # ax = bl*10
        # obtain the value of the parking
        xorb %bh, %bh
        addw %ax, %bx
        movw %ax, A

        # increase count
        xorl %eax, %eax
        movl count, %eax
        inc %eax
        movl %eax, count
        inc %edx
        jmp on


    c:
        inc %edx
        movb (%edx, %esi, 1), %bl
        movb %cl, B
    

    b:
        inc %edx
        movb (%edx, %esi, 1), %bl
        movb %cl, B
    
    normale:
        xorl %eax, %eax
