`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2025 13:29:48
// Design Name: 
// Module Name: ImmGen
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


module ImmGen(In,ImmSrc,Imm_Ext);
    input [31:0] In;
    input [1:0] ImmSrc;
    output [31:0] Imm_Ext;

    assign Imm_Ext =  (ImmSrc == 2'b00) ? {{20{In[31]}},In[31:20]} : 
                      (ImmSrc == 2'b01) ? {{20{In[31]}},In[31:25],In[11:7]} : 
                      (ImmSrc == 2'b10) ? {{20{In[31]}}, In[7], In[30:25], In[11:8], 1'b0} : 32'b0; 

endmodule