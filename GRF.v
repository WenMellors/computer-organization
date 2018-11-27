`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:34:49 11/20/2018 
// Design Name: 
// Module Name:    GRF 
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

	assign Out1 = grf[Read1];
	assign Out2 = grf[Read2];

	always @(posedge clk) begin
		if(rst == 1) begin
			for(i=0;i<=31;i=i+1)
				grf[i] <= 32'h00000000;
		end
		else begin
			if(WE == 1 && Write1 != 0) begin // because $0 couldn't be written
				grf[Write1] <= Data;
				$display("@%h: $%d <= %h", WPC, Write1, Data);
			end
		end
	end
endmodule
