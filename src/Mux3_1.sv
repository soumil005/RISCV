`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2025 19:45:18
// Design Name: 
// Module Name: Mux3_1
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


module Mux3_1(a, b, c, s, out);

    input [31:0] a,b,c;
    input [1:0] s;
    
    output [31:0] out;
    
    assign out = s == 2'b00 ? a : s == 2'b01 ? b : s == 2'b10 ? c : 32'b0;
    
endmodule
