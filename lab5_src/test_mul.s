nop
addi a0, x0, 0x4A
addi a1, x0, 0x15
mul  a2, a0, a1
sub  a0, x0, a0
mul  a2, a0, a1
sub  a1, x0, a1
mul  a2, a1, a0
addi a0, x0, 0x4A
mul  a2, a1, a0
jalr x0, x0, 0
nop
nop
nop

/*
00000013
04A00513
01500593
02B50633
40A00533
02B50633
40B005B3
02A58633
04A00513
02A58633
00000067
00000013
00000013
00000013
*/