`timescale 1ns / 1ps

module EX_Control(
	input [5:0] op,
	input [5:0] funct,
	output ALUSrc1,
	output [1:0] ALUSrc2,
	output [2:0] ALUOp
	)
	
	parameter ROp = 6'b000000, ori = 6'b001101, lw = 6'b100011, sw = 6'b101011, beq = 6'b000100, lui = 6'b001111, jal = 6'b000011;
    parameter addu = 6'b100001, subu = 6'b100011, jr = 6'b001000, sll = 6'b000000;

    assign ALUSrc1 = (op == ROp && funct == sll) ? 1 : 0;
    assign ALUSrc2 = (op == lui || op == ori || op == lw || op == sw) ? 1 : (op == ROp && funct == sll) 2 : 0;
    assign ALUOp = (op == ori) ? 1: 
    				((op == ROp && funct == addu) || op == lw || op == sw || op == lui) ? 2 :
    				((op == ROp && funct == subu) || op == beq) ? 3 :
    				(op == sll) ? 4 : 0;
 	
 endmodule

module ALU(
    input [31:0] A,
    input [31:0] B,
    output [31:0] Result,
    input [2:0] ALUOp
    );
	
	integer r;
	initial begin
		r = 0;
	end

	assign Result = r;
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
	end
endmodule