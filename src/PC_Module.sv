`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.07.2025 11:06:07
// Design Name: 
// Module Name: PC_Module
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


module PC_Module(clk, reset, stall, PC, NPC);
    
    input clk, reset;
    input stall;
    
    input [31:0] PC;
    output wire [31:0] NPC;
    
    reg [31:0] next_pc;
    
    assign NPC = next_pc;
    
    always_ff @(posedge clk) begin
        
        if(reset) next_pc <= 32'b0;
        else begin
            if(!stall) begin 
                next_pc <= PC;        
            end
        end

    
    end
    
endmodule
