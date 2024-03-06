`timescale 10ns / 1ns

`include "../../sources_1/new/definitions.svh"

module AES_tb(
    );

// sys_clk is 25 MHz
reg sys_clk = 1'b1, rst_n = 1'b1;
always #2 sys_clk = ~sys_clk;
initial begin
    rst_n = 1'b0;
    #20 rst_n = 1'b1;
end

integer plain_file, key_file;
byte read_byte, write_byte;
reg [1:0] cmd;
reg ready_out, ok_out;

initial begin
    plain_file = $fopen("/home/linearkf/Code/FPGA/Crypt/AES/AES.srcs/sim_1/new/plain0.txt", "r");
    key_file = $fopen("/home/linearkf/Code/FPGA/Crypt/AES/AES.srcs/sim_1/new/key0.txt", "r");
    cmd = 2'd0;
    #1024
    cmd = 2'd3;
    for (int i = 0; i < 16; i++) begin
        $fscanf(plain_file, "%2x", read_byte);
        #1;
    end
    cmd = 2'd0;
    #8
    cmd = 2'd2;
    for (int i = 0; i < 16; i++) begin
        $fscanf(key_file, "%2x", read_byte);
        #1;
    end
    cmd = 2'd0;
    #8
    cmd = 2'd1;
end

AES_top aes_top(
    .clk_sys(sys_clk), .rst_n(rst_n),
    .data_in(read_byte),
    .cmd_in(cmd),
    
    .data_out(write_byte),
    .ready_out(ready_out),
    .ok_out(ok_out)
);

endmodule
