`timescale 1ns / 1ps

module EX_MEM(
	input [31:0] ALUOut,
	input [31:0] WriteData,
	input [31:0] PC8,
	input [31:0] Ins,
	input clk,
	input rst,
	output [31:0] ALUOutM,
	output [31:0] WriteDataM,
	output [31:0] PC8M,
	output [31:0] InsM
	)

	reg [31:0] a, b, c, d;

	assign {ALUOutM, WriteDataM, PC8M, InsM} = {a, b, c, d};

	always @(posedge clk) begin
		if(rst == 1) begin
			a <= 0;
			b <= 0;
			c <= 32'h00003000;
			d <= 0;
		end
		else begin
			a <= ALUOut;
			b <= WriteData;
			c <= PC8;
			d <= Ins;
		end
	end
	
endmodule