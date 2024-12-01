`timescale 1ns / 1ps

//`define lw 3'b010
//`define lb 3'b000
//`define lh 3'b001
//`define lbu 3'b100
//`define lhu 3'b101


module mux8to1(result, sel, in0, in1, in2, in3, in4);
    input [31:0] in0, in1, in2, in3, in4;
    input [2:0] sel;
    output reg [31:0] result;
    
    always@ (*) begin
        case(sel)
            3'b000 : result = in0;
            3'b001 : result = in1;
            3'b010 : result = in2;
            3'b011 : result = in3;
            3'b100 : result = in4;
            default : result = 32'd0;
         endcase
    end
    
endmodule
