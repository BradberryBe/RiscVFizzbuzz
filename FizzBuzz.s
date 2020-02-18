# Implementation of Fizzbuzz in RISCV
# Ben Bradberry
# 2/18/20
# Not tested on native hardware, run on https://www.kvakil.me/venus/
.data
    lim: .word 100                          # Fizzbuzz loop limit
    fizz: .asciiz "Fizz"
    buzz: .asciiz "Buzz"
    nl: .asciiz "\n"

.text
    main:
        lw a2, lim                          # load lim into a2
        addi a6, zero, 0                    # reset i to 0, i = 0 + 0
        addi a3, zero, 3                    # load 3 into a3
        addi a4, zero, 5                    # load 5 into a4
        jal ra, loop
        addi, a0, zero, 10                  # set a0 up for system exit
        ecall                               # Exit

    loop:                                   # The start of the loop
        addi a5, zero, 1                    # FizzFlag = true
        rem t1, a7, a3                      # t1 = i % 3
        beq t1, zero, fizzprnt              # if i % 3 == 0, goto fizz
    loopmid:                                # Location to jump back to after posting fizz
        rem t1, a7, a4                      # t1 = i % 5
        beq t1, zero, buzzprnt             # if i % 5 == 0, goto buzz
        bne a5, zero, num                   # if flag = false, goto num
    loopend:
    	addi a0, zero, 4					# prep a0 for string ecall
        la a1, nl                           # load a newline to print
        ecall
        beq a7, a2, end                     # if i == lim break out
        addi a7, a7, 1                      # i = i + 1
        jal zero, loop                      # start loop

    fizzprnt:
        addi a0, zero, 4                    # prep a0 for ecall
        la a1, fizz                         # load fizz
        ecall
        mul a5, a5, zero                    # FizzFlag = false
        jal zero, loopmid

    buzzprnt:
        addi a0, zero, 4                    # prep a0 for ecall
        la a1, buzz                         # load buzz
        ecall
        mul a5, a5, zero                    #FizzFlag = false
        jal zero, loopend
    
    num:
        addi a0, zero, 1                    # prep a0 for ecall
        add a1, zero, a7                    # load a7 into a1         
        ecall
        jal zero, loopend                   

    end:
        jalr zero, 0(ra)                    # return to main