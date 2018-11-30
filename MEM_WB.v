`timescale 1ns / 1ps
module MEM_WB(
	input [31:0] DMOut,
	input [31:0] ALUOutM,
	input [31:0] PC8M,
	input [31:0] InsM,
	input clk,
	input rst,
	output [31:0] ReadDataW,
	output [31:0] ALUOutW,
	output [31:0] PC8W,
	output [31:0] InsW
	);

	reg [31:0] a, b, c, d;

	initial begin
		a = 0;
		b = 0;
		c = 32'h3000;
		d = 0;
	end
	assign {ReadDataW, ALUOutW, PC8W, InsW} = {a, b, c, d};

	always @(posedge clk) begin
		if(rst == 1) begin
			a <= 0;
			b <= 0;
			c <= 32'h00003000;
			d <= 0;
		end
		else begin
			a <= DMOut;
			b <= ALUOutM;
			c <= PC8M;
			d <= InsM;
		end
	end
endmodule