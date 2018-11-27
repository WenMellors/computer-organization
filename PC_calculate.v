`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:45:16 11/20/2018 
// Design Name: 
// Module Name:    NPC 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module NPC(
    input [31:0] PC,
    input [31:0] imm,
    input [25:0] instr_index,
    input [31:0] ReadOut1,
    input branch,
    input [1:0]jump,
    input zero,
    output [31:0] nPC
    );

	integer result;

	assign nPC = result;
	always @(*) begin
		if(branch == 1 && zero == 1) begin
			result = PC + 4 + {imm[29:0],2'b00};
		end
		else if(jump == 1) begin
			result = {PC[31:28],instr_index,2'b00};
		end
		else if(jump == 2) result = ReadOut1;
		else begin 
			result = PC + 4;
		end
	end
endmodule
