`timescale 1ns/1ps

`define  L_T 3'b111
`define  I_T 3'b000
`define  S_T 3'b001
`define  B_T 3'b010
`define  J_T 3'b011
`define  U_T 3'b100
`define  sra 3'b101
`define  slli_srli 3'b110



module Extend(ImmSrc, ImmExt, data);
    input [2:0] ImmSrc;
    input [24:0] data;
    output reg signed [31:0] ImmExt;
    
    always@(*)begin
        case(ImmSrc)
            `L_T: ImmExt = {{20{data[22]}}, data[22:13]};   // last two bits are used for load bytes and load half words.
            `I_T: ImmExt = {{20{data[24]}}, data[24:13]};   // last two bits are used for load bytes and load half words.
            `S_T: ImmExt = {{20{data[24]}}, data[24:18], data[4:0]};
            `B_T:  begin 
                        ImmExt =  
                                            {{22{data[24]}}, data[23:18], data[4:1], 1'b0}; // data[24] is used to jump in odd number of location.
                                                                                             // data[24] ?  {{22{data[23]}}, data[23:18], data[4:1], 1'b1}:
                   end
            `J_T: ImmExt = {{12{data[24]}}, data[12:5], data[13], data[23:14], 1'b0};
            `U_T: ImmExt = {data[24:5], {12{1'b0}}};
            `sra: ImmExt = {{14{1'b0}},{6{1'b0}}, data[17:13]};
            `slli_srli: ImmExt = { {19{1'b0}}, data[17:13]};
            
            default: ImmExt = 32'd0;
        endcase
    end
    
endmodule