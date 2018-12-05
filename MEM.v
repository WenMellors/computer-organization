`timescale 1ns / 1ps
`include "head.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:33:35 11/20/2018 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input [31:0] Address,
    input [31:0] Data,
    input WE,
    input rst,
    input clk,
    input [1:0] DMtype,
    input [31:0] pc,
    output [31:0] Out
    );
	
	reg [7:0] RAM[4095:0]; // 8bits * 4096, by byte
	integer i;
	reg [31:0] din;
	initial begin
		for(i=0;i<4096;i=i+1)
			RAM[i] = 0;
		din = 0;
	end
	
	assign Out = (DMtype == 0) ? {RAM[Address[11:0]+3],RAM[Address[11:0]+2],RAM[Address[11:0]+1],RAM[Address[11:0]]} : 
					RAM[Address[11:0]]; // now we just support read word and byte
	always @(posedge clk) begin
		if(rst == 1) begin
			for(i=0;i<4096;i=i+1)
				RAM[i] = 0;
		end
		else if(WE == 1) begin
			if(DMtype == 0) begin
				{RAM[Address[11:0]+3],RAM[Address[11:0]+2],RAM[Address[11:0]+1],RAM[Address[11:0]]} <= Data; // just support sw
				$display("%d@%h: *%h <= %h", $time, pc, Address, Data);
			end
			else if(DMtype == 1) begin
				RAM[Address[11:0]] <= Data[7:0];
				case(Address[1:0])
					0: din = {RAM[Address[11:0]+3], RAM[Address[11:0]+2], RAM[Address[11:0]+1], Data[7:0]};
					1: din = {RAM[Address[11:0]+2], RAM[Address[11:0]+1], Data[7:0], RAM[Address[11:0]-1]};
					2: din = {RAM[Address[11:0]+1], Data[7:0], RAM[Address[11:0]-1], RAM[Address[11:0]-2]};
					3: din = {Data[7:0], RAM[Address[11:0]-1], RAM[Address[11:0]-2], RAM[Address[11:0]-3]};
				endcase
				$display("%d@%h: *%h <= %h", $time, pc, Address[31:2]*4, din);
			end
		end
	end
	
endmodule

module MEM_Control(
	input [5:0] op,
	input [5:0] funct,
	output MemWrite,
	output [1:0] DMtype
	);
	
   assign MemWrite = (op == `sw || op == `sb) ? 1 : 0;
   assign DMtype = (op == `sw || op == `lw) ? 0 : 1; // 0: by word, 1: by byte
endmodule