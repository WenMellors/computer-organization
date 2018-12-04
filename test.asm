# beq and cal_r
addu $t1, $t1, $t2
beq $t1, $0, lable1
# beq and cal_i
ori $t1, $0, 25
beq $t1, $t2, lable2
# beq and load_EX
lw $t1, 0($0)
beq $t1, $0, lable3
# beq and load_MEM
lw $t1, 0($0)
ori $t3, 11
beq $t1, $t2, lable4
#cal_r and load
lw $t1, 0($0)
addu $t2, $t1, $t2
# cal_i and load
lw $t2, 0($0)
ori $t1, $t2, 34
# load and load
lw $t1, 0($0)
lw $t2, 0($t1)
# store and load
lw $t1, 0($0)
sw $t2, 0($t1)
# jr and cal_r
addu $t1, $t1, $ra
jr $t1
# jr and cal_i
ori $t1, $0, 0x3008
jr $t1
# jr and load_EX
lw $t1, 0($0)
jr $t1
# jr and load_MEM
lw $t1, 0($0)
addu $t2, $t3, $t2
jr $t1
# beq and cal_r
addu $t1, $t2, $t3
ori $t3, $t2, 10
beq $t1, $0, lable5
# beq and cal_i
ori $t3, $0, 100
lui $t1, 100
ori $t2, $0, 11
beq $t1, $t3, lable6
# beq and jal
jal lable6
addu $t1, $t2, $t2
lable6:
beq $ra, $t1, lable7
# cal_r_ID and cal_r_EX and cal_r_MEM
add $t1, $t2, $t3
add $t2, $t3, $t4
add $t3, $t1, $t2
# cal_r_ID and cal_i_EX and cal_i_MEM
ori $t1, $0, 20
ori $t2, $0, 15
add $t3, $t2, $t1
# jr and cal_r
addu $t1, $ra, $t2
subu $t2, $t2, $t3
jr $t1
# jr and cal_i
ori $t1, 0x3008
addu $t2, $t2, $t3
jr $t1
# jr and jal
jal lable8
addu $t1, $t2, $t1
lable8:
jr $ra
# 