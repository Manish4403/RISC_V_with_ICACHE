`timescale 1ns/1ps

module DataMem(WD,Adr, A, clk,sw, sh, sb, WE , RD);
//    input [13:0] A;  // because this sofware doesn't support 32 bit size address line.
//    input [31:0] WD;  //WD - write Data
//    input clk;
//    input WE;  //write enable
//    output [31:0]RD;
    
//    integer i;
//    reg [31:0] datamem[0:99];
////    reg [31:0] datamem_next;
////    wire [31:0]adr;
////    assign adr = {A[31:2], 2'b00}; // address is 0, 4 , 8 ... each data is 4 bytes long.



//    assign RD = datamem[A];   // Async read 
//    assign RD1 = datamem[5]; // check for the datat to be stored.
    
    
////    always @(posedge clk)    // Sync write
////    begin
////            datamem[A] <= datamem_next;   // Store the previous value
////    end
    
//    always@(posedge clk)begin
//        if(WE)
//            datamem[A] = WD;
            
//    end
//    initial   // initializing some values (with a gap of 4)
//        begin
//            datamem[0] = 32'h9F5D4A6E;
//            datamem[4] = 32'he;
//            datamem[8] = 32'h0000000a;
//            datamem[12] = 32'h0000000a;
//            datamem[28] = 32'h0;// Max value will be stored here.
//            datamem[30] = 32'h5;
//            datamem[34] = 32'ha;
//            datamem[38] = 32'h6;
//            datamem[42] = 32'h2;
//            datamem[46] = 32'h8;
//            datamem[50] = 32'h9;
//            datamem[54] = 32'h7;
//            datamem[58] = 32'h3;
//            datamem[62] = 32'h4;
//            datamem[66] = 32'h6;
//            datamem[70] = 32'h6;
            
////              $readmemb("data.mem", datamem);
//        end

    input [5:0] Adr;
    input [31:0] WD;
    input [1:0] A;
    input sw, sh, WE;
    input sb, clk;
    reg [31:0] x;
    output signed [31:0] RD;
    

    
    reg [1:0]T;
    reg U,V;
    reg WE3, WE2, WE1, WE0;
    
    //********************************************************************Decoder-Logic**********************************************//
    
    always@(*) begin
        
       //Mux control signal.
       V = 1'b0;
       U = 1'b0;
       T = 2'b00;
       
       //write enable.

       WE3 = 1'b0;
       WE2 = 1'b0; 
       WE1 = 1'b0; 
       WE0 = 1'b0;

       
       //Store word.
       if(WE) begin
       if(sw ) 
           begin
               WE3 = 1'b1;
               WE2 = 1'b1; 
               WE1 = 1'b1; 
               WE0 = 1'b1; 
               V = 1'b1;
               U = 1'b1;
               T = 2'b10;
           end
        //Store half word.
        if(sh) 
            begin
               if(A == 2'b01)
                begin
                    T = 2'b01;
                    WE2 = 1'b1; 
                    WE3 = 1'b1;
                end
               else 
                    begin
                        V = 1'b1;
                        WE1 = 1'b1;
                        WE0 = 1'b1;
                    end
            end
         //Store bytes.
        if(sb)
            begin
                case(A)
                    2'b00: WE0 = 1'b1;
                    2'b01: WE1 = 1'b1;
                    2'b10: WE2 = 1'b1;
                    2'b11: WE3 = 1'b1;
                endcase
//                  if(A == 2'b00)
//                        WE0 = 1'b0;
//                  else if(A == 2'b01)
//                        WE1 = 1'b0;
//                  else if(A == 2'b10)
//                        WE2 = 1'b0;
//                  else
//                        WE3 = 1'b0;
            end
       end
             
    end
    
    //**********************************************************************Mux***************************************************//
    
    always@(*) begin
        
        x[7:0] = WD[7:0];
        
        //For T.
        if(T == 2'b10)
            x[31:24] = WD[31:24];
        else if(T == 2'b01)
            x[31:24] = WD[15:8];
        else
            x[31:24] = WD[7:0];
            
            
        //For U.
        if(U)
            x[23:16] = WD[23:16];
        else
            x[23:16] = WD[7:0];
        
        //For V.    
        if(V)
            x[15:8] = WD[15:8];
        else
            x[15:8] = WD[7:0];
           
        
    end
//******************************************Memory_Module************************//
     D7_D0 D7_D0
     (
        .a(Adr),
        .d(x[7:0]),
        .clk(clk),
        .we(WE0),
        .spo(RD[7:0])
     );
    
    D15_D8 D15_D8
     (
        .a(Adr),
        .d(x[15:8]),
        .clk(clk),
        .we(WE1),
        .spo(RD[15:8])
     );
  
  D23_D16 D23_D16
     (
        .a(Adr),
        .d(x[23:16]),
        .clk(clk),
        .we(WE2),
        .spo(RD[23:16])
     );
  
  D31_D24 D31_D24
     (
        .a(Adr),
        .d(x[31:24]),
        .clk(clk),
        .we(WE3),
        .spo(RD[31:24])
     );
endmodule