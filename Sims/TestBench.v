`timescale 0.01ns/1ps

module RISC_V_tb();
    reg clk, rst;

        
     
    
    RISC_V dut (clk, rst);
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 1'b1;
        rst = 1'b1;
        #2
        rst = 1'b0;
        #13000
        $finish;
    end
    
endmodule