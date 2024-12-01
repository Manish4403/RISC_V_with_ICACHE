`timescale 1ns/1ps

module RISC_DATAPATH(clk, rst, MemwriteD, 
                     AluControlSrcD, alusrcD, ImmsrcD, RegwriteD,
                     ALU_branch, op, funct3, funct7,jalD, jalrD, 
                     
                     //only for output
                    LoadSrcD, ResultSrcD,
                    pcsrc, StoreSrcD, jalE, jalrE, 
                    reg_loc
                    );
output [6:0]op;
output signed [2:0] funct3;
output ALU_branch, funct7;
output jalE, jalrE;

input clk, rst;
input  [2:0]  ResultSrcD;
input  [1:0] pcsrc;
input [2:0] StoreSrcD;
input [4:0] LoadSrcD;

input jalD, jalrD;
input signed [2:0]  ImmsrcD;
input signed [3:0] AluControlSrcD;
input RegwriteD, MemwriteD, alusrcD; 

// Adress for load and store half bytes
wire [1:0] AdrE, AdrM; 
wire signed [31:0] ReadDataSem;
//wire [4:0] Rs1D,
//            Rs2D,
//            RdD;

//External wires to see output.
wire signed [31:0] result_load_reg;
wire signed [31:0] resultW;


output [15:0] reg_loc;
wire signed [31:0] srcA, srcB;
            

     //Hazard unit wires
wire StallF, StallD, FlushD, FlushE;
wire [1:0] ForwardAE, ForwardBE;
//Inst stall
wire  IF_stall;
wire ALU_branchF, jalF, jalX;

//Pipeline (Control path wires)
wire RegwriteE, MemwriteE, alusrcE,
     RegwriteM, MemwriteM,
     RegwriteW;
   
wire signed [2:0] ResultSrcE,
           ResultSrcM,
           ResultSrcW;
       
wire [4:0] LoadSrcE, LoadSrcM;
           
wire signed [2:0]  StoreSrcE, StoreSrcM;
wire signed [3:0]  AluControlSrcE;
            
//Datapath wires (Pipeline)
wire signed [4:0]  Rs1E, Rs2E, RdE,
            RdM,
            RdW;
            
wire [31:0] InstrF, InstrD;

wire signed [31:0] PCF, PCPlus4F ,PCN, PCS,PCI,
            PCD, PCPlus4D, ImmextD, RD1D, RD2D,
            PCE, PCPlus4E, ImmextE, RD1E, RD2E, AluResultE, auipcE, srcBE,
            PCPlus4M, ImmextM, auipcM, WriteDataM, AluResultM, ReadDataM,
            PCPlus4W, ImmextW, auipcW, ReadDataW, AluResultW, pc_next, PC_TargetE;
            
 assign auipcE = PC_TargetE;
         
              
             
//MUX for pc selection
Mux4to1 PC_mux(.in0(PCPlus4F), .in1(PC_TargetE), .in2(AluResultE),
               .sel(pcsrc), .out(pc_next));
               


// register for pc
PC_register PC_register(.data(pc_next), .clk(clk), .rst(rst), .out(PCF), .en(StallF), .Inst_stall(IF_stall),
                        .ALU_branch(ALU_branch), .ALU_branchF(ALU_branchF));
//PC + 4 adder
adder PC_plus4_adder(.in1(PCF),  .in2(32'd1), .result(PCPlus4F));




Mux2to1 pc_forward(.in1(PC_TargetE), .in0(PCF), .sel(jalX), .out(PCI));                   //PC forward mux from PC_Target from execute stage.  

//Instruction memory
Icache Inst_Memory(
                         .clk(clk),
                         .Adr(PCI),
                         .Branch(ALU_branchF),
                         .Data_out(InstrF),
                         .Stall_IF(IF_stall), 
                         .stallD(StallD),
                         .jalD(jalE)
                         );


///********************* pc stall  *************************////


stall_PC stall_PC(                                      // PCF is stalled for a cycle.
                    .clk(clk), .data(PCF),
                    .rst(rst),
                    .out(PCN),
                    .en(1'b0)
);

Jal_stall jal_stall(                                                // jalD is stalled for 3 cycles to get a correct operations
                    .clk(clk), .data(jalD),
                    .rst(rst),
                    .out(jalF),
                    .en(1'b0),
                    .out_x(jalX)
                    );

Mux2to1 PCE_mux(.in1(PCN), .in0(PCF), .sel(jalF), .out(PCS));           // Used to delay the PCF.

//*********              end                      **********//





//IF and ID Register.
RegIF_ID RegIF_ID(
                  .instrF(InstrF), .PCF(PCS), .PCplus4F(PCPlus4F), .clk(clk), 
                  .rst(rst), .clr(FlushD), .en(StallD),
                  .instrD(InstrD), .PCD(PCD), .PCPlus4D(PCPlus4D), 
                  .Inst_flush(ALU_branchF)
                  );

//Register File
RegisterFile RegisterFile(.A1(InstrD[19:15]), .A2(InstrD[24:20]), .A3(RdW), 
                          .WD3(resultW), .clk(clk), .WE3(RegwriteW), .RD1(RD1D), .RD2(RD2D),
                          .RD3(reg_loc));
                          
//Sign extension
Extend Extend(.ImmSrc(ImmsrcD), .ImmExt(ImmextD), .data(InstrD[31:7]));

//ID and EX Register

RegID_EX RegID_EX(
//output
.RegwriteE(RegwriteE), .MemwriteE(MemwriteE), .alusrcE(alusrcE), .resultsrcE(ResultSrcE), .load_srcE(LoadSrcE),
.store_srcE(StoreSrcE), .alucontrolE(AluControlSrcE), .Rd1E(RD1E), .Rd2E(RD2E), .ImmextE(ImmextE), 
.Pcplus4E(PCPlus4E), .PcE(PCE), .Rs1E(Rs1E), .Rs2E(Rs2E), .RdE(RdE), .clk(clk), .clr(FlushE), .rst(rst), 
.jalE(jalE), .jalrE(jalrE), .AdrE(AdrE),
//input
.miss_flush(1'b0),
.RegwriteD(RegwriteD), .MemwriteD(MemwriteD), .alusrcD(alusrcD), .resultsrcD(ResultSrcD), .load_srcD(LoadSrcD),
.store_srcD(StoreSrcD), .alucontrolD(AluControlSrcD), .Rd1D(RD1D), .Rd2D(RD2D), .ImmextD(ImmextD), .Pcplus4D(PCPlus4D), 
.PcD(PCD), .Rs1D(InstrD[19:15]), .Rs2D(InstrD[24:20]), .RdD(InstrD[11:7]), .jalD(jalD), .jalrD(jalrD),
.AdrD(InstrD[31:30])
);






//Mux for harzard rs1
forward_mux ForwardR1(.in0(RD1E), .in1(resultW), .in2(AluResultM), .in3(ImmextM),
               .sel(ForwardAE), .out(srcA));
               
//Mux for harzard rs2
forward_mux ForwardR2(.in0(RD2E), .in1(resultW), .in2(AluResultM), .in3(ImmextM),
               .sel(ForwardBE), .out(srcB));
               
//MUX for alu selection
Mux2to1 srcB_mux(.in1(ImmextE), .in0(srcB), .sel(alusrcE), .out(srcBE));

//ALU
alu ALU(.A(srcA), .B(srcBE), .Result(AluResultE), .ALUControl(AluControlSrcE), .ALU_branch(ALU_branch));

//PC target adder
adder PC_Target_Adder(.in1(PCE),  .in2(ImmextE), .result(PC_TargetE));


               
// EX and MM Register.
RegEX_MM RegEX_MM(
                  .clk(clk), .rst(rst), .regwriteE(RegwriteE), .memwriteE(MemwriteE), .rdE(RdE), 
                  .aluresultE(AluResultE), .writeDataE(srcB), .auipcE(auipcE),
                  .immextE(ImmextE), .pcplus4E(PCPlus4E), .resultsrcE(ResultSrcE), .loadsrcE(LoadSrcE), 
                  .StoreSrcE(StoreSrcE), .AdrE(AdrE),
                 //output
                 .regwriteM(RegwriteM), .memwriteM(MemwriteM), .rdM(RdM), .aluresultM(AluResultM), 
                 .writeDataM(WriteDataM), .auipcM(auipcM), .immextM(ImmextM), .pcplus4M(PCPlus4M)
                 , .resultsrcM(ResultSrcM), .loadsrcM(LoadSrcM), .StoreSrcM(StoreSrcM), .AdrM(AdrM)
                 ); 
//******************************************************Data_mem********************************************//               


//Data Memory
DataMem DataMem(
                .WD(WriteDataM), .Adr(AluResultM[5:0]),.A(AdrM), 
                .clk(clk), .sw(StoreSrcM[2]), .sh(StoreSrcM[1]), .sb(StoreSrcM[0]), .RD(ReadDataSem),
                .WE(MemwriteM)
                );
// Load Unit
Load_Unit Load_Unit(
            .data_in(ReadDataSem),
            .lb(LoadSrcM[3]), .lbu(LoadSrcM[4]), 
            .lh(LoadSrcM[1]), .lhu(LoadSrcM[2]),
            .lw(LoadSrcM[0]),
            .A(AdrM),
            .Data_out(ReadDataM)
            );

//********************************************************END Data MEM**************************************//

//MM and WB Register
RegMM_WB RegMM_WB(.clk(clk), .rst(rst), .regwriteM(RegwriteM), .rdM(RdM), .aluresultM(AluResultM), .readDataM(ReadDataM), 
                  .auipcM(auipcM), .immextM(ImmextM), .pcplus4M(PCPlus4M), .resultsrcM(ResultSrcM),
                 //output
                 .regwriteW(RegwriteW), .rdW(RdW), .aluresultW(AluResultW), .readDataW(ReadDataW), .auipcW(auipcW),
                 .immextW(ImmextW), .pcplus4W(PCPlus4W), .resultsrcW(ResultSrcW)
                 );
                  
//// Load register with en.
register Load_register(.data(ReadDataW), .clk(clk),.rst(rst), .out(result_load_reg), .en(1'b0));

//Result MUX
mux8to1 Result_mux(.in0(AluResultW), .in1(result_load_reg), .in2(PCPlus4W), .in3(ImmextW), 
               .in4(auipcW),.sel(ResultSrcW), .result(resultW));
               
//Hazard Unit
Hazard_unit Hazard_unit(.RegwriteM(RegwriteM), .RegwriteW(RegwriteW), .Rs1E(Rs1E), .Rs2E(Rs2E), .RdM(RdM),
                   .forwardAE(ForwardAE), .forwardBE(ForwardBE), .resultsrcE(ResultSrcE), .stallF(StallF),
                   .stallD(StallD), .flushE(FlushE), .flushD(FlushD), .Rs1D(InstrD[19:15]), .Rs2D(InstrD[24:20]),
                   .RdW(RdW), .RdE(RdE), .Branch(ALU_branch), .jalD(jalD)
                   );


                     
assign op = InstrD[6:0];
assign funct3 = InstrD[14:12];
assign funct7 = InstrD[30];
//assign AdrD = InstrD[31:30];
//assign Rs1D = InstrD[19:15];
//assign Rs2D = InstrD[24:20];
//assign RdD = InstrD[11:7];

endmodule