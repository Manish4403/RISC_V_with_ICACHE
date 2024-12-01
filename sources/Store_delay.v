`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2024 15:46:52
// Design Name: 
// Module Name: Store_delay
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


module Store_delay(
                WriteDataM , AluResultM, AdrM, 
                clk, StoreSrcM ,
                MemwriteM,rst,
                
                //output
                WriteDataS , AluResultS, AdrS, 
                 StoreSrcS ,
                MemwriteS
                   );
    
    input [31:0] WriteDataM;
    input clk, rst, MemwriteM;
    input [1:0] AdrM;
    
    input [2:0] StoreSrcM;
    input [5:0] AluResultM;
    
    output reg [31:0] WriteDataS;
    output reg MemwriteS;
    output reg [1:0] AdrS;
    
    output reg [2:0] StoreSrcS;
    output reg [5:0] AluResultS; 
    
    
    
    
    always@(posedge clk) begin
        if(rst) begin
            WriteDataS <= 32'b0;
            AluResultS <= 6'd0;
            AdrS <= 2'd0;           
            StoreSrcS <= 3'd0;

            MemwriteS <= 1'd0;
        end
        else
        begin
            WriteDataS <= WriteDataM;
            AluResultS <= AluResultM;
            AdrS <= AdrM;           
            StoreSrcS <= StoreSrcM;
            MemwriteS <= MemwriteM;
        end
    end
    
endmodule
