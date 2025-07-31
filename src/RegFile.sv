`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2025 13:19:39
// Design Name: 
// Module Name: RegFile
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


module RegFile(clk, A1, A2, A3, WD3, WE3, RD1, RD2);
    
    reg [31:0] REGISTER [0:31];
    input clk;
    input [4:0] A1, A2, A3;
    input WE3;
    input [31:0] WD3;
    
    output logic [31:0] RD1, RD2;
    
    assign RD1 = REGISTER[A1];
    assign RD2 = REGISTER[A2];
    
    always_ff @(negedge clk) begin
        if(WE3) begin
            REGISTER[A3] <= WD3;
        end
    end
    
endmodule
