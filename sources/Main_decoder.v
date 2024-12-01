`timescale 1ns/1ps

`define R_T 7'b0110011
`define I_Ty 7'b0010011
`define ld 7'b0000011
`define jalr 7'b1100111
`define S_Ty 7'b0100011
`define J_Ty 7'b1101111
`define B_Ty 7'b1100011
`define lui 7'b0110111
`define auipc 7'b0010111



module Main_decoder(op, resultsrc, memwrite, alusrc, immsrc, regwrite, jal, jalr,aluop,load,store,
                    funct3, funct7);
    input [6:0]op;
    input [2:0] funct3;
    input funct7;
    output reg[2:0]immsrc,resultsrc;
    output reg[1:0] aluop;
    output reg memwrite, alusrc, jal, jalr, regwrite,load,store;
    
    reg [6:0] op_reg;
    reg [2:0] funct3_reg;
    reg funct7_reg;
    
    always@(*) begin
        funct3_reg = funct3;
        funct7_reg = funct7;
        op_reg = op;
    end
    
    always@(op_reg or funct3_reg or funct7_reg)begin
        {memwrite, alusrc, jal, jalr, regwrite,resultsrc, aluop,immsrc,load,store} = 16'b0;
        case(op_reg)
            `R_T: begin
                   aluop = 2'b10;
                   regwrite = 1'b1;
                  end
            `I_Ty: begin
                    if((funct3_reg == 3'b001 | funct3_reg == 3'b101) & ~funct7_reg) begin
                        aluop = 2'b11;
                        regwrite = 1'b1;
                        jalr = 1'b0;
                        alusrc = 1'b1;
                        resultsrc = 3'b000;
                        immsrc = 3'b110; 
                        end
                     else if((funct3_reg == 3'b101) & funct7_reg) begin
                        aluop = 2'b11;
                        regwrite = 1'b1;
                        jalr = 1'b0;
                        alusrc = 1'b1;
                        resultsrc = 3'b000;
                        immsrc = 3'b101;
                     end
                     else begin
                        aluop = 2'b11;
                        regwrite = 1'b1;
                        jalr = 1'b0;
                        alusrc = 1'b1;
                        resultsrc = 3'b000;
                        immsrc = 3'b000;
                     end
                  end
             `ld: begin
                    load = 1'b1;
                    regwrite = 1'b1;
                    memwrite = 1'b0;
                    alusrc = 1'b1;
                    aluop = 2'b00;
                    resultsrc = 3'b001;
                    jalr = 1'b0;
                    immsrc = 3'b111;
                  end
              `jalr: begin
                        regwrite = 1'b1;
                        jalr = 1'b1;
                        immsrc = 3'b000;
                        alusrc = 1'b1;
                        resultsrc = 3'b010;
                        aluop = 2'b00;
                     end
               `S_Ty: begin
                        store = 1'b1;
                        immsrc = 3'b001;
                        aluop = 2'b00;
                        memwrite = 1'b1;
                        alusrc = 1'b1;
                     end
                `J_Ty: begin
                        regwrite = 1'b1;
                        immsrc = 3'b011;
                        aluop = 2'b00;
                        resultsrc = 3'b010;
                        jal = 1'b1;
                      end
                `B_Ty: begin
                        immsrc = 3'b010;
                        aluop = 2'b01;
                      end
                `lui: begin
                        immsrc = 3'b100;
                        regwrite = 1'b1;
                        resultsrc = 3'b011; 
                      end
                 `auipc: begin
                            immsrc = 3'b100;
                            regwrite = 1'b1;
                            resultsrc = 3'b100;
                         end
                default: begin
                            {memwrite, alusrc, jal, jalr, regwrite,resultsrc, aluop,immsrc,load,store} = 15'b0;
                         end
        endcase
    end 
    
endmodule
