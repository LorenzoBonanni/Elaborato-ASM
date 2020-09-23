# Per compilare:
# gcc -m32 -c -o parking.o parking.c
# gcc -m32 -c -o parking_asm.o parking_asm.s 
# gcc -m32 -o c-asm parking.o parking_asm.o

.section .data # sezione variabili globali

lett_a: .ascii "A"
lett_b: .ascii "B"
lett_c: .ascii "C"
lett_O: .ascii "O"
lett_U: .ascii "U"
lett_T: .ascii "T"

lett_acapo: .ascii "\n"
trattino: .ascii "-"

A: .long 0
B: .long 0
C: .long 0
MAX_AB: .long 31
MAX_C: .long 24
count: .long 0

.section .text # sezione istruzioni
.global day 

    day:
        movl 4(%esp), %esi
        movl 8(%esp), %edi
        on:
        xorl %eax, %eax
        xorl %ebx, %ebx
        # se count è tre ho settato il valore iniziale di tutti i parcheggi
        cmp $3, count
        je normale
        # metto in al il primo carattere di esi
        lodsb
        
        # check if al value is \n
        cmp lett_acapo, %al
        jne donotadd
        lodsb
        donotadd:
        cmp lett_b, %al
        jg c    # se carattere maggiore di b allora sarà c
        jl a    # se carattere minore di b allora sarà a 
        jmp b

    a:
        lodsb
        movb %al, %bl
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

        # go back to on
        jmp on
    

    b:
        lodsb
        movb %al, %bl
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

        # go back to on
        jmp on

    c:
        lodsb
        movb %al, %bl
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

        #go abck to on
        jmp on

    normale:
        # ERROR: ho 5 output in più, debugga
        xorl %ecx, %ecx
        normale_wocln:
        lodsb

        # check if esi value is \0
        cmpb $0, %al
        je fine

        # check if al value is \n
        cmp lett_acapo, %al
        jne continue_n
        jmp normale_wocln

        continue_n:
        xorb %ah, %ah
        cmp $73, %al # 73 -> ascii I
        je in
        cmp $79, %al # 79 -> ascii O
        je out
        jmp anomalia

    in:
        lodsb
        
        # se bh != O --> è il secondo carattere
        cmp $0, %ah
        jne continue_in
        movb %al, %ah
        jmp in

        continue_in:
        # se bh != 'N' --> anomalia
        cmp $78, %ah # 78 -> ascii N
        jne anomalia
        # se bl != '-' --> anomalia
        cmp trattino, %al
        jne anomalia
        lodsb

        # find which parking the user want to go
        cmp lett_a, %al
        je in_a
        cmp lett_b, %al
        je in_b
        cmp lett_c, %al
        je in_c
        jmp anomalia

    in_a:
        movl MAX_AB, %eax
        cmp %eax, A
        jge anomalia

        # increase A
        movl A, %eax
        inc %eax
        movl %eax, A
        call open_in
        
        jmp normale_wocln

    in_b:
        movl MAX_AB, %eax
        cmp %eax, B
        jge anomalia

        # increase B
        movl B, %eax
        inc %eax
        movl %eax, B
        call open_in

        jmp normale_wocln

    in_c:
        movl MAX_C, %eax
        cmp %eax, C
        jge anomalia

        # increase B
        movl C, %eax
        inc %eax
        movl %eax, C
        call open_in


        jmp normale_wocln


    open_in:
        # insert 'O'
        movb lett_O, %bl
        movb %bl, (%ecx,%edi,1)
        inc %ecx

        # insert 'C'
        movb lett_c, %bl
        movb %bl, (%ecx,%edi,1)
        inc %ecx

        # insert '-'
        movb trattino, %bl
        movb %bl, (%ecx,%edi,1)
        inc %ecx

        call parking_slots
        ret

    open_out:
        # insert 'C'
        movb lett_c, %bl
        movb %bl, (%ecx,%edi,1)
        inc %ecx

        # insert 'O'
        movb lett_O, %bl
        movb %bl, (%ecx,%edi,1)
        inc %ecx

        # insert '-'
        movb trattino, %bl
        movb %bl, (%ecx,%edi,1)
        inc %ecx

        call parking_slots
        ret

    parking_slots:
        # A slots
        xorl %eax, %eax
        movb $10, %bl
        movb A, %al
        divb %bl
        # first number
        addb $48, %al   # dec -> ascii
        movb %al, (%ecx,%edi,1)
        inc %ecx
        # second number
        addb $48, %ah   # dec -> ascii
        movb %ah, (%ecx,%edi,1)
        inc %ecx
        # insert '-'
        movb trattino, %bl
        movb %bl, (%ecx,%edi,1)
        inc %ecx

        # B slots
        xorl %eax, %eax
        movb $10, %bl
        movb B, %al
        divb %bl
        # first number
        addb $48, %al   # dec -> ascii
        movb %al, (%ecx,%edi,1)
        inc %ecx
        # second number
        addb $48, %ah   # dec -> ascii
        movb %ah, (%ecx,%edi,1)
        inc %ecx
        # insert '-'
        movb trattino, %bl
        movb %bl, (%ecx,%edi,1)
        inc %ecx

        # C slots
        xorl %eax, %eax
        movb $10, %bl
        movb C, %al
        divb %bl
        # first number
        addb $48, %al   # dec -> ascii
        movb %al, (%ecx,%edi,1)
        inc %ecx
        # second number
        addb $48, %ah   # dec -> ascii
        movb %ah, (%ecx,%edi,1)
        inc %ecx
        # insert '-'
        movb trattino, %bl
        movb %bl, (%ecx,%edi,1)
        inc %ecx

        call parking_status
        ret

    parking_status:
        movl MAX_AB, %eax
        cmp %eax, A
        jl a_0
        call set_1
        jmp status_b
        a_0:
        call set_0

        status_b:
        movl MAX_AB, %eax
        cmp %eax, B
        jl b_0
        call set_1
        jmp status_c
        b_0:
        call set_0

        status_c:
        movl MAX_C, %eax
        cmp %eax, C
        jl c_0
        call set_1
        jmp end_pstatus
        c_0:
        call set_0

        end_pstatus:
        movb lett_acapo, %bl
        movb %bl, (%ecx,%edi,1)

        inc %ecx
        ret

    set_0:
        movb $48, (%ecx,%edi,1) # 48 = 0 ascii
        inc %ecx
        ret

    set_1:
        movb $49, (%ecx,%edi,1) # 49 = 1 ascii
        inc %ecx
        ret

    out:
        lodsb
        movb %al, %bl
        
        cmp lett_U, %bl
        je out
        cmp lett_T, %bl
        jne anomalia
        

        lodsb
        movb %al, %bl
        # se bl != '-' --> anomalia
        cmp trattino, %bl
        jne anomalia
        lodsb
        movb %al, %bl

        # find which parking the user want to go
        cmp lett_a, %bl
        je out_a
        cmp lett_b, %bl
        je out_b
        cmp lett_c, %bl
        je out_c
        jmp anomalia

    out_a:
        # decrease A
        movl A, %eax
        dec %eax
        movl %eax, A
        call open_out
        
        jmp normale_wocln

    out_b:
        # decrease B
        movl B, %eax
        dec %eax
        movl %eax, B
        call open_out
        
        jmp normale_wocln

    out_c:
        # decrease C
        movl C, %eax
        dec %eax
        movl %eax, C
        call open_out
        
        jmp normale_wocln

    anomalia:
        # insert 'C'
        movb lett_c, %bl
        movb %bl, (%ecx,%edi,1)
        inc %ecx

        # insert 'C'
        movb %bl, (%ecx,%edi,1)
        inc %ecx

        # insert '-'
        movb trattino, %bl
        movb %bl, (%ecx,%edi,1)
        inc %ecx

        call parking_slots
        jmp normale_wocln


    fine:
        movb $0, (%ecx,%edi,1)
        movl %edi, %eax
        ret
