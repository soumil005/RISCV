`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2025 19:06:54
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(IF_ID_IR, RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcD, ImmSrcD);

    input [31:0] IF_ID_IR;
    output wire RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD;
    output wire [1:0] ResultSrcD, ImmSrcD;
    output wire [2:0] ALUControlD;
    
    logic [6:0] Op;
    logic [1:0] ALUOp;
    logic [2:0] funct3;
    logic [6:0] funct7;
    
    assign Op = IF_ID_IR[6:0];
    assign funct3 = IF_ID_IR[14:12];
    assign funct7 = IF_ID_IR[31:25];
    
    assign RegWriteD = (Op == 7'b0000011 | Op == 7'b0110011 | Op == 7'b0010011 ) ? 1'b1 : 1'b0 ;
    assign ImmSrcD = (Op == 7'b0100011) ? 2'b01 : 
                    (Op == 7'b1100011) ? 2'b10 :  2'b00 ;
    assign ALUSrcD = (Op == 7'b0000011 | Op == 7'b0100011 | Op == 7'b0010011) ? 1'b1 : 1'b0 ;
    assign MemWriteD = (Op == 7'b0100011) ? 1'b1 : 1'b0 ;
    assign ResultSrcD = (Op == 7'b0000011) ? 1'b1 : 1'b0 ;
    assign BranchD = (Op == 7'b1100011) ? 1'b1 : 1'b0 ;
    assign ALUOp = (Op == 7'b0110011) ? 2'b10 :
                   (Op == 7'b1100011) ? 2'b01 : 2'b00 ;
    
    assign JumpD = (Op == 7'b1101111) ? 1'b1 : 1'b0;
                   
    assign ALUControlD = (ALUOp == 2'b00) ? 3'b000 :
                         (ALUOp == 2'b01) ? 3'b001 :
                         ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({Op[5],funct7[5]} == 2'b11)) ? 3'b001 : 
                         ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({Op[5],funct7[5]} != 2'b11)) ? 3'b000 : 
                         ((ALUOp == 2'b10) & (funct3 == 3'b010)) ? 3'b101 : 
                         ((ALUOp == 2'b10) & (funct3 == 3'b110)) ? 3'b011 : 
                         ((ALUOp == 2'b10) & (funct3 == 3'b111)) ? 3'b010 : 3'b000;

endmodule
