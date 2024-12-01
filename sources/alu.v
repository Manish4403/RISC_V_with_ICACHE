`timescale 1ns/1ps


//`define ADD 3'b000
//`define SUB 3'b001
//`define SLT 3'b101
//`define OR 3'b001
//`define AND 3'b010
//`define XOR 3'b100
//`define SLL 3'b110
//`define SRL 3'b111

module alu(A, B, Result, ALUControl, ALU_branch);
    input [31:0] A,B;
    output signed [31:0] Result;
    input [3:0] ALUControl;

    output ALU_branch;
    wire signed [31:0] Sum;
    wire Cout;
    assign {Cout, Sum} =  (ALUControl[0] == 1'b0) ? A + B : (A - B);
    assign Result = (ALUControl == 4'b0000) ? Sum:     //addition
                    (ALUControl == 4'b0001) ? Sum:     //diff
                    (ALUControl == 4'b0101) ? $signed(A) < $signed(B):    //slt and slti
                    (ALUControl == 4'b1111) ? A < B:                      //sltiu , sltu
                    (ALUControl == 4'b0011) ? A | B:    //or, ori
                    (ALUControl == 4'b0010) ? A & B:    // and , andi
                    (ALUControl == 4'b0100) ? A ^ B:     //xor, xori
                    (ALUControl == 4'b0110) ? A << B:     //sla
                    (ALUControl == 4'b0111) ? A >> B:     //sra
                    (ALUControl == 4'b1110) ? A >>> B: {32{1'b0}};  //srai
     assign ALU_branch = 
                    (ALUControl == 4'b1000) ? $signed(A) < $signed(B):   //blt
                    (ALUControl == 4'b1001) ? $signed(A) >= $signed(B):  //bge
                    (ALUControl == 4'b1010) ? A < B:                    //bltu
                    (ALUControl == 4'b1011) ? A >= B:                   //bgeu
                    (ALUControl == 4'b1100) ? A == B:                    //beq
                    (ALUControl == 4'b1101) ? A != B: 
                                                     1'b0;               //bne

    
    
endmodule