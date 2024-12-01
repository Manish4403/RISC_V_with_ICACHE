`timescale 1ns/1ps

module RISC_V(clk, rst,reg_loc, seven_seg_out, Anode_Activate);
            
  clk_wiz_0 inst
  (
  // Clock out ports  
  .clk_out1(clk_out1),
  // Status and control signals               
  .reset(reset), 
 // Clock in ports
  .clk_in1(clk_in1)
  );
   assign clk_in1 = clk;
   assign reset = rst;
    
    input clk, rst;
    output [15:0] reg_loc;
    output reg [3:0]Anode_Activate;
    output reg [6:0]seven_seg_out;
            
    wire [4:0] LoadSrcD;       
    wire [2:0]  ResultSrcD;
    wire [3:0] AluControlSrcD;
    wire [2:0] funct3, ImmsrcD;
    wire [1:0] pcsrc;
    wire [2:0] StoreSrcD;
    wire [6:0] op;
    wire MemwriteD, alusrcD, RegwriteD, funct7, ALU_branch;
    wire jalD, jalrD,
         jalE, jalrE;
         
        /*******************************************/
reg [15:0]seg_display_custom_no;            //the cutom number formed by concatenating the 4 BCD numbers for the 4 LEDs
reg [3:0] digit_bcd;                        //The BCD for a digit
reg [1:0] anode_no;                         //THe high or low for a 7 segment display
reg [19:0] refresh;                         //The counter for activating the four 7 segment displays one by one


reg [3:0] a1;           //BCD for first 7 segment display           //the leftmost is considered first here
reg [3:0] a2;           //BCD for second 7 segment display
reg [3:0] a3;           //BCD for third 7 segment display
reg [3:0] a4;           //BCD for fourth 7 segment display

//always block for implementing slow clock and BCD display
always @(posedge clk_out1)
begin
    //////////////////////////////////////////////////////
    a1=(reg_loc>9)?1:0;             //THe first digit of BCD for output data would be 1 if output data > 9 or 0 otherwise
    a2=reg_loc%10;                  //THe second digit of BCD for output data would be its modulo with 10                          //THe second digit of BCD for input data would be its modulo with 10
    seg_display_custom_no={a1,a2,a3,a4};       //Concatenating a1, a2, a3, a4 to get the concatenated BCD number for all four 7 segment displays
    refresh <= refresh + 1;                     //increment the refresh counter in every clock
    anode_no = refresh[19:18];                  //Take the 2 most significant bits in refresh counter to decide which 7 segment display would be active at that time
    case(anode_no)
    //Note that the 7 segment displays are active low here
    2'b00: begin
        Anode_Activate = 4'b0111; 
        // LED 1 is active and rest three LEDs inactive
        digit_bcd = seg_display_custom_no[15:12];
        //the 4 digits of the concated number for the specific 7 segment display
          end
    2'b01: begin
        Anode_Activate = 4'b1011; 
        // LED 2 is active and rest three LEDs inactive
        digit_bcd = seg_display_custom_no[11:8];
        //the 4 digits of the concated number for the specific 7 segment display
          end
    2'b10: begin
        Anode_Activate = 4'b1101; 
        // LED 3 is active and rest three LEDs inactive
        digit_bcd = seg_display_custom_no[7:4];
        //the 4 digits of the concated number for the specific 7 segment display
            end
    2'b11: begin
        Anode_Activate = 4'b1110; 
        // LED 4 is active and rest three LEDs inactive
        digit_bcd = seg_display_custom_no[3:0];
        //the 4 digits of the concated number for the specific 7 segment display
           end
    endcase
    //code for getting the 7 segment binary according to the 4 bit BCD
    case(digit_bcd)
    4'b0000: seven_seg_out=7'b1000000; //0
    4'b0001: seven_seg_out=7'b1111001; //1  
    4'b0010: seven_seg_out=7'b0100100; //2
    4'b0011: seven_seg_out=7'b0110000; //3
    4'b0100: seven_seg_out=7'b0011001; //4
    4'b0101: seven_seg_out=7'b0010010; //5
    4'b0110: seven_seg_out=7'b0000010; //6
    4'b0111: seven_seg_out=7'b1111000; //7
    4'b1000: seven_seg_out=7'b0000000; //8
    4'b1001: seven_seg_out=7'b0010000; //9
    endcase
    end
    
    /*********************************************/
    
    RISC_DATAPATH DATAPATH(clk_out1, rst, MemwriteD, 
                     AluControlSrcD, alusrcD, ImmsrcD, RegwriteD,
                     ALU_branch, op, funct3, funct7,jalD, jalrD,
                    
                     //only for output
                    LoadSrcD, ResultSrcD,
                    pcsrc, StoreSrcD, jalE, jalrE, 
                    reg_loc);

    
    Controller Contro_Unit(.op(op), .funct3(funct3), .funct7(funct7), 
                        .pcsrc(pcsrc), .resultsrc(ResultSrcD), 
                        .memwrite(MemwriteD), .alucontrol(AluControlSrcD), .alusrc(alusrcD),
                        .immsrc(ImmsrcD), .regwrite(RegwriteD), .load_src(LoadSrcD), .store_src(StoreSrcD), 
                        
                        .jalD(jalD), .jalrD(jalrD), 
                        .jalE(jalE), .jalrE(jalrE),
                        .branch(ALU_branch));
    
     
endmodule