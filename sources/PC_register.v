`timescale 1ns/1ps

module PC_register(data, clk,rst, out, en, Inst_stall, ALU_branch, ALU_branchF);
    input [31:0] data;
    input ALU_branch;
    output reg ALU_branchF;
    input clk, rst, en, Inst_stall;
    output reg [31:0] out;
    
    
    reg jaldd;
    
//    always@(posedge clk) begin
//        if(rst)
//            jaldd <= 1'b0;
//        else
//            jaldd <= jalD;
//    end
    
    always @(posedge clk)begin
        if(rst) begin
            out <= 32'b0;
            ALU_branchF <= 1'b0;
            end
        else if(~(en || Inst_stall)) begin
            ALU_branchF <= ALU_branch;
            out <= data;
            end
      end

endmodule