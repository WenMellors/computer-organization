`timescale 1ns / 1ps
`include "head.v"

module Conflict_Control(
	input [31:0] InsD,
	input [31:0] InsE,
	input [31:0] InsM,
	input RegWrite,
	input [4:0] RegtoWrite,
	output [2:0] ForwardrsD,
	output [2:0] ForwardrtD,
	output [1:0] ForwardrsE,
	output [1:0] ForwardrtE,
	output ForwardrtM,
	output stall
	);

	wire cal_rE, cal_iE, loadE, storeE, linkE, cal_rM, cal_iM, loadM, linkM, storeM;
	wire [1:0] Tuse_rs, Tuse_rt;

	assign Tuse_rs = (InsD[`op] == `beq || (InsD[`op] == `ROp && InsD[`funct] == `jr)) ? 0 : // branch and jr
						(InsD[`op] == `ROp && (InsD[`funct] == `addu || InsD[`funct] == `subu || InsD[`funct] == `sll)) ? 1 : // cal_r
						(InsD[`op] == `ori || InsD[`op] == `lui) ? 1: // cal_i
						(InsD[`op] == `lw || InsD[`op] == `sw) ? 1 : 2; // laod and store

	assign Tuse_rt = (InsD[`op] == `beq) ? 0:
						(InsD[`op] == `ROp && (InsD[`funct] == `addu || InsD[`funct] == `subu || InsD[`funct] == `sll)) ? 1: 2; // cal_r
	
	// EX
	assign cal_rE = (InsE[`op] == `ROp && (InsE[`funct] == `addu || InsE[`funct] == `subu || InsE[`funct] == `sll)) ? 1 : 0; // rd
	assign cal_iE = (InsE[`op] == `ori || InsE[`op] == `lui) ? 1 : 0; // rt
	assign loadE = (InsE[`op] == `lw) ? 1 : 0; // load_rt
	assign storeE = (InsE[`op] == `sw) ? 1 : 0; 
	assign linkE = (InsE[`op] == `jal) ? 1 : 0;// jal and jalr and bql
	// MEM
	assign cal_rM = (InsM[`op] == `ROp && (InsM[`funct] == `addu || InsM[`funct] == `subu || InsM[`funct] == `sll)) ? 1 : 0; // rd
	assign cal_iM = (InsM[`op] == `ori || InsM[`op] == `lui) ? 1 : 0; // rt
	assign loadM = (InsM[`op] == `lw) ? 1 : 0;
	assign linkM = (InsM[`op] == `jal) ? 1 : 0;// jal and jalr and bql
	assign storeM = (InsM[`op] == `sw) ? 1 : 0;
	// WB
	// assign cal_rW = (InsW[`op] == `ROp && (InsW[`funct] == `addu || InsW[`funct] == `subu || InsW[`funct] == `sll)) ? 1 : 0; // rd
	// assign cal_iW = (InsW[`op] == `ori || InsW[`op] == `lui) ? 1 : 0; // rt
	// assign loadW = (InsW[`op] == `lw) ? 1 : 0;
	// assign linkW = (InsW[`op] == jal) ? 1 : 0;// jal and jalr and bql
	// RegWrite is ok

	// when stall, the value is 
	assign stall = (Tuse_rs == 0 && InsD[`rs]!=0 && ((InsD[`rs] == InsE[`rt] && (cal_iE == 1 || loadE == 1))||(InsD[`rs] == InsE[`rd] && cal_rE == 1)||(InsD[`rs] == InsM[`rt] && loadM == 1))) ? 1: //beq, jr's rs
					(Tuse_rt == 0 && InsD[`rt]!=0 && ((InsD[`rt] == InsE[`rt] && (cal_iE == 1 || loadE == 1))||(InsD[`rt] == InsE[`rd] && cal_rE == 1)||(InsD[`rt] == InsM[`rt] && loadM == 1))) ? 1: // beq rt
					(Tuse_rs == 1 && InsD[`rs]!=0 &&(InsD[`rs] == InsE[`rt] && loadE == 1)) ? 1 : // cal,ld,st's rs
					(Tuse_rt == 1 && InsD[`rt]!=0 &&(InsD[`rt] == InsE[`rt] && loadE == 1)) ? 1 : 0; // cal_r `rt 
	
	// Mux_rs
	assign ForwardrsD = (linkE == 1 && InsD[`rs] == 31) ? 1 : // PC8E
						(InsD[`rs]!=0 && ((cal_iM == 1 && InsD[`rs] == InsM[`rt])||(cal_rM == 1 && InsD[`rs] == InsM[`rd]))) ? 2: // ALUOutM
						(linkM == 1 && InsD[`rs] == 31) ? 3 : // PC8M
						(InsD[`rs]!=0 && RegWrite == 1 && InsD[`rs] == RegtoWrite) ? 4 : 0; // DatatoReg
	
	assign ForwardrtD = (InsD[`rt]==31 && linkE == 1) ? 1 : // PC8E
						(InsD[`rt]!=0 && ((cal_rM == 1 && InsM[`rd] == InsD[`rt])||(cal_iM == 1 && InsM[`rt] == InsD[`rt]))) ? 2: // ALUOutM
						(linkM == 1 && InsD[`rt] == 31) ? 3 : // PC8M
						(InsD[`rt]!=0 && RegWrite == 1 && InsD[`rt] == RegtoWrite) ? 4 : 0; // PC8M
	
	assign ForwardrsE = (InsE[`rs]!=0 &&((InsE[`rs]==InsM[`rt]&&cal_iM==1)||(InsE[`rs]==InsM[`rd]&&cal_rM==1))) ? 1: // ALUOutM
						(InsE[`rs]==31 && linkM == 1) ? 2: // PC8M
						(InsE[`rs]!=0 && RegWrite == 1 && RegtoWrite == InsE[`rs]) ? 3 : 0; // DatatoReg
	
	assign ForwardrtE = (InsE[`rt]!=0&&((InsE[`rt]==InsM[`rt]&&cal_iM==1)||(InsE[`rt]==InsM[`rd]&&cal_rM==1))) ? 1: // ALUOutM
						(InsE[`rt]==31 && linkM == 1) ? 2: // PC8M
						(InsE[`rt]!=0 && RegWrite == 1 && RegtoWrite == InsE[`rt]) ? 3 : 0; // DatatoReg
	
	assign ForwardrtM = (InsM[`rt]!=0 && RegWrite == 1 && RegtoWrite == InsM[`rt]) ? 1 : 0; // DatatoReg

endmodule