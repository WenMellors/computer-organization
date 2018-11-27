`timescale 1ns / 1ps

module WB_Control(
	input [5:0] op,
	input [5:0] funct,
	output RegWrite,
	output [1:0] MemtoReg,
	output [1:0] RegDst
	)

	parameter ROp = 6'b000000, ori = 6'b001101, lw = 6'b100011, sw = 6'b101011, beq = 6'b000100, lui = 6'b001111, jal = 6'b000011;
    parameter addu = 6'b100001, subu = 6'b100011, jr = 6'b001000, sll = 6'b000000;
	
	assign RegWrite = ((op == ROp && (funct == addu || funct == subu || funct == sll)) || op == lui || op == lw || op == ori || op == jal) ? 1 : 0;
	assign MemtoReg = (op == lw) ? 1: 
						(op == jal) ? 2 : 0;
	assign RegDst = (op == ROp && (funct == addu || funct == subu || funct == sll)) ? 1 : (op == jal) ? 2 : 0;
	
endmodule