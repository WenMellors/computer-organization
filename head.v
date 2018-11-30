// instruction_code
`define rs  25:21
`define rt  20:16 
`define rd  15:11 
`define op  31:26
`define funct 5:0
// instruction_type
// R_type OP
`define ROp 6'b000000
// R_type's funct
// cal_r
`define addu  6'b100001
`define subu 6'b100011
`define sll  6'b000000
// R_jump
`define jr   6'b001000
// cal_i
`define ori  6'b001101
`define lui  6'b001111
// store_load
`define lw   6'b100011 
`define sw   6'b101011
// branch
`define beq  6'b000100
// J_type
`define jal  6'b000011