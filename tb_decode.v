`timescale 1ns / 1ps

module tb_decode;

    reg clk = 0;
    reg rst = 1;
    reg wb_reg_write = 0;
    reg [4:0] wb_write_reg_location = 0;
    reg [31:0] mem_wb_write_data = 0;
    reg [31:0] if_id_instr = 0;
    reg [31:0] if_id_npc = 0;

    wire [1:0] id_ex_wb;
    wire [2:0] id_ex_mem;
    wire [3:0] id_ex_execute;
    wire [31:0] id_ex_npc;
    wire [31:0] id_ex_readdata1;
    wire [31:0] id_ex_readdata2;
    wire [31:0] id_ex_sign_ext;
    wire [4:0] id_ex_instr_bits_20_16;
    wire [4:0] id_ex_instr_bits_15_11;

    decode dut (
        .clk(clk),
        .rst(rst),
        .wb_reg_write(wb_reg_write),
        .wb_write_reg_location(wb_write_reg_location),
        .mem_wb_write_data(mem_wb_write_data),
        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc),
        .id_ex_wb(id_ex_wb),
        .id_ex_mem(id_ex_mem),
        .id_ex_execute(id_ex_execute),
        .id_ex_npc(id_ex_npc),
        .id_ex_readdata1(id_ex_readdata1),
        .id_ex_readdata2(id_ex_readdata2),
        .id_ex_sign_ext(id_ex_sign_ext),
        .id_ex_instr_bits_20_16(id_ex_instr_bits_20_16),
        .id_ex_instr_bits_15_11(id_ex_instr_bits_15_11)
    );

    always #5 clk = ~clk;

    initial begin

        // Reset
        #10;
        rst = 0;

        // Write 10 into register 1
        wb_reg_write = 1;
        wb_write_reg_location = 5'd1;
        mem_wb_write_data = 32'd10;

        #10;

        // Write 20 into register 2
        wb_write_reg_location = 5'd2;
        mem_wb_write_data = 32'd20;

        #10;

        wb_reg_write = 0;

        // R-format
        if_id_instr = {6'h00, 5'd1, 5'd2, 5'd3, 5'd0, 6'h20};
        if_id_npc = 32'h1004;

        #10;

        // LW
        if_id_instr = {6'h23, 5'd1, 5'd4, 16'hFFF8};
        if_id_npc = 32'h1008;

        #10;

        // SW
        if_id_instr = {6'h2B, 5'd1, 5'd2, 16'd12};
        if_id_npc = 32'h100C;

        #10;

        // BEQ
        if_id_instr = {6'h04, 5'd1, 5'd2, 16'hFFFC};
        if_id_npc = 32'h1010;

        #10;

        // Register zero test
        wb_reg_write = 1;
        wb_write_reg_location = 5'd0;
        mem_wb_write_data = 32'd50;

        if_id_instr = {6'h23, 5'd0, 5'd0, 16'd1};
        if_id_npc = 32'h1014;

        #20;

        $finish;

    end

endmodule
