`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:23:35 11/21/2018 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );

	wire [31:0] npc, InsF, PC4F, PC4D, InsD, DatatoReg, WPC, RD1, RD2, EXTD, Mux_rsD, Mux_rtD, PC8D, RD1E, RD2E, EXTE, PC8E, InsE, Mux_PC;
	wire [31:0] Mux_ALUSrc1, Mux_ALUSrc2, ALUOut, ALUOutM, WriteDataM, PC8M, InsM, Mux_rsE, Mux_rtE, Mux_rtM, pc, ReadData, ReadDataW, ALUOutW, PC8W, InsW;
	wire [1:0] jump, ExtOp, ALUSrc2, MemtoReg, RegDst, ForwardRsE, ForwardRtE;
	wire stallPC, rstID_EX, stallD, branch, RegWrite, zero, ALUSrc1, Memwrite, ForwardRtM, stall;
	wire [4:0] RegtoWrite;
	wire [2:0] ALUOp, ForwardRsD, ForwardRtD;

	IFU a1(.nPC(Mux_PC), .rst(reset), .clk(clk), .En(stallPC), .ins(InsF), .PC4(PC4F));
	IF_ID a2(.PC4_in(PC4F), .InsD_in(InsF), .rst(reset), .En(stallD), .clk(clk), .PC4D(PC4D), .InsD(InsD));
	ID_Control a3(.op(InsD[op]), .funct(InsD[funct]), .branch(branch), .jump(jump), .ExtOp(ExtOp));
	GRF a4(.Read1(InsD[rs]), .Read2(InsD[rt]), .Write1(RegtoWrite), .Data(DatatoReg), .WE(RegWrite), .clk(clk), .rst(reset), .WPC(WPC), .Out1(RD1), .Out2(RD2));
	EXT a5(.imm(InsD[15:0]), .OP(ExtOp), .Out(EXTD));
	NPC a6(.PC4(PC4D), .imm(InsD[25:0]), .GRF_RD1(Mux_rsD), .branch(branch), .jump(jump), .zero(zero), .nPC(npc)); // RsD forward
	ID_EX a7(.RD1D(Mux_rsD), .RD2D(Mux_rtD), .EXTD(EXTD), .PC8D(PC8D), .InsD(InsD), .clk(clk), .rst(rstID_EX), .RD1E(RD1E), .RD2E(RD2E), .EXTE(EXTE), .PC8E(PC8E), .InsE(InsE));
	EX_Control a8(.op(InsE[op]), .funct(InsE[funct]), .ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .ALUOp(ALUOp));
	ALU a9(.A(Mux_ALUSrc1), .B(Mux_ALUSrc2), .ALUOp(ALUOp), .Result(ALUOut));
	EX_MEM a10(.ALUOut(ALUOut), .WriteData(Mux_rtE), .PC8(PC8E), .Ins(InsE), .clk(clk), .rst(reset), .ALUOutM(ALUOutM), .WriteData(WriteDataM), .PC8M(PC8M), .InsM(InsM));
	MEM_Control a11(.op(InsM[op]), .funct(InsM[op]), .Memwrite(Memwrite));
	DM a12(.Address(ALUOutM), .Data(Mux_rtM), .WE(Memwrite), .rst(reset), .clk(clk), .pc(pc), .Out(ReadData));
	MEM_WB a13(.DMOut(ReadData), .ALUOutM(ALUOutM), .PC8M(PC8M), .InsM(InsM), .clk(clk), .rst(reset), .ReadDataW(ReadDataW), .ALUOutW(ALUOutW), .PC8W(PC8W), .InsW(InsW));
	WB_Control a14(.op(InsW[op]), .funct(InsW[funct]), .RegWrite(RegWrite), .MemtoReg(MemtoReg), .RegDst(RegDst));
	Conflict_Control a15(.branch(branch), .jr(jump[1:1]), .InsD(InsD), .InsE(InsE), .InsM(InsM), .InsW(INsW), .ForwardRsD(ForwardRsD), .ForwardRtD(ForwardRtD), .ForwardRsE(ForwardRsE), .ForwardRtE(ForwardRtE), .ForwardRtM(ForwardRtM), .stall(stall));

	// WB 
	assign WPC = PC8W - 8;
	// ID
	assign zero = (Mux_rsD == Mux_rtD) ? 1 : 0;
	assign PC8D = PC4D + 4;
	// Mux_PC
	assign Mux_PC = (branch == 1||jump != 0) ? npc : PC4F;
	// Mux_ALUSrc1
	assign Mux_ALUSrc1 = (ALUSrc1 == 1) ? Mux_rtE : Mux_rsE;
	// Mux_ALUSrc2
	assign Mux_ALUSrc2 = (ALUSrc2 == 0) ? Mux_rtE :
							(ALUSrc2 == 1) ? EXTE : InsE[10:6];
	// Mux_RegtoWrite
	assign RegtoWrite = (RegDst == 0) ? InsW[rt]:
							(RegDst == 1) ? InsW[rd]:
								(RegDst == 2) ? 31;
	// Mux_DatatoReg
	assign DatatoReg = (MemtoReg == 0) ? ALUOutW : 
						(MemtoReg == 1) ? ReadDataW : PC8W;
	// Mux_rsD
	assign Mux_rsD = (ForwardRsD == 0) ? RD1 :
						(ForwardRsD == 1) ? ALUOutM :
						(ForwardRsD == 2) ? DatatoReg:
						(ForwardRsD == 3) ? PC8E : PC8M;
	// Mux_rtD
	assign Mux_rtD = (ForwardRtD == 0) ? RD2:
						(ForwardRtD == 1) ? ALUOutM :
						(ForwardRtD == 2) ? DatatoReg:
						(ForwardRtD == 3) ? PC8E : PC8M;
	// Mux_rsE
	assign Mux_rsE = (ForwardRsE == 0) ? RD1E:
						(ForwardRsE == 1) ? ALUOutM:
						(ForwardRsE == 2) ? DatatoReg: PC8M;
	// Mux_rtE
	assign Mux_rtE = (ForwardRtE == 0) ? RD2E:
						(ForwardRtE == 1) ? ALUOutM:
						(ForwardRtE == 2) ? DatatoReg: PC8M;
	// Mux_rtM
	assign Mux_rtM = (ForwardRtM == 0) ? WriteDataM : DatatoReg;
	// stall
	assign stallPC = ~stall;
	assign stallD = ~stall;
	assign  rstID_EX = stall|reset;
endmodule
