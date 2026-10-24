`timescale 1ns / 1ps

module regfile(
    input wire clk,
    input wire rst,
    input wire regwrite,
    input wire [4:0] rs,
    input wire [4:0] rt,
    input wire [4:0] rd,
    input wire [31:0] writedata,
    output wire [31:0] A_readdata1,
    output wire [31:0] B_readdata2
);

    reg [31:0] registers [0:31];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (regwrite && rd != 5'd0) begin
            registers[rd] <= writedata;
        end
    end

    assign A_readdata1 = (rs == 5'd0) ? 32'b0 : registers[rs];
    assign B_readdata2 = (rt == 5'd0) ? 32'b0 : registers[rt];

endmodule
