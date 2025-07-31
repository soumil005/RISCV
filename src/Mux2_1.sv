`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2025 19:43:36
// Design Name: 
// Module Name: Mux2_1
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


module Mux2_1(a, b, s, out);
    
    input [31:0] a,b;
    input s;
    
    output [31:0] out;
    
    assign out = s == 1'b0 ? a : b;
    
endmodule
