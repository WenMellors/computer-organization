`timescale 1ns / 1ps
`include "head.v"
module ID_Control(
	input [5:0] op,
	input [5:0] funct,
	output branch,
	output [1:0] jump,
	output [1:0] ExtOp
	);

	assign branch = (op == `beq) ? 1 : 0;
    assign jump = (op == `jal) ? 1 : (op == `ROp && funct == `jr) ? 2 : 0;
    assign ExtOp = (op == `lui) ? 2 : (op == `ori) ? 1 : 0;

endmodule

module GRF(
    input [4:0] Read1,
    input [4:0] Read2,
    input [4:0] Write1,
    input [31:0] Data,
    input WE,
    input clk,
    input rst,
    input [31:0] WPC,
    output [31:0] Out1,
    output [31:0] Out2
    );

	reg [31:0] grf[31:0]; // 32 registers
	integer i;
	initial begin
		for(i=0;i<=31;i=i+1)
			grf[i] = 32'h00000000;
	end

	assign Out1 = (Read1 == Write1 && Read1 != 0) ? Data : grf[Read1];// GRF forward 
	assign Out2 = (Read2 == Write1 && Read2 != 0) ? Data : grf[Read2];

	always @(posedge clk) begin
		if(rst == 1) begin
			for(i=0;i<=31;i=i+1)
				grf[i] <= 32'h00000000;
		end
		else begin
			if(WE == 1 && Write1 != 0) begin // because $0 couldn't be written
				grf[Write1] <= Data;
				$display("%d@%h: $%d <= %h", $time, WPC, Write1, Data);
			end
		end
	end
endmodule

module EXT(
    input [15:0] imm,
    input [1:0] OP,
    output [31:0] Out
    );

	integer r;

	assign Out = r;
	always @(*) begin
		case(OP)
			0: begin
				r = $signed(imm);
			end
			1: begin
				r = imm;
			end
			2: begin
				r = {imm,16'h0000};
			end
		endcase
	end

endmodule

module NPC( // if(branch != 0 && Jump != 0, use NPC) --- Mux_PC
    input [31:0] PC4,
    input [25:0] imm,
    input [31:0] GRF_RD1,
    input branch,
    input [1:0]jump,
    input zero,
    output [31:0] nPC
    );

	wire [31:0] pc;
	assign pc = PC4 - 4;
	assign nPC = (branch == 1&& zero ==1) ? (PC4 + $signed({imm[15:0],2'b00})) : // if(branch == 1&&zero == 1)
				  	(jump == 1) ? {pc[31:28],imm,2'b00} : // else if(jump == 1)
				  	(jump == 2) ? GRF_RD1 : PC4 + 4; // else if(jump == 2)

endmodule

