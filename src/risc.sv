`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2025 12:46:56
// Design Name: 
// Module Name: risc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module risc(clk, reset, reset_mem);
    
    input clk;
    input reset, reset_mem;
    
    logic [7:0] INMEM [0:1023];
    logic [7:0] DMEM [0:1023];
        
    logic [31:0] PCF, PCFBar, PCPlus4F;
    logic [31:0] IF_ID_PC, IF_ID_IR, IF_ID_NPC;
    wire PCSrcE;
    
    logic [31:0] RD1E, RD2E;
    wire [31:0] Imm;
    
    //id_ex
    logic [31:0] ID_EX_PC, ID_EX_IR; 
    logic [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd; 
    logic [31:0] ID_EX_Imm, ID_EX_NPC, ID_EX_Rd1, ID_EX_Rd2;
    
    //control signals
    logic ID_EX_RegWrite, ID_EX_MemWriteD, ID_EX_JumpD, ID_EX_BranchD, ID_EX_ALUSrcD;
    logic [1:0] ID_EX_ResultSrcD;
    logic [2:0] ID_EX_ALUControlD;
    
    //EX_MEM
    wire [31:0] PCTargetE; 
    logic [31:0] EX_MEM_PC, EX_MEM_IR, EX_MEM_ALU, EX_MEM_WriteData, EX_MEM_NPC;
    logic [4:0] EX_MEM_Rd;
    // control signals
    logic EX_MEM_RegWrite, EX_MEM_MemWrite;  
    logic [1:0] EX_MEM_ResultSrc;
    
    wire [1:0] ForwardAE,ForwardBE;
    
    //MEM_WB
    logic [31:0] MEM_WB_PC, MEM_WB_IR, MEM_WB_NPC, MEM_WB_WriteData, MEM_WB_ReadData, MEM_WB_ALU;
    logic [4:0] MEM_WB_Rd;
    //control signals
    logic MEM_WB_RegWrite;  
    logic [1:0] MEM_WB_ResultSrc;

    
    wire [31:0] ALUOut; 

    wire ZeroE;
    wire [31:0] SrcAE, SrcBE;
    wire [31:0] mux_2_out;
    
    wire [31:0] ResultW;
    wire [31:0] RD1, RD2;
    
    wire StallF, StallD;
    wire FlushD, FlushE;
    
    wire RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD;
    wire [1:0] ResultSrcD, ImmSrcD;
    wire [2:0] ALUControlD;
    
    // IF STAGE
    Mux2_1 PC_MUX(.a(PCPlus4F), .b(PCTargetE), .s(PCSrcE), .out(PCFBar));
    PC_Module PCM(.clk(clk), .reset(reset), .stall(StallF), .PC(PCFBar), .NPC(PCF));
    Adder PC_Adder(.a(PCF), .b(32'd4), .out(PCPlus4F));
    // IF STAGE
    
    // ID STAGE
    ControlUnit CU(.IF_ID_IR(IF_ID_IR), .RegWriteD(RegWriteD), .ResultSrcD(ResultSrcD), .MemWriteD(MemWriteD), .JumpD(JumpD), .BranchD(BranchD), .ALUControlD(ALUControlD), .ALUSrcD(ALUSrcD), .ImmSrcD(ImmSrcD));
    RegFile RegFile(.clk(clk), .A1(IF_ID_IR[19:15]), .A2(IF_ID_IR[24:20]), .A3(MEM_WB_Rd), .WD3(ResultW), .WE3(MEM_WB_RegWrite), .RD1(RD1), .RD2(RD2));
    ImmGen ImmGen(.In(IF_ID_IR), .ImmSrc(ImmSrcD), .Imm_Ext(Imm));
    // ID STAGE
    
    //EX STAGE
    Mux3_1 Mux1(.a(ID_EX_Rd1), .b(ResultW), .c(EX_MEM_ALU), .s(ForwardAE), .out(SrcAE));
    Mux3_1 Mux2(.a(ID_EX_Rd2), .b(ResultW), .c(EX_MEM_ALU), .s(ForwardBE), .out(mux_2_out));
    Mux2_1 Mux3(.a(mux_2_out), .b(ID_EX_Imm), .s(ID_EX_ALUSrcD), .out(SrcBE));
    ALU ALU(.A(SrcAE), .B(SrcBE), .Result(ALUOut), .ALUControl(ID_EX_ALUControlD), .Zero(ZeroE));
    Adder Adder(.a(ID_EX_PC), .b(ID_EX_Imm), .out(PCTargetE));
    //EX STAGE
    
    //WB STAGE
    Mux3_1 Mux4(.a(MEM_WB_ALU), .b(MEM_WB_ReadData), .c(MEM_WB_NPC), .s(MEM_WB_ResultSrc), .out(ResultW));
    //WB STAGE
    
    HazardUnit HU(.Rs1D(IF_ID_IR[19:15]), .Rs2D(IF_ID_IR[24:20]), .RdE(ID_EX_Rd), .Rs2E(ID_EX_Rs2), .Rs1E(ID_EX_Rs1), .PCSrcE(PCSrcE), .ResultSrcE(ID_EX_ResultSrcD), .RdM(EX_MEM_Rd), .RegWriteM(EX_MEM_RegWrite), .RdW(MEM_WB_Rd), .RegWriteW(MEM_WB_RegWrite), .StallF(StallF), .StallD(StallD), .FlushD(FlushD), .FlushE(FlushE), .ForwardAE(ForwardAE), .ForwardBE(ForwardBE));
    
    assign PCSrcE = ID_EX_JumpD | (ZeroE & ID_EX_BranchD);
    
    always_ff @(posedge clk or posedge reset) begin
        if(reset) begin
            IF_ID_PC <= 32'b0;
            IF_ID_IR <= 32'b0;
            ID_EX_IR <= 32'b0;
            EX_MEM_IR <= 32'b0;
            MEM_WB_IR <= 32'b0;
            ID_EX_JumpD <= 1'b0;
            ID_EX_BranchD <= 1'b0;
        end
    end

    always_ff @(posedge clk) begin   // IF STAGE
        if(!reset) begin
            if(!StallD) begin
                if(!FlushD) begin
                    IF_ID_PC <= PCF;
                    IF_ID_IR <= {INMEM[PCF + 3], INMEM[PCF + 2], INMEM[PCF + 1], INMEM[PCF]};
                    IF_ID_NPC <= PCPlus4F;
                end
                else if (FlushD) begin
                    IF_ID_PC <= 32'b0;
                    IF_ID_IR <= 32'b0;
                    IF_ID_NPC <= 32'b0;
                end
            end
        end
    end
    
    always_ff @(posedge clk) begin  // ID STAGE
        
        if(!reset) begin
            if(!FlushE) begin
                ID_EX_IR <= IF_ID_IR;
                ID_EX_PC <= IF_ID_PC;
                ID_EX_Rs1 <= IF_ID_IR[19:15];
                ID_EX_Rs2 <= IF_ID_IR[24:20];
                ID_EX_Rd <= IF_ID_IR[11:7];
                ID_EX_Imm <= Imm;
                ID_EX_NPC <= IF_ID_NPC;
                ID_EX_Rd1 <= RD1;
                ID_EX_Rd2 <= RD2;
                
                //control signals
                ID_EX_RegWrite <= RegWriteD;
                ID_EX_ResultSrcD <= ResultSrcD;
                ID_EX_MemWriteD <= MemWriteD;
                ID_EX_JumpD <= JumpD;
                ID_EX_BranchD <= BranchD;
                ID_EX_ALUControlD <= ALUControlD;
                ID_EX_ALUSrcD <= ALUSrcD;
                
                
            end
            else begin
                ID_EX_IR <= 32'b0;
                ID_EX_PC <= 32'b0;
                ID_EX_Rs1 <= 5'b0;
                ID_EX_Rs2 <= 5'b0;
                ID_EX_Rd <= 5'b0;
                ID_EX_Imm <= 32'b0;
                ID_EX_NPC <= 32'b0;
                ID_EX_Rd1 <= 32'b0;
                ID_EX_Rd2 <= 32'b0;
                
                //control signals
                ID_EX_RegWrite <= 1'b0;
                ID_EX_ResultSrcD <= 2'b00;
                ID_EX_MemWriteD <= 1'b0;
                ID_EX_JumpD <= 1'b0;
                ID_EX_BranchD <= 1'b0;
                ID_EX_ALUControlD <= 3'b000;
                ID_EX_ALUSrcD <= 1'b0;
            end

        end
            
    end
    
    always_ff @(posedge clk) begin  // EX STAGE
        if(!reset) begin
            EX_MEM_PC <= ID_EX_PC;
            EX_MEM_IR <= ID_EX_IR;
            EX_MEM_ALU <= ALUOut;
            EX_MEM_WriteData <= mux_2_out;
            EX_MEM_Rd <= ID_EX_Rd;
            EX_MEM_NPC <= ID_EX_NPC;
            
            //control signals
            EX_MEM_RegWrite <= ID_EX_RegWrite;
            EX_MEM_ResultSrc <= ID_EX_ResultSrcD;
            EX_MEM_MemWrite <= ID_EX_MemWriteD;
        end
    end
    
    always_ff @(posedge clk) begin  // MEM STAGE
        if(!reset) begin
            MEM_WB_PC <= EX_MEM_PC;
            MEM_WB_IR <= EX_MEM_IR;
            MEM_WB_NPC <= EX_MEM_NPC;
            
            MEM_WB_ReadData <= {DMEM[EX_MEM_ALU + 3], DMEM[EX_MEM_ALU + 2], DMEM[EX_MEM_ALU + 1], DMEM[EX_MEM_ALU]};
            MEM_WB_Rd <= EX_MEM_Rd;
            MEM_WB_ALU <= EX_MEM_ALU;
            
            if(EX_MEM_MemWrite) begin
                DMEM[EX_MEM_ALU] <= EX_MEM_WriteData[7:0];
                DMEM[EX_MEM_ALU + 1] <= EX_MEM_WriteData[15:8];
                DMEM[EX_MEM_ALU + 2] <= EX_MEM_WriteData[23:16];
                DMEM[EX_MEM_ALU + 3] <= EX_MEM_WriteData[31:24];
            end
            
            //control signals
            MEM_WB_RegWrite <= EX_MEM_RegWrite;
            MEM_WB_ResultSrc <= EX_MEM_ResultSrc;
        end
    end
    
    always_ff @(posedge clk) begin  // WB STAGE
        if(!reset) begin
        end
    end
    
endmodule
