`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:06:04 11/20/2018 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] A,
    input [31:0] B,
    output [31:0] Result,
    output zero,
    input [2:0] ALUOp
    );
	
	integer r,z;
	initial begin
		r = 0;
		z = 0;
	end

	assign Result = r;
	assign zero = z;
	always @(*) begin
		case(ALUOp)
			0: begin
				r = A&B;
			end
			1: begin
				r = A|B;
			end
			2: begin
				r = A+B;
			end
			3: begin
				r = A-B;
			end
			4: begin
				r = A << B;
			end
		endcase
		if(r == 0) z = 1;
		else z = 0;
	end
endmodule
