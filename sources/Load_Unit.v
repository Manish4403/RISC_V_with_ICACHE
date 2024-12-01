`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2024 16:49:24
// Design Name: 
// Module Name: Load_Unit
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
`define lw 3'b010
`define lb 3'b000
`define lh 3'b001
`define lbu 3'b100
`define lhu 3'b101


module Load_Unit(
            
            data_in,
            lb, lbu, lh, lhu,
            lw,
            A,
            Data_out
    );
    
    input signed [31:0] data_in;
    input lb, lbu, lh, lhu, lw;
    input [1:0] A;
    
    output  reg signed [31:0] Data_out;
    reg [7:0] D1, D4, D2, D3, D5, D6, D7;

    
    
    //Main decoder
    always@(*) begin
    //M1
        case(A)
            2'b00: D1 = data_in[7:0];
            2'b01: D1 = data_in[15:8];
            2'b10: D1 = data_in [23:16];
            2'b11: D1 = data_in[31:24];
        endcase
        // M2
        if({lb,lbu} == 2'b10)
            D4 = {8{D1[7]}};
        else
            D4 = 8'd0;
        
        //M3
        if(A[1] == 1'b1)
            D2 = data_in[23:16];
        else
            D2 = data_in[7:0];
            
        //M4
        if({lh,lhu} == 2'b10)
            D3 = D2;
        else
            D3 = D1;
            
        //M5
        if(lw)
            Data_out[7:0] = data_in[7:0];
        else
            Data_out[7:0] = D3;
            
         //M6
         if(A[1])
            D5 = data_in[15:8];
         else
            D5 = data_in[15:8];
          
          //M7
          if({lh,lhu} == 2'b10)
            D6 = D5;
          else
            D6 = D4;
        
        //M8
        if(lw)
            Data_out[15:8] = data_in[15:8];
        else
            Data_out[15:8] = D6;
            
        //M9
        if({lh,lhu} == 2'b01)
            D7 = 8'd0;
        else if({lh,lhu} == 2'b10)
            D7 = {8{D5[7]}};
        else
            D7 = D4;
        
        //M10
        if(lw)
            Data_out[23:16] = data_in[23:16];
        else
            Data_out[23:16] = D7;
            
        //M11
        if(lw)
            Data_out[31:24] = data_in[31:24];
        else
            Data_out[31:24] = D7;
            
        
        
    end
endmodule
