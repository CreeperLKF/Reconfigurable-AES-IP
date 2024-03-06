/**
 * @file ByteSub.sv
 * @author Kefan.Liu@outlook.com
 * @brief substitute byte as S-Box
*/

`include "definitions.svh"

module ByteSub (
    input clk1_in, clk2_in, clk3_en, rst_n,

    input AES_BOX plain_in,

    output AES_BOX plain_out
);

`ifdef KF_USE_ROM
blk_mem_gen_0 u_blk_sbox_1[7:0] (
    .clka(clk2_in),    // input wire clka
    .ena(clk3_en),      // input wire ena
    .addra(plain_in[7:0]),  // input wire [7 : 0] addra
    .douta(plain_out[7:0]),  // output wire [7 : 0] douta
    .clkb(clk2_in),    // input wire clkb
    .enb(clk3_en),      // input wire ena
    .addrb(plain_in[15:8]),  // input wire [7 : 0] addrb
    .doutb(plain_out[15:8])  // output wire [7 : 0] doutb
);
`else
SBox sbox[15:0] (
    .clk_in(clk2_in),
    .rst_n(rst_n),
    .data_in(plain_in[15:0]),
    .data_out(plain_out[15:0])
);
`endif

endmodule