`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2025 22:35:45
// Design Name: 
// Module Name: tb
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


module tb;
    logic clk, reset, reset_mem;

    // Instantiate the RISC-V processor
    risc cpu (
        .clk(clk),
        .reset(reset),
        .reset_mem(reset_mem)
    );
    
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1'b1;
        reset_mem = 1'b1;
        cpu.PCPlus4F = 32'b0;
        for (int i = 0; i < 256; i++)
            cpu.INMEM[i] = 8'h00;
        
        cpu.DMEM[10] = 8'h05;
        cpu.DMEM[11] = 8'h00;
        cpu.DMEM[12] = 8'h00;
        cpu.DMEM[13] = 8'h00;
        
            
        #10;
        reset_mem = 1'b0;
        cpu.RegFile.REGISTER[0] = 32'd0;
        cpu.RegFile.REGISTER[1] = 32'd5;   // x1 = 5
        cpu.RegFile.REGISTER[2] = 32'd10;  // x2 = 10
        cpu.RegFile.REGISTER[6] = 32'd1;   // x6 = 1
        
        {cpu.INMEM[3], cpu.INMEM[2], cpu.INMEM[1], cpu.INMEM[0]} = 32'h002081b3; // x3 = x1 + x2
        {cpu.INMEM[7], cpu.INMEM[6], cpu.INMEM[5], cpu.INMEM[4]} = 32'h40118233;   // x4 = x3 - x1
        {cpu.INMEM[11], cpu.INMEM[10], cpu.INMEM[9], cpu.INMEM[8]} = 32'h00402023; // sw x4, 0(x0)
        {cpu.INMEM[15], cpu.INMEM[14], cpu.INMEM[13], cpu.INMEM[12]} = 32'h00002283; //lw x5,0(x0)
        {cpu.INMEM[19], cpu.INMEM[18], cpu.INMEM[17], cpu.INMEM[16]} = 32'h00520863; // beq x4, x5, 8
        {cpu.INMEM[35], cpu.INMEM[34], cpu.INMEM[33], cpu.INMEM[32]} = 32'h00000333; // x6 = x0 + x0
        {cpu.INMEM[39], cpu.INMEM[38], cpu.INMEM[37], cpu.INMEM[36]} = 32'h0020a433; // slt x8, x1, x2
        {cpu.INMEM[43], cpu.INMEM[42], cpu.INMEM[41], cpu.INMEM[40]} = 32'h0020f533; // x10 = x1 & x2
        {cpu.INMEM[47], cpu.INMEM[46], cpu.INMEM[45], cpu.INMEM[44]} = 32'h0020e5b3; // x11 = x1 | x2
        
        #10;
        reset = 0;
        #300;
        $display("x3 = %d (Expected: 15)", cpu.RegFile.REGISTER[3]);
        $display("x4 = %d (Expected: 10)", cpu.RegFile.REGISTER[4]);
        $display("Memory[0] = %d (Expected: 10)", {cpu.DMEM[3], cpu.DMEM[2], cpu.DMEM[1], cpu.DMEM[0]});
        $display("x5 = %d (Expected: 10)", cpu.RegFile.REGISTER[5]);
        $display("x6 = %d (Expected: 0)", cpu.RegFile.REGISTER[6]); // should be 0 if beq taken
        $display("x8 = %d (Expected: 0)", cpu.RegFile.REGISTER[8]);
        $display("x10 = %d (Expected: 0)", cpu.RegFile.REGISTER[10]);
        $display("x11 = %d (Expected: 0)", cpu.RegFile.REGISTER[11]);
        

        if(cpu.RegFile.REGISTER[3] == 32'd15 && cpu.RegFile.REGISTER[4] == 32'd10 && cpu.RegFile.REGISTER[5] == 32'd10 && cpu.RegFile.REGISTER[6] == 32'd0)
            $display("Test Passed");
        else
            $display("Test Failed");
    
        $finish;
    end
    initial begin
        #350 $finish;
        reset = 1;

    end
endmodule
