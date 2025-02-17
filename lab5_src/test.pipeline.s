    add x0, x0, x0
    addi a0, x0, 7  # a0 = 0x00000007
    addi a1, a0, -6  # a1 = 0x00000001
    slli a2, a1, 2  # a2 = 0x00000004 这里会有rs1的数据竞争
    slt  a3, a1, a2 # a3 = 0x00000001 这里会有rs2的数据竞争
    lw   a4, 0(x0)  # a4 = 0x12345678
    add  a5, a4, a3 # a5 = 0x12345679 这里会有load和rs1的竞争，会stall一拍。
    nop
    sub  a6, a5, a4 # a6 = 0x00000001 这里会有隔代数据竞争
    lui  a7, 0xfe000# a7 = 0xfe000000
    or   s0, a7, a6 # s0 = 0xfe000001 这里会有关于imm的forwarding
    sw   s0, 0(a7)  # 七段数码管显示 fe000001，测试rs2的forwarding.
    addi t1, x0, 1  # t1 = 0x00000001
    addi t1, t1, 1  # t1 = 0x00000002
    addi t0, t1, 1  # t0 = 0x00000003 在forwarding时选择最新的数据进行forwarding。
    addi a3, x0, 0  # a3 = 0x00000000 清空a3的值准备作为跳转的计数
    beq  x0, x0, beq_target
    lui  a3, 0xff000
    addi  a3, a3, 1   # 这个时候a3的值不能被修改，测试流水线是否被flush
beq_target:
    addi a3, a3, 1 # a3 = 0x00000001 测试a3是否正确
    bne x0, x0, else
    addi a3, a3, 1 # a3 = 0x00000002 此时predict not_taken
    nop
else:
    jal ra, func
    addi t1, x0, 4 # t1 = 0x00000004
    lw t0, 0(x0) # t0 = 0x12345678
    sw t0, 0(t1) # 此处发生load store forwarding
    lw t1, 0(t1) # t1 = 0x12345678
    jal x0, end
func:
    addi a3, a3, 1 # a3 = 0x00000003 调用函数
    jalr x0, ra, 0 #返回函数
end:
    jalr x0, x0, 0 # 回到测试程序最开始
    nop
    nop
    nop

/*
00000033
00700513
FFA50593
00259613
00C5A6B3
00002703
00D707B3
00000013
40E78833
FE0008B7
0108E433
0088A023
00100313
00130313
00130293
00000693
00000663
FF0006B7
00168693
00168693
00001663
00168693
00000013
018000EF
00400313
00002283
00532023
00032303
00C0006F
00168693
00008067
00000067
00000013
00000013
00000013
*/