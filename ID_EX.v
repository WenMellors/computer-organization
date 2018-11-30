`timescale 1ns / 1ps

module ID_EX(
	input [31:0] RD1D,
	input [31:0] RD2D,
	input [31:0] EXTD,
	input [31:0] PC8D,
	input [31:0] InsD,
	input clk,
	input rst,
	output [31:0] RD1E,
	output [31:0] RD2E,
	output [31:0] EXTE,
	output [31:0] PC8E,
	output [31:0] InsE
	);

	reg [31:0] RD1, RD2, EXT, PC8, Ins;

	initial begin
		RD1 = 0;
		RD2 = 0;
		EXT = 0;
		PC8 = 32'h3000;
		Ins = 0;
	end
	assign {RD1E, RD2E, EXTE, PC8E, InsE} = {RD1, RD2, EXT, PC8, Ins};

	always @(posedge clk) begin
		if(rst == 1) begin
			RD1 <= 0;
			RD2 <= 0;
			EXT <= 0;
			PC8 <= 32'h00003000;
			Ins <= 0;
		end
		else begin
			RD1 <= RD1D;
			RD2 <= RD2D;
			EXT <= EXTD;
			PC8 <= PC8D;
			Ins <= InsD;
		end
	end  
	
endmodule