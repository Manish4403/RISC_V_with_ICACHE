`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2024 22:12:26
// Design Name: 
// Module Name: ALU_controller
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


`define blt 3'b100
`define beq 3'b000
`define bne 3'b001
`define bge 3'b101
`define bltu 3'b110
`define bgeu 3'b111

module ALU_decoder(funct3, ALUOp, funct7, ALUControl,op4);  // op4 is require for slti and lw opcode defferes in 4th bit.
input [2:0]funct3;
input [1:0] ALUOp;
input funct7,op4;

output reg [3:0]ALUControl;

always@ (ALUOp  or funct3 or funct7 or op4) begin
    case(ALUOp)
        2'b00: ALUControl = 4'b0000;
        2'b01: ALUControl = (funct3 == `blt) ? 4'b1000:    // ALUCONTROL 01 is for branch
                            (funct3 == `beq) ? 4'b1100:
                            (funct3 == `bne) ? 4'b1101:
                            (funct3 == `bge) ? 4'b1001:
                            (funct3 == `bltu) ? 4'b1010:
                            (funct3 == `bgeu) ? 4'b1011: 4'bx;
        2'b10: ALUControl =                                                             //For R-type instructions.
                        ((funct3 == 3'b000) & ~funct7 ) ? 4'b0000:
                        ((funct3 == 3'b000) & funct7 ) ? 4'b0001:
                        (funct3 == 3'b010) ? 4'b0101:
                        (funct3 == 3'b110) ? 4'b0011:
                        (funct3 == 3'b111) ? 4'b0010:
                        (funct3 == 3'b100) ? 4'b0100:
                        (funct3 == 3'b001) ? 4'b0110:
                        (funct3 == 3'b101) ? 4'b0111:
                        (funct3 == 3'b011) ? 4'b1111:  //sltu
                        4'bx;
        2'b11: ALUControl =                                // FOr I-type instructions
                        (funct3 == 3'b000) ? 4'b0000: 
                        (funct3 == 3'b010 & op4) ? 4'b0101:
                        (funct3 == 3'b010 & ~op4) ? 4'b0000:
                        (funct3 == 3'b110) ? 4'b0011:
                        (funct3 == 3'b100) ? 4'b0100:
                        (funct3 == 3'b001) ? 4'b0110:
                        (funct3 == 3'b101 & ~funct7) ? 4'b0111: //srli
                        (funct3 == 3'b101 & funct7) ? 4'b1110:  //srai
                        (funct3 == 3'b011) ? 4'b1111: //sltui
                        4'bx;
        default: ALUControl = 3'bx;
        
    endcase
end

endmodule
