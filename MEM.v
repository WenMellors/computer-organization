`timescale 1ns / 1ps
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
    input [31:0] pc,
    output [31:0] Out
    );
	
	reg [7:0] RAM[4095:0]; // 8bits * 4096, by byte
	integer i;
	initial begin
		for(i=0;i<4096;i=i+1)
			RAM[i] = 0;
	end
	
	assign Out = {RAM[Address[11:0]+3],RAM[Address[11:0]+2],RAM[Address[11:0]+1],RAM[Address[11:0]]}; // now we just support read word
	always @(posedge clk) begin
		if(rst == 1) begin
			for(i=0;i<4096;i=i+1)
				RAM[i] <= 0;
		end
		else if(WE == 1) begin
			{RAM[Address[11:0]+3],RAM[Address[11:0]+2],RAM[Address[11:0]+1],RAM[Address[11:0]]} <= Data; // just support sw
			$display("%d@%h: *%h <= %h", $time, pc, Address, Data);
		end
	end
	
endmodule

module MEM_Control(
	input [5:0] op,
	input [5:0] funct,
	output Memwrite,
	)

	parameter ROp = 6'b000000, ori = 6'b001101, lw = 6'b100011, sw = 6'b101011, beq = 6'b000100, lui = 6'b001111, jal = 6'b000011;
    parameter addu = 6'b100001, subu = 6'b100011, jr = 6'b001000, sll = 6'b000000;

    assign Memwrite = (op == sw) ? 1 : 0;
endmodule