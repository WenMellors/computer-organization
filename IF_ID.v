`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:35:09 11/27/2018 
// Design Name: 
// Module Name:    IF_ID 
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
module IF_ID(
    input [31:0] PC4_in,
    input [31:0] InsD_in,
    input rst,
    input En,
    input clk,
    output [31:0] PC4D,
    output [31:0] InsD
    );

	reg [31:0] pc4, Ins;

	assign PC4D = pc4;
	assign InsD = Ins;

	always @(posedge clk) begin
		if(rst == 1) begin
			pc4 <= 32'h00003000;
			Ins <= 0; 
		end
		else if(En == 1) begin
			pc4 <= PC4_in;
			Ins <= InsD_in;
		end
		else begin
			pc4 <= pc4;
			Ins <= Ins;
		end
	end
	
endmodule
