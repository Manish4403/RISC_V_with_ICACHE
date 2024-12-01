`timescale 1ns / 1ps

`define blt 3'b100
`define beq 3'b000
`define bne 3'b001
`define bge 3'b101
`define bltu 3'b110
`define bgeu 3'b111


module Branch_controller(OPcode, funct3, ALUcontrol, Branch);
    input [0:6] OPcode;
    input [2:0] funct3;
    input [3:0] ALUcontrol;
    output Branch;
    
    assign Branch = (OPcode == 7'd99) ? funct3 == `blt ? 
    
    
    
    
endmodule
