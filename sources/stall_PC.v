`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2024 19:21:40
// Design Name: 
// Module Name: stall_PC
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


module stall_PC(
    clk,
    data,
    rst,
    out,
    en
    );
    
    input [31:0] data;
    output reg [31:0] out;
    input clk, rst, en;
    
    always@(posedge clk) begin
        if(rst)
            out <= 32'd0;
        else if(~en)
            out <= data;
    end
    
    
endmodule
