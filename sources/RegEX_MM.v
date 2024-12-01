`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2024 21:59:34
// Design Name: 
// Module Name: RegEX_MM
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


module RegEX_MM(clk, rst,regwriteE, memwriteE,rdE,aluresultE, writeDataE, auipcE,
                 immextE, pcplus4E,resultsrcE, loadsrcE,StoreSrcE ,AdrE,
                 //output
                 regwriteM, memwriteM,rdM,aluresultM, writeDataM, auipcM,
                 immextM, pcplus4M,resultsrcM, loadsrcM, StoreSrcM, AdrM
                 );
    input clk, rst;
    input regwriteE, memwriteE;
    input [1:0] AdrE;
    input [2:0] resultsrcE, StoreSrcE;
    input [4:0] loadsrcE;
    input signed [4:0] rdE;
    input signed [31:0] aluresultE, writeDataE, auipcE,
                 immextE, pcplus4E; 
    
    output reg regwriteM, memwriteM;
    output reg [2:0] resultsrcM, StoreSrcM;
    output reg [1:0] AdrM;
    output reg [4:0] loadsrcM;
    output reg signed [4:0] rdM;
    output reg signed [31:0] aluresultM, writeDataM, auipcM,
                 immextM, pcplus4M;
                 
     always@(posedge clk) begin
        if(rst) begin
            regwriteM <= 1'b0;
            memwriteM <= 1'b0;
            rdM <= 5'b0;
            aluresultM  <= 32'b0;
            writeDataM  <= 32'b0;
            auipcM <= 32'b0;
            immextM <= 32'b0;
            pcplus4M <= 32'b0;
            resultsrcM <= 32'b0;
            loadsrcM <= 5'b0;
            StoreSrcM <= 3'b0;
            AdrM <= 2'b0;
        end
        else begin
            regwriteM <= regwriteE;
            memwriteM <= memwriteE;
            rdM <= rdE;
            aluresultM  <= aluresultE;
            writeDataM  <= writeDataE;
            auipcM <= auipcE;
            immextM <= immextE;
            pcplus4M <= pcplus4E;
            resultsrcM <= resultsrcE;
            loadsrcM <= loadsrcE;
            StoreSrcM <= StoreSrcE;
            AdrM <= AdrE;
        end
            
     end    
                 
endmodule
