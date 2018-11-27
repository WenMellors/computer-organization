`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:31:38 11/20/2018 
// Design Name: 
// Module Name:    IFU 
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
module IFU(
    input [31:0] nPC,
    input rst,
    input clk,
    input En,
    output [31:0] ins,
    output [31:0] PC4
    );

	reg [31:0] IM [1023:0]; // 32bits*1024
	reg [31:0] pc; // PC register

	initial begin
		pc = 32'h00003000;
		$readmemh("code.txt", IM);
	end

	assign PC4 = pc+4;
	assign ins = IM[pc[11:2]];
	always @(posedge clk) begin
		if (rst) begin
			pc <= 32'h00003000;
		end
		else if(En==1) begin
			pc <= nPC;
		end
		else pc <= pc;
	end
endmodule
