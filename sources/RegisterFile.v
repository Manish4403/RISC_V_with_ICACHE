`timescale 1ns/1ps




module RegisterFile(A1,A2,A3,WD3,clk, WE3,RD1, RD2, RD3); // A3 is the destination regiter.
    input [4:0] A1,A2,A3;
    input [31:0]WD3;
    input clk, WE3;
    output reg [31:0] RD1, RD2;
    output reg [15:0] RD3;

    
    integer i;
    reg [31:0] mem[0:31];

    
  
    

    always@(posedge clk)
    begin
        if(WE3)     // Because register zero is only to store zero values.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
            mem[A3] <= WD3;
    end
    
    always@(*) begin
            RD1 = mem[A1];
            RD2 = mem[A2];
        end
    
    
    
    initial begin
        mem[0] = 32'b0; // Hard wired to 0.
        mem[1] = 32'b0;
        mem[2] = 32'd0;
        mem[3] = 32'd0;
        mem[4] = 32'd0;
//        for (i = 5; i < 32; i = i + 1) 
//            begin
//                mem[i] = 32'b0;
//            end
       end
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       initial begin
        mem[20] = 32'd15;
    end
       
       
       always@(*) begin
        RD3 = mem[15];
       end
endmodule
