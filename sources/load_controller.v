`timescale 1ns / 1ps

`define lw 3'b010
`define lb 3'b000
`define lh 3'b001
`define lbu 3'b100
`define lhu 3'b101


module load_controller(funct3, result, load);
    input [2:0] funct3;
    input load;
    output reg [4:0] result;
    
    always@(*)begin
        result = 5'd0;
        if(load) begin
        case(funct3)
            `lw : result = 5'b00001;
            `lb : result = 5'b01000;
            `lh : result = 5'b00010;
            `lbu : result = 5'b10000;
            `lhu : result = 5'b00100;
            default : result = 5'b0;
        endcase
        end
    end
endmodule
