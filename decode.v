`timescale 1ns / 1ps

module decode(
    input wire clk,
    input wire rst,
    input wire wb_reg_write,
    input wire [4:0] wb_write_reg_location,
    input wire [31:0] mem_wb_write_data,
    input wire [31:0] if_id_instr,
    input wire [31:0] if_id_npc,

    output wire [1:0] id_ex_wb,
    output wire [2:0] id_ex_mem,
    output wire [3:0] id_ex_execute,
    output wire [31:0] id_ex_npc,
    output wire [31:0] id_ex_readdata1,
    output wire [31:0] id_ex_readdata2,
    output wire [31:0] id_ex_sign_ext,
    output wire [4:0] id_ex_instr_bits_20_16,
    output wire [4:0] id_ex_instr_bits_15_11
);

    wire [31:0] sign_ext_internal;
    wire [31:0] readdata1_internal;
    wire [31:0] readdata2_internal;

    wire [1:0] wb_internal;
    wire [2:0] mem_internal;
    wire [3:0] ex_internal;

    // Sign Extension
    signExtend SE0 (
        .immediate(if_id_instr[15:0]),
        .extended(sign_ext_internal)
    );

    // Register File
    regfile rf0 (
        .clk(clk),
        .rst(rst),
        .regwrite(wb_reg_write),
        .rs(if_id_instr[25:21]),
        .rt(if_id_instr[20:16]),
        .rd(wb_write_reg_location),
        .writedata(mem_wb_write_data),
        .A_readdata1(readdata1_internal),
        .B_readdata2(readdata2_internal)
    );

    // Control Unit
    control c0 (
        .clk(clk),
        .rst(rst),
        .opcode(if_id_instr[31:26]),
        .wb(wb_internal),
        .mem(mem_internal),
        .ex(ex_internal)
    );

    // ID/EX Latch
    idExLatch iEL0 (
        .clk(clk),
        .rst(rst),
        .ctl_wb(wb_internal),
        .ctl_mem(mem_internal),
        .ctl_ex(ex_internal),
        .npc(if_id_npc),
        .readdata1(readdata1_internal),
        .readdata2(readdata2_internal),
        .sign_ext(sign_ext_internal),
        .instr_bits_20_16(if_id_instr[20:16]),
        .instr_bits_15_11(if_id_instr[15:11]),

        .wb_out(id_ex_wb),
        .mem_out(id_ex_mem),
        .ctl_out(id_ex_execute),
        .npc_out(id_ex_npc),
        .readdata1_out(id_ex_readdata1),
        .readdata2_out(id_ex_readdata2),
        .sign_ext_out(id_ex_sign_ext),
        .instr_bits_20_16_out(id_ex_instr_bits_20_16),
        .instr_bits_15_11_out(id_ex_instr_bits_15_11)
    );

endmodule
