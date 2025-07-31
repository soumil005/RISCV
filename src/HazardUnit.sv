`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2025 20:40:54
// Design Name: 
// Module Name: HazardUnit
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


module HazardUnit(Rs1D, Rs2D, RdE, Rs2E, Rs1E, PCSrcE, ResultSrcE, RdM, RegWriteM, RdW, RegWriteW, StallF, StallD, FlushD, FlushE, ForwardAE, ForwardBE);

    input [4:0] Rs1D, Rs2D, RdE, Rs2E, Rs1E, RdM, RdW;
    input PCSrcE, RegWriteM, RegWriteW;
    input [1:0] ResultSrcE;
    
    output wire StallF, StallD, FlushD, FlushE;
    output wire [1:0] ForwardAE, ForwardBE;
    
    reg [1:0] fAE, fBE;
    reg stallF, stallD;
    reg lwStall;
    
    always_comb begin
        if ( ( (Rs1E == RdM) & RegWriteM ) & Rs1E != 5'b0 ) begin
            fAE = 2'b10;
        end 
        else if( ( (Rs1E == RdW) & RegWriteW ) & Rs1E != 5'b0 ) begin
            fAE = 2'b01;
        end
        else fAE = 2'b00;
        
        if ( ( (Rs2E == RdM) & RegWriteM ) & Rs2E != 5'b0 ) begin
            fBE = 2'b10;
        end 
        else if( ( (Rs2E == RdW) & RegWriteW ) & Rs2E != 5'b0 ) begin
            fBE = 2'b01;
        end
        else fBE = 2'b00;

        lwStall = (ResultSrcE & 2'b01) & ((Rs1D == RdE) | (Rs2D == RdE));
        stallF = lwStall;
        stallD = lwStall;
    end
    
    assign ForwardAE = fAE;
    assign ForwardBE = fBE;
    assign StallF = stallF;
    assign StallD = stallD;
    assign FlushD = PCSrcE;
    assign FlushE = lwStall | PCSrcE;
endmodule
