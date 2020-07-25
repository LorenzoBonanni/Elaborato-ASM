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
    add_one:
        addl $1, %edx
        jmp on

    day:
        movl 4(%esp), %esi
        movl 8(%esp), %edi
        movl $0, %edx
        on:
        xorl %ebx, %ebx
        # se count è tre ho settato il valore iniziale di tutti i parcheggi
        cmp $3, count
        je normale
        # metto in bl il carattere presente a uno spiazzamento edx di esi
        movb (%edx, %esi, 1), %bl
        
        # check if bl value is \n
        cmp lett_acapo, %bl
        je add_one

        cmp lett_b, %bl
        jg c    # se carattere maggiore di b allora sarà c
        jl a    # se carattere minore di b allora sarà a 
        jmp b

    a:
        inc %edx
        movb (%edx, %esi, 1), %bl
        cmp trattino, %bl
        je a    # bl == '-' -> torna ad a

        cmp lett_acapo, %bl
        je single_number_a # bl == '\n' -> vai a single_number

        subb $48, %bl   # trasforma il valore di bl da carattere ascii a numero
        cmp $0, %bh
        jne continue_a
        movb %bl, %bh
        jmp a

        continue_a:
        # ax = bl*10
        movb $10, %al
        mulb %bh

        # insert in A the number of cars if the value is composed by 2numbers
        xorb %bh, %bh
        addw %ax, %bx
        movw %bx, A
        jmp end_a

        # insert in A the number of cars if the value is composed by 1number
        single_number_a:
        movb %bh, A

        end_a:
        # increase count
        xorl %eax, %eax
        movl count, %eax
        inc %eax
        movl %eax, count

        #increase edx and retrurn to on
        inc %edx
        jmp on
    

    b:
        inc %edx
        movb (%edx, %esi, 1), %bl
        cmp trattino, %bl
        je b    # bl == '-' -> jump to b

        cmp lett_acapo, %bl
        je single_number_b # bl == '\n' -> jump to single_number

        subb $48, %bl   # transform bl from ascii to number
        cmp $0, %bh
        jne continue_b  # if bh is 0 it means that the value of bh is the first of 2 number or it is the only one
        movb %bl, %bh
        jmp b

        continue_b:
        # ax = bl*10
        movb $10, %al
        mulb %bh

        # insert into B the number of cars if the value is composed by 2numbers
        xorb %bh, %bh
        addw %ax, %bx
        movw %bx, B
        jmp end_b

        # insert into B the number of cars if the value is composed by 1number
        single_number_b:
        movb %bh, B

        end_b:
        # increase count
        xorl %eax, %eax
        movl count, %eax
        inc %eax
        movl %eax, count

        #increase edx and retrurn to on
        inc %edx
        jmp on

    c:
        inc %edx
        movb (%edx, %esi, 1), %bl
        cmp trattino, %bl
        je c    # bl == '-' -> jump to b

        cmp lett_acapo, %bl
        je single_number_c # bl == '\n' -> jump to single_number

        subb $48, %bl   # transform bl from ascii to number
        cmp $0, %bh
        jne continue_c  # if bh is 0 it means that the value of bh is the first of 2 number or it is the only one
        movb %bl, %bh
        jmp c

        continue_c:
        # ax = bl*10
        movb $10, %al
        mulb %bh

        # insert in C the number of cars if the value is composed by 2numbers
        xorb %bh, %bh
        addw %ax, %bx
        movw %bx, C
        jmp end_c

        # insert in B the number of cars if the value is composed by 1number
        single_number_c:
        movb %bh, C

        end_c:
        # increase count
        xorl %eax, %eax
        movl count, %eax
        inc %eax
        movl %eax, count

        #increase edx and retrurn to on
        inc %edx
        jmp on

    normale:
        xorl %eax, %eax
