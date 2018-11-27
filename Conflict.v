`timescale 1ns / 1ps
`define rs = 25:21, rt = 20:16, rd = 15:11, op = 31:26, funct = 5:0;

module Conflict_Control(
	input branch,
	input jr,
	input [31:0] InsD,
	input [31:0] InsE,
	input [31:0] InsM,
	input [31:0] InsW,
	output [1:0] ForwardRsD,
	output [1:0] ForwardRtD,
	output [1:0] ForwardRsE,
	output [1:0] ForwardRtE,
	output [1:0] ForwardRtM,
	output stall
	)
	
	wire cal_rE, cal_iE, loadE, loadM, cal_r, cal_i, load, store;
	parameter ROp = 6'b000000, ori = 6'b001101, lw = 6'b100011, sw = 6'b101011, beq = 6'b000100, lui = 6'b001111, jal = 6'b000011;
    parameter addu = 6'b100001, subu = 6'b100011, jr = 6'b001000, sll = 6'b000000;

	assign cal_r = (InsD[op] == ROp && (InsD[funct] == addu || InsD[funct] == subu || InsD[funct] == sll)) ? 1 : 0;
	assign cal_i = (InsD[op] == ori || InsD[op] == lui) ? 1 : 0; 
	assign load = (InsD[op] == lw) ? 1 : 0;
	assign store = (InsD[op] == sw) ? 1 : 0;
	assign cal_rE = (InsE[op] == ROp && (InsE[funct] == addu || InsE[funct] == subu || InsE[funct] == sll)) ? 1 : 0; // rd
	assign cal_iE = (InsE[op] == ori || InsE[op] == lui) ? 1 : 0; // rt
	assign loadE = (InsE[op] == lw) ? 1 : 0; // load_rt
	assign cal_rM = (InsM[op] == ROp && (InsM[funct] == addu || InsM[funct] == subu || InsM[funct] == sll)) ? 1 : 0; // rd
	assign cal_iM = (InsM[op] == ori || InsM[op] == lui) ? 1 : 0; // rt
	assign loadM = (InsM[op] == lw) ? 1 : 0;
	assign cal_rW = (InsW[op] == ROp && (InsW[funct] == addu || InsW[funct] == subu || InsW[funct] == sll)) ? 1 : 0; // rd
	assign cal_iW = (InsW[op] == ori || InsW[op] == lui) ? 1 : 0; // rt
	assign loadW = (InsW[op] == lw) ? 1 : 0;
	// when stall, the value is 
	assign stall = ((branch == 1 || jr == 1) && InsD[rs]!=0 && ((InsD[rs] == InsE[rt] && (cal_iE == 1 || loadE == 1))||(InsD[rs] == InsE[rd] && cal_rE == 1)||(InsD[rs] == InsM[rt] && loadM))) ? 1: //beq, jr's rs
					(branch == 1 && InsD[rt]!=0 && ((InsD[rt] == InsE[rt] && (cal_iE == 1 || loadE == 1))||(InsD[rt] == InsE[rd] && cal_rE == 1)||(InsD[rt] == InsM[rt] && loadM))) ? 1: // beq rt
					((cal_r == 1||cal_i == 1||load == 1||store == 1) && InsD[rs]!=0 &&(InsD[rs] == InsE[rt] && loadE == 1)) ? 1 : // cal,ld,st's rs
					(cal_r == 1 && InsD[rt]!=0 &&(InsD[rt] == InsE[rt] && loadE == 1)) ? 1 : 0; // cal_r rt 
	// Mux_rsD
	assign ForwardRsD = ((branch == 1||jr == 1) && InsD[rs]!=0 &&((cal_rM == 1 && InsM[rd] == InsD[rs])||(cal_iM == 1 && InsM[rt] == InsD[rs]))) ? 1 :
						((branch == 1||jr == 1) && InsD[rs]!=0 &&(()));
endmodule