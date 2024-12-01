`timescale 1ns/1ps

module register(data, clk,rst, out, en);
    input signed [31:0] data;
    input clk, rst, en;
    output reg signed [31:0] out;
    reg [31:0] out_next;
    
    always @(posedge clk)begin
        if(rst)
            out <= 32'b0;
        else if(en == 1'b0)
            out <= data;
        else 
            out <= out_next;
    end
    
    always@(*) begin
        out_next = out;
    end
endmodule