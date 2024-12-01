`timescale 1ns/1ps

module RegIF_ID(instrF, PCF, PCplus4F, clk, rst,clr, en,instrD,PCD,PCPlus4D, Inst_flush);
    input [31:0] instrF, PCF, PCplus4F;
    input clk,rst,en,clr, Inst_flush;
    output reg  [31:0] instrD,PCD,PCPlus4D;
    
//    reg[31:0] inst, pc, pclus4;
    
    always@ (posedge clk) begin
        if(rst || clr || Inst_flush) begin
                instrD <= 32'b0;
                PCD <= 32'b0;
                PCPlus4D <= 32'b0;
            end
        else if(~en) begin
                instrD <= instrF;
                PCD <= PCF;
                PCPlus4D <= PCplus4F;
            end

    end
    
endmodule