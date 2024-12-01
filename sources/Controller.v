`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2024 18:48:34
// Design Name: 
// Module Name: Controller
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


module Controller(
                   op, funct3, funct7, pcsrc, resultsrc, memwrite, alucontrol, alusrc, 
                  immsrc, regwrite, load_src, store_src, jalD, jalrD,
                  jalE, jalrE, branch
                  );
                  
    input [6:0]op;
    input [2:0] funct3;
    input funct7;
    input jalE, jalrE, branch;
    
    output [1:0]pcsrc;
    output [2:0] store_src;
    output [2:0] resultsrc;
    output [2:0]immsrc;
    output [3:0] alucontrol;
    output memwrite, alusrc, regwrite;
    output [4:0] load_src;
    wire  [1:0]aluop;
    output jalD, jalrD;
    wire storeD, loadD;

    
    //Instatiating the alu decoder
    ALU_decoder ALU_decoder(.funct3(funct3), .ALUOp(aluop), .funct7(funct7), .ALUControl(alucontrol),.op4(op[4]));
    
    // Instatiating the  main decoder
    Main_decoder Main_decoder(.op(op), .resultsrc(resultsrc), .memwrite(memwrite), .alusrc(alusrc), .immsrc(immsrc), .regwrite(regwrite), 
                              .jal(jalD), .jalr(jalrD) ,.aluop(aluop), .load(loadD), .funct3(funct3), .funct7(funct7), .store(storeD)
                              );
                              
    // Instantiating the branch module
    store_controller store_controller(.funct3(funct3[1:0]),  .result(store_src), .store(storeD));
    
    //Load controller
    load_controller load_controller(.funct3(funct3),  .result(load_src), .load(loadD));
    
    
    assign pcsrc = (jalrD) ? 2'b10 : (branch || jalE || jalrE) ? 2'b01 : 2'b00;
    
   
    
endmodule
