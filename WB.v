`timescale 1ns / 1ps
`include "head.v"
module WB_Control(
	input [5:0] op,
	input [5:0] funct,
	output RegWrite,
	output [1:0] MemtoReg,
	output [1:0] RegDst,
	output [2:0] DM_EXTOp
	);
	
	assign RegWrite = ((op == `ROp && (funct == `addu || funct == `subu || funct == `sll)) || op == `lui || op == `lw || op == `lb || op == `ori || op == `jal) ? 1 : 0;
	assign MemtoReg = (op == `lw || op == `lb) ? 1: 
						(op == `jal) ? 2 : 0;
	assign RegDst = (op == `ROp && (funct == `addu || funct == `subu || funct == `sll)) ? 1 : (op == `jal) ? 2 : 0;
	assign DM_EXTOp = (op == `lw) ? 0 : 1;

endmodule

module DM_EXT(
	input [31:0] ReadDataW,
	input [2:0] DM_EXTOp,
	output [31:0] ReadDataW_EXT
	);
	
	reg [31:0] a;
	
	initial begin
		a = 0;
	end
	
	assign ReadDataW_EXT = a;
	always @(*) begin
		case(DM_EXTOp)
			0: a = ReadDataW;
			1: a = $signed(ReadDataW[7:0]);
		endcase
	end

endmodule