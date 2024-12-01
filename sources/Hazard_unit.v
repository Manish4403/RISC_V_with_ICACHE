`timescale 1ns / 1ps



module Hazard_unit(RegwriteM, RegwriteW,Rs1E, Rs2E, RdM, Rs1D, Rs2D,
                   RdW, RdE, forwardAE, forwardBE, resultsrcE, stallF,
                   stallD, flushE, flushD, Branch, jalD);
    input RegwriteM, RegwriteW, Branch, jalD;
    input [4:0] Rs1E, Rs2E, RdM, Rs1D, Rs2D, RdW, RdE;
    input [2:0] resultsrcE;
    output reg [1:0] forwardAE, forwardBE;
    output stallF, stallD, flushE, flushD;
    wire lwstall;
    

    

    
    
    // forwarding
    always@ (*) begin
        if(((Rs1E == RdM) & RegwriteM) & (Rs1E != 0))
            forwardAE = 2'b10;
        else if(((Rs1E == RdW) & RegwriteW) & (Rs1E != 0))
            forwardAE = 2'b01;
        else
            forwardAE = 2'b00;
    end 
    
    always@ (*) begin
        if(((Rs2E == RdM) & RegwriteM) & (Rs2E != 0))
            forwardBE = 2'b10;
        else if(((Rs2E == RdW) & RegwriteW) & (Rs2E != 0))
            forwardBE = 2'b01;
        else
            forwardBE = 2'b00;
    end
    
    //Stalling.
    assign lwstall = (resultsrcE == 3'b001) & ((Rs1D == RdE) | (Rs2D == RdE));
    assign stallF = lwstall;
    assign stallD = lwstall;
    assign flushE = Branch | lwstall || jalD; // For j type i don't need to flush the ID_EXreg.

    //control Hazard
    assign flushD = Branch || jalD;
    
    
endmodule
