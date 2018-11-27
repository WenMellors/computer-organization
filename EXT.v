`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:45:23 11/20/2018 
// Design Name: 
// Module Name:    EXT 
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
