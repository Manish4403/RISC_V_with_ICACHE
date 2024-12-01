`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2024 19:58:49
// Design Name: 
// Module Name: Jal_stall
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


module Jal_stall(
    clk,
    data,
    rst,
    out,
    en,
    out_x
    );
    
    input data;
    output reg  out;
    input clk, rst, en;
    reg out_next, out_more;
    output reg out_x;
    
    always@(posedge clk) begin
        if(rst) begin
            out <= 1'd0;
            out_next <= 1'd0;
            out_x <= 1'd0;
            end
        else if(~en) begin
            out_next <= data;
            out <= out_next;
            out_more <= out;
            out_x <= out_more;
            end
    end
    
    
endmodule
