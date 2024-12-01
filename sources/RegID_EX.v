`timescale 1ns / 1ps



module RegID_EX(
//output
RegwriteE, MemwriteE, alusrcE,resultsrcE, load_srcE,store_srcE,                         
alucontrolE,Rd1E, Rd2E, ImmextE, Pcplus4E, PcE,
Rs1E, Rs2E, RdE,clk, clr, rst, jalE, jalrE,AdrD,
//input
miss_flush,
RegwriteD, MemwriteD, alusrcD,
resultsrcD, load_srcD,
 store_srcD,alucontrolD,
 Rd1D, Rd2D, ImmextD, Pcplus4D, PcD,
 Rs1D, Rs2D, RdD, jalD, jalrD,
 AdrE
);
    input clk, clr, rst, miss_flush;
    input RegwriteD, MemwriteD, alusrcD;
    input [4:0] load_srcD;
    input [1:0] AdrD;
    input signed [2:0] resultsrcD;
    input signed [2:0] store_srcD;
    input signed [3:0] alucontrolD;
    input signed [31:0] Rd1D, Rd2D, ImmextD, Pcplus4D, PcD;
    input signed [4:0] Rs1D, Rs2D, RdD;
    input jalD, jalrD;
    
    
    
    
    output reg RegwriteE, MemwriteE, alusrcE;
    output reg signed [2:0] resultsrcE;
    output reg [4:0] load_srcE;
    output reg [1:0] AdrE;
    output reg [2:0] store_srcE;
    output reg signed [3:0] alucontrolE;
    output reg signed [31:0] Rd1E, Rd2E, ImmextE, Pcplus4E, PcE;
    output reg signed [4:0] Rs1E, Rs2E, RdE;
    output reg jalE, jalrE;
    
    

    
    
always@(posedge clk)begin      // If you trigger the always block with asyn clr then it creates problem.
    if(rst || clr) begin
        resultsrcE <= 3'b0;
        load_srcE <= 5'b0;
        store_srcE <= 3'b0;
        RegwriteE <= 1'b0;
        MemwriteE <= 1'b0;
        alusrcE <= 1'b0;
        alucontrolE <= 4'b0;
        Rd1E <= 32'b0;
        Rd2E <= 32'b0;
        ImmextE <= 32'b0;
        Pcplus4E <= 32'b0;
        PcE <= 32'b0;
        Rs1E <= 5'b0;
        Rs2E <= 5'b0;
        RdE <= 5'b0;
        jalE <= 1'b0;
        jalrE <= 1'b0;
        AdrE <= 2'b0;
    end
    else begin
        resultsrcE <= resultsrcD;
        load_srcE <= load_srcD;
        store_srcE <= store_srcD;
        RegwriteE <= RegwriteD;
        MemwriteE <= MemwriteD;
        alusrcE <= alusrcD;
        alucontrolE <= alucontrolD;
        Rd1E <= Rd1D;
        Rd2E <= Rd2D;
        ImmextE <= ImmextD;
        Pcplus4E <= Pcplus4D;
        PcE <= PcD;
        Rs1E <= Rs1D;
        Rs2E <= Rs2D;
        RdE <= RdD;
        jalE <= jalD;
        jalrE <= jalrD;
        AdrE <= AdrD;

    end
end


endmodule
