`timescale 1ns/1ps


module InstMemory(A, RD);
    input [5:0] A;
    output [31:0] RD;
    //reg [31:0] instmem[0:99];
    
//    assign adr =  A;
//    generate
//        for (i)
////    endgenerate
//    always@(*) begin
//        instmem[0] = inst;
//    end

    dist_mem_gen_0 Inst_mem(.a(A), .spo(RD));
//    initial   // initializing some values (with a gap of 4)
//        begin
//            instmem[0] = 32'h01e00093; //addi with base address
//            instmem[4] = 32'h00008103; // Load in t1
//            instmem[8] = 32'h00900193; // t2 is updated 9
//            instmem[12] = 32'h00408093; // find max addi t1 = t1 + 2 
//            instmem[16] = 32'h00010203; // load into t3 = t1
//            instmem[20] = 32'h00414463; //blt with to update_max
//            instmem[24] = 32'h0080056f; // jump to continue loop
//            instmem[28] = 32'h00020113;  // update_max addi t2 = t4 + 0
//            instmem[32] = 32'hfff18193; // continue loop addi t3 = t3 - 1
//            instmem[36] = 32'hfe3014e3; // bne to find_max
//            instmem[40] = 32'h002002b3; // store the max address to t5
//            instmem[44] = 32'h00200e23; // store the max value at 28th loc of data mem.
//            instmem[48] = 32'h02e00a6f; // done jump to self loop

////              $readmemh("instructions.mem", instmem);
//        end
//    assign RD = instmem[A];
endmodule