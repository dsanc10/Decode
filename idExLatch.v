`timescale 1ns / 1ps

module idExLatch(
    input wire clk,
    input wire rst,
    input wire [1:0] ctl_wb,
    input wire [2:0] ctl_mem,
    input wire [3:0] ctl_ex,
    input wire [31:0] npc,
    input wire [31:0] readdata1,
    input wire [31:0] readdata2,
    input wire [31:0] sign_ext,
    input wire [4:0] instr_bits_20_16,
    input wire [4:0] instr_bits_15_11,

    output reg [1:0] wb_out,
    output reg [2:0] mem_out,
    output reg [3:0] ctl_out,
    output reg [31:0] npc_out,
    output reg [31:0] readdata1_out,
    output reg [31:0] readdata2_out,
    output reg [31:0] sign_ext_out,
    output reg [4:0] instr_bits_20_16_out,
    output reg [4:0] instr_bits_15_11_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wb_out <= 0;
            mem_out <= 0;
            ctl_out <= 0;
            npc_out <= 0;
            readdata1_out <= 0;
            readdata2_out <= 0;
            sign_ext_out <= 0;
            instr_bits_20_16_out <= 0;
            instr_bits_15_11_out <= 0;
        end
        else begin
            wb_out <= ctl_wb;
            mem_out <= ctl_mem;
            ctl_out <= ctl_ex;
            npc_out <= npc;
            readdata1_out <= readdata1;
            readdata2_out <= readdata2;
            sign_ext_out <= sign_ext;
            instr_bits_20_16_out <= instr_bits_20_16;
            instr_bits_15_11_out <= instr_bits_15_11;
        end
    end

endmodule
