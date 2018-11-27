`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:29:42 11/20/2018 
// Design Name: 
// Module Name:    Control 
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
module Control(
    input [5:0] op,
    input [5:0] funct,
    output Regwrite,
    output [2:0] ALUOp,
    output Memwrite,
    output [1:0] EXTOp,
    output [1:0] RegDst,
    output ALUSrc1,
    output [1:0] ALUSrc2,
    output [1:0] MemtoReg,
    output Branch,
    output [1:0]Jump
    );

    parameter ROp = 6'b000000, ori = 6'b001101, lw = 6'b100011, sw = 6'b101011, beq = 6'b000100, lui = 6'b001111, jal = 6'b000011;
    parameter addu = 6'b100001, subu = 6'b100011, jr = 6'b001000, sll = 6'b000000;

    reg [16:0] result;

    assign {Regwrite, ALUOp, Memwrite, EXTOp, RegDst, ALUSrc1, ALUSrc2, MemtoReg, Branch, Jump} = result;

    always @(*) begin
        case(op)
            ROp: begin
                case(funct)
                    addu: result =  17'b10100000100000000;
                    subu: result =  17'b10110000100000000;
                    jr: result = 17'b00000001000010010;
                    sll: result = 17'b11000000111000000;
                endcase
            end
            ori: result = 17'b10010010000100000;
            lw: result = 17'b10100000000101000;
            sw: result = 17'b00101000000100000;
            beq: result = 17'b00110000000000100;
            lui: result = 17'b10100100000100000;
            jal: result = 17'b10000001000010001;
        endcase    
    end

endmodule
