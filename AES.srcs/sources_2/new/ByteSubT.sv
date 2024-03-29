/**
 * @file ByteSubT.sv
 * @author Kefan.Liu@outlook.com
 * @brief substitute byte as T-Box
*/

`include "definitions.svh"

module ByteSubT (
    input clk1_in, clk2_in, clk3_en, rst_n, // YKW

    input AES_BOX plain_in, // text input

    output AES_BOX_E plain_out // text after tbox
);

`ifdef KF_IC
DROM_TBox tbox[7:0] (
  .clka(clk2_in),    // input wire clka
  .ena(clk3_en),      // input wire ena
  .addra(plain_in[7:0]),  // input wire [7 : 0] addra
  .douta(plain_out[7:0]),  // output reg [31 : 0] douta
  .clkb(clk2_in),    // input wire clkb
  .enb(clk3_en),      // input wire enb
  .addrb(plain_in[15:8]),  // input wire [7 : 0] addrb
  .doutb(plain_out[15:8])  // output reg [31 : 0] doutb
);
`else
blk_mem_gen_t0 u_blk_tbox[7:0] (
  .clka(clk2_in),    // input wire clka
  .ena(clk3_en),      // input wire ena
  .addra(plain_in[7:0]),  // input wire [7 : 0] addra
  .douta(plain_out[7:0]),  // output wire [31 : 0] douta
  .clkb(clk2_in),    // input wire clkb
  .enb(clk3_en),      // input wire enb
  .addrb(plain_in[15:8]),  // input wire [7 : 0] addrb
  .doutb(plain_out[15:8])  // output wire [31 : 0] doutb
);
`endif

endmodule