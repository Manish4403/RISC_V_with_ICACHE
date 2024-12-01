`timescale 1ns/1ps





module Icache(
    clk,
    Adr,
    Branch,
    Data_out,
    Stall_IF,
    stallD, jalD
    );
    
    
    input clk, stallD, jalD;
    input Branch;
    input[31:0] Adr;
    output reg [31:0] Data_out;
    
    //Out port
    parameter no_of_mem_block_size = 128;
    wire [no_of_mem_block_size - 1 : 0] D_out;
    
//    reg [127:0] Data_in;
    
    // Define Cache necessary features 
    parameter block_size = 32;
    parameter no_of_l1_blocks = 32;
    parameter l1_block_bit_size = 128; // 4 words 32 * 4
    parameter no_of_address_bits = 32;
    parameter no_of_l1_index_bits = 6;
    parameter no_of_mem_addr_bits = 6;
    parameter no_of_blk_offset_bits = 2;
    parameter no_of_l1_tag_bits = 24;
    parameter no_of_main_mem_blocks = 64;
    parameter offset_hold = 4;
    
    reg [l1_block_bit_size - 1 : 0] I_cache [0 : no_of_l1_blocks - 1];
    reg [no_of_l1_tag_bits - 1 : 0] I_cache_tag_bits [0 : no_of_l1_blocks - 1];
    reg Valid_bits [0 : no_of_l1_blocks - 1];
    reg RE;                                                 //Read and write enable.
    //Eviction variables
//    reg [no_of_l1_tag_bits - 1 : 0] Evict_tag;
    
    initial 
    begin: initization_of_cache
        integer i;
        for(i = 0; i < no_of_l1_blocks; i = i + 1)  begin
            Valid_bits[i] = 0;
            I_cache_tag_bits[i] = 0;
        end
    end
    // End cache definition.
    
    //Defining variables
    reg [no_of_address_bits - 1 :0]Stored_address;
    reg [no_of_l1_index_bits - 1 : 0] Index;
    reg [no_of_l1_tag_bits - 1 : 0] Tag;
    reg Hit;
    reg [1:0] offset_bit;
    reg [no_of_mem_addr_bits - 1 : 0] mem_block_address;
    
    
    // Stal signals
    output reg Stall_IF;
    
    //Branch delay
    
    reg Wait;
    

    
    always@(posedge clk) begin
        Wait = 1'b0;
        RE = 1'b0;
        
        Stall_IF = 1'b0; 
        
        if(~(Wait || stallD))
            Stored_address = Adr;
        mem_block_address = Stored_address >> no_of_blk_offset_bits % no_of_main_mem_blocks; //address index in main memory.
        
        //Index calculation and hold offset if there is branch or jump.
//        if(~BranchD) begin
         if(~(jalD || Branch))
            offset_bit = Stored_address % no_of_l1_blocks; //Block number in cache.
        if(Stored_address % offset_hold == 0)
            Index = mem_block_address % no_of_l1_blocks;   //Cache index
        else if(Branch)
            Index = mem_block_address % no_of_l1_blocks;
            

            
        Tag = mem_block_address >> no_of_l1_index_bits; //Cache tag
        
        
        if(Valid_bits[Index] && I_cache_tag_bits[Index] == Tag) begin
            RE = 1'b1;
            Hit = 1'b1;
            Data_out = I_cache[Index][((offset_bit + 1) * block_size -1) -: block_size];
            Stall_IF = 1'b0; 
            Wait = 1'b0;

        end
        else begin
            
                Hit = 1'b0;
                RE = 1'b1;
                Wait = 1'b1;
                Stall_IF = 1'b1; 
                I_cache[Index] = D_out;
                Valid_bits[Index] = 1'b1;
                I_cache_tag_bits[Index] = Tag;
                Data_out = I_cache[Index][((offset_bit + 1) * block_size -1) -: block_size];

//            else begin                  //Eviction. 
//                    Evict_tag = I_cache_tag_bits[Index];
//                    Hit = 1'b0;
//                    RE = 1'b0;
//                    WE = 1'b1;
//                    Wait = 1'b1;
//                    Stall_IF = 1'b1; 
//                    Data_in = I_cache[Index][((offset_bit + 1) * block_size -1) -: block_size];
//                    mem_block_address = {Evict_tag,Index};
//                    I_cache[Index][((offset_bit + 1) * block_size -1) -: block_size] = D_out;
//                    I_cache_tag_bits[Index] = Tag;
//                    Valid_bits[Index] = 1'b1;
//                    Data_out = I_cache[Index][((offset_bit + 1) * block_size -1) -: block_size];
//            end
        end
    end
    
    //***************Main Memory*************//
    blk_mem_gen_0 Main_Memory(
                        .clka(clk), 
                        .ena(RE),
                        .addra(mem_block_address),
                        .douta(D_out)
                        );
    
    
    
    
endmodule
