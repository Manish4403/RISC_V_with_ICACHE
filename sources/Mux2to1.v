`timescale 1ns/1ps

module Mux2to1(in1, in0,sel,out);
    input [31:0]in1,in0;
    input [0:0]sel;
    output [31:0] out;
    
    
    assign out = sel? in1:in0; 
endmodule