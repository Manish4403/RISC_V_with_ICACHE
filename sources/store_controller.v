`timescale 1ns / 1ps

`define sw 2'b10
`define sb 2'b00
`define sh 2'b01



module store_controller(funct3, result, store);
    input [1:0] funct3;
    input store;
    output reg [2:0] result;
    
    always@ (*) begin
        result = 3'b000;
        if(store) begin
            case(funct3)
                `sw: result = 3'b100;
                `sb: result = 3'b001;
                `sh: result = 3'b010;
                default: result = 3'b000;
            endcase
           end
           
    end
endmodule
