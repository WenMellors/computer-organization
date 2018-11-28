`timescale 1ns / 1ps
`define rs = 25:21, rt = 20:16, rd = 15:11, op = 31:26, funct = 5:0;

module Conflict_Control(
	input branch,
	input jr,
	input [31:0] InsD,
	input [31:0] InsE,
	input [31:0] InsM,
	input [31:0] InsW,
	output [2:0] ForwardRsD,
	output [2:0] ForwardRtD,
	output [1:0] ForwardRsE,
	output [1:0] ForwardRtE,
	output ForwardRtM,
	output stall
	)
	
	wire cal_rE, cal_iE, loadE, loadM, cal_r, cal_i, load, store;
	parameter ROp = 6'b000000, ori = 6'b001101, lw = 6'b100011, sw = 6'b101011, beq = 6'b000100, lui = 6'b001111, jal = 6'b000011;
    parameter addu = 6'b100001, subu = 6'b100011, jr = 6'b001000, sll = 6'b000000;

	assign cal_r = (InsD[op] == ROp && (InsD[funct] == addu || InsD[funct] == subu || InsD[funct] == sll)) ? 1 : 0;
	assign cal_i = (InsD[op] == ori || InsD[op] == lui) ? 1 : 0; 
	assign load = (InsD[op] == lw) ? 1 : 0;
	assign store = (InsD[op] == sw) ? 1 : 0;
	// EX
	assign cal_rE = (InsE[op] == ROp && (InsE[funct] == addu || InsE[funct] == subu || InsE[funct] == sll)) ? 1 : 0; // rd
	assign cal_iE = (InsE[op] == ori || InsE[op] == lui) ? 1 : 0; // rt
	assign loadE = (InsE[op] == lw) ? 1 : 0; // load_rt
	assign jalE = (InsE[op] == jal) ? 1 : 0;
	assign storeE = (InsE[op] == sw) ? 1 : 0; 
	// MEM
	assign cal_rM = (InsM[op] == ROp && (InsM[funct] == addu || InsM[funct] == subu || InsM[funct] == sll)) ? 1 : 0; // rd
	assign cal_iM = (InsM[op] == ori || InsM[op] == lui) ? 1 : 0; // rt
	assign loadM = (InsM[op] == lw) ? 1 : 0;
	assign jalM = (InsM[op] == jal) ? 1 : 0;
	assign storeM = (InsM[op] == sw) ? 1 : 0;
	// WB
	assign cal_rW = (InsW[op] == ROp && (InsW[funct] == addu || InsW[funct] == subu || InsW[funct] == sll)) ? 1 : 0; // rd
	assign cal_iW = (InsW[op] == ori || InsW[op] == lui) ? 1 : 0; // rt
	assign loadW = (InsW[op] == lw) ? 1 : 0;
	assign jalW = (InsW[op] == jal) ? 1 : 0;
	// when stall, the value is 
	assign stall = ((branch == 1 || jr == 1) && InsD[rs]!=0 && ((InsD[rs] == InsE[rt] && (cal_iE == 1 || loadE == 1))||(InsD[rs] == InsE[rd] && cal_rE == 1)||(InsD[rs] == InsM[rt] && loadM))) ? 1: //beq, jr's rs
					(branch == 1 && InsD[rt]!=0 && ((InsD[rt] == InsE[rt] && (cal_iE == 1 || loadE == 1))||(InsD[rt] == InsE[rd] && cal_rE == 1)||(InsD[rt] == InsM[rt] && loadM))) ? 1: // beq rt
					((cal_r == 1||cal_i == 1||load == 1||store == 1) && InsD[rs]!=0 &&(InsD[rs] == InsE[rt] && loadE == 1)) ? 1 : // cal,ld,st's rs
					(cal_r == 1 && InsD[rt]!=0 &&(InsD[rt] == InsE[rt] && loadE == 1)) ? 1 : 0; // cal_r rt 
	// Mux_rsD
	assign ForwardRsD = ((branch == 1||jr == 1) && InsD[rs]!=0 &&((cal_rM == 1 && InsM[rd] == InsD[rs])||(cal_iM == 1 && InsM[rt] == InsD[rs]))) ? 1 : // rs ALUOutM
						((branch == 1||jr == 1) && InsD[rs]!=0 &&((InsD[rs] == InsW[rd] && cal_rW == 1)||(cal_iW == 1||loadW == 1)&&InsD[rs]==InsW[rt]||jalW == 1&&InsD[rs]==31)) ? 2: // rs W forward
						(jalE == 1 && InsD[rs] == 31) ? 3 : // PC8E
						(jalM == 1 && InsD[rs] == 31) ? 4 : 0; // PC8M
	assign ForwardRtD = ((branch == 1||jr == 1) && InsD[rt]!=0 &&((cal_rM == 1 && InsM[rd] == InsD[rt])||(cal_iM == 1 && InsM[rt] == InsD[rt]))) ? 1 : // rs ALUOutM
						((branch == 1||jr == 1) && InsD[rt]!=0 &&((InsD[rt] == InsW[rd] && cal_rW == 1)||(cal_iW == 1||loadW == 1)&&InsD[rt]==InsW[rt]||jalW == 1&&InsD[rt]==31)) ? 2: // rs W forward
						(jalE == 1 && InsD[rt] == 31) ? 3 : // PC8E
						(jalM == 1 && InsD[rt] == 31) ? 4 : 0; // PC8M
	assign ForwardRsE = ((cal_rE == 1||cal_iE == 1||loadE == 1||storeE == 1)&&InsE[rs]!=0&&(InsE[rs]==InsM[rt]&&cal_iM==1||InsE[rs]==InsM[rd]&&cal_rM==1)) ? 1: // MEM ALUOut
						((cal_rE == 1||cal_iE == 1||loadE == 1||storeE == 1)&&InsE[rs]!=0&&(InsE[rs]==InsW[rt]&&(cal_iW==1||loadW==1)||InsE[rs]==InsW[rd]&&cal_rW==1||InsE[rs]==31&&jalW==1)) ? 2: // WB DatatoReg
						((cal_rE == 1||cal_iE == 1||loadE == 1||storeE == 1)&&InsE[rs]!=0&&InsE[rs] == 31 &&jalM == 1) ? 3 : 0; // MEM PC8M
	assign ForwardRtE = ((cal_rE == 1||cal_iE == 1)&&InsE[rt]!=0&&(InsE[rt]==InsM[rt]&&cal_iM==1||InsE[rt]==InsM[rd]&&cal_rM==1)) ? 1: // MEM ALUOut
						((cal_rE == 1||cal_iE == 1)&&InsE[rt]!=0&&(InsE[rt]==InsW[rt]&&(cal_iW==1||loadW==1)||InsE[rt]==InsW[rd]&&cal_rW==1||InsE[rt]==31&&jalW==1)) ? 2: // WB DatatoReg
						((cal_rE == 1||cal_iE == 1)&&InsE[rt]!=0&&InsE[rt] == 31 &&jalM == 1) ? 3 : 0; // MEM PC8M
	assign ForwardRtM = (storeM == 1 && InsM[rt]!=0 &&(InsM[rt]==InsW[rt]&&(cal_iW==1||loadW==1)||InsM[rt]==InsW[rd]&&cal_rW==1||InsM[rt]==31&&jalW==1)) ? 1 : 0;

endmodule