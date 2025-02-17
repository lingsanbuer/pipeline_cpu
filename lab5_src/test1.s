# -------------------------------------------------------
# File:         test_scpu.s
# Maintainer:   ziyue
# Date:         2021-02-24 13：33
# Purpose:      test some basic instructions of cpu core.
# -------------------------------------------------------

    addi    zero, zero, 0
    
# test I type
    addi    a0, zero, 7     # a0 = 0x0000_0007
    slti    a1, a0, 9       # a1 = 0x0000_0001
    sltiu   a2, a0, 8       # a2 = 0x0000_0001 
    xori    a3, a0, 8       # a3 = 0x0000_000F
    ori     a4, a0, 6       # a4 = 0x0000_0007
    andi    a5, a0, 6       # a5 = 0x0000_0006
    slli    a6, a0, 2       # a6 = 0x0000_001C
    srli    a1, a0, 1       # a1 = 0x0000_0003
    srai    a7, a0, 0       # a7 = 0x0000_0007

# test R type
    add     s1, a0, a0      # s1 = 0x0000_000E
    sub     s2, a6, a0      # s2 = 0x0000_0015
    sll     s3, a6, a3      # s3 = 0x000E_0000
    slt     s4, a0, s3      # s4 = 0x0000_0001
    xor     s5, a0, a3      # s5 = 0x0000_0008
    srl     s6, a0, a2      # s6 = 0x0000_0003
    or      s7, a0, a4      # s7 = 0x0000_0007
    and     s8, a0, a2      # s8 = 0x0000_0001
    sltu    s9, s8, s7      # s9 = 0x0000_0001
    sra     s10, s7, s9     # s10 = 0x0000_0003

# test LW and SW
    lw      s0, 0(zero)     # s0 = 0x1234_5678
    slli    s0, s0, 1       # s0 = 0x2468_acf0
    sw      s0, 4(zero)     # (* no GPRs modified *)
    lw      a0, 4(zero)     # a0 = 0x2468_acf0
    
    bne     a0, a1, bne_target
    beq     zero, zero, end
    

# test JUMP and BRANCH

bne_target:
    addi    a3, zero, 0     # a3 = 0x0
    lw      s1, 0(zero)     # s1 = 0x1234_5678
    beq     a0, s1, end     
    addi    s1, a0, 2       # s1 = 0x2468_acf2
    bge     a2, zero, bge_target
    beq     zero, zero, lab4_2

bge_target:
    addi    a3, a3, 1       # a3 = 0x1
    sub     a1, zero, a0    # a1 = 0xdb97_5310
    bltu    a0, a1, bltu_target
    beq     zero, zero, lab4_2

bltu_target:
    addi    a3, a3, 1       # a3 = 0x2
    blt     a0, a1, blt_target
    beq     zero, zero, beq_target

blt_target:
    addi    a3, a3, 1
    beq     zero, zero, lab4_2
beq_target:
    addi    a3, a3, 1 # a3 = 0x3
    bgeu    a1, a3, bgeu_target
    beq     zero, zero, lab4_2
bgeu_target:
    addi    a3, a3, 1 # a3 = 0x4
# lab4-2 test
lab4_2:
    lui     t0, 0xf0000 # t0 = 0xf000_0000
    auipc   t1, 4       # t1 = 0x40b8
    jal x1, func
    beq zero, zero end
func:
    addi a3, a3, 1 # a3 = 0x5
    lui s11, 0xfe000
    sw a1, 0(s11) # 数码管的值显示为0xdb97_5310
    jalr x0, x1, 0
end:
    jalr x0, x0, 0 # 回到测试程序最开始
    nop
    nop
    nop

# machine code
# 00000013
# 00700513
# 00952593
# 00853613
# 00854693
# 00656713
# 00657793
# 00251813
# 00155593
# 40055893
# 00A504B3
# 40A80933
# 00D819B3
# 01352A33
# 00D54AB3
# 00C55B33
# 00E56BB3
# 00C57C33
# 017C3CB3
# 419BDD33
# 00002403
# 00141413
# 00802223
# 00402503
# 00B51463
# 06000863
# 00000693
# 00002483
# 06950263
# 00250493
# 00065463
# 02000C63
# 00168693
# 40A005B3
# 00B56463
# 02000463
# 00168693
# 00B54463
# 00000663
# 00168693
# 00000A63
# 00168693
# 00D5F463
# 00000463
# 00168693
# F00002B7
# 00004317
# 008000EF
# 00000A63
# 00168693
# FE000DB7
# 00BDA023
# 00008067
# 00000067
# 00000013
# 00000013
# 00000013

