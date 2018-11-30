`timescale 1ns / 1ps
`include "head.v"
module WB_Control(
	input [5:0] op,
	input [5:0] funct,
	output RegWrite,
	output [1:0] MemtoReg,
	output [1:0] RegDst
	);
	
	assign RegWrite = ((op == `ROp && (funct == `addu || funct == `subu || funct == `sll)) || op == `lui || op == `lw || op == `ori || op == `jal) ? 1 : 0;
	assign MemtoReg = (op == `lw) ? 1: 
						(op == `jal) ? 2 : 0;
	assign RegDst = (op == `ROp && (funct == `addu || funct == `subu || funct == `sll)) ? 1 : (op == `jal) ? 2 : 0;
	
endmodule