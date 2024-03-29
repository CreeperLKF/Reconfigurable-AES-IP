/**
 * @file KeyGenRoll.sv
 * @author Kefan.Liu@outlook.com
 * @brief Extend Key
*/

`include "definitions.svh"

`ifdef KF_USE_PIPELINE
module KeyGenRoll #(
    parameter byte rcon
) (
    input clk1_in, clk2_in, clk3_en, rst_n,

    input AES_KEY key_in,

    output AES_KEY key_out
);
`else
module KeyGenRoll(
    input clk1_in, clk2_in, clk3_in, clk3_en, rst_n,

    input byte rcon,
    input AES_KEY key_in,

    output AES_KEY key_out
);
`endif

typedef integer AES_KEY_INT [AES_KEY_SPLIT:0];
wire AES_KEY_INT key_split = AES_KEY_INT'(key_in);
AES_KEY_INT key_split_out;
assign key_out = AES_KEY'(key_split_out);

integer s;

`ifdef KF_USE_ROM
wire clk_en_rom;
`ifdef KF_USE_EXTRA_CLK_EN
assign clk_en_rom = clk3_en & clk3_in;
`else
assign clk_en_rom = clk3_en;
`endif
`ifdef KF_IC
DROM_SBox sbox_1 (
    .clka(clk2_in),    // input wire clka
    .ena(clk_en_rom),      // input wire ena
    .addra(key_split[3][0+:8]),  // input wire [7 : 0] addra
    .douta(s[24+:8]),  // output reg [7 : 0] douta
    .clkb(clk2_in),    // input wire clkb
    .enb(clk_en_rom),      // input wire ena
    .addrb(key_split[3][24+:8]),  // input wire [7 : 0] addrb
    .doutb(s[16+:8])  // output reg [7 : 0] doutb
);
DROM_SBox sbox_2 (
    .clka(clk2_in),    // input wire clka
    .ena(clk_en_rom),      // input wire ena
    .addra(key_split[3][16+:8]),  // input wire [7 : 0] addra
    .douta(s[8+:8]),  // output reg [7 : 0] douta
    .clkb(clk2_in),    // input wire clkb
    .enb(clk_en_rom),      // input wire ena
    .addrb(key_split[3][8+:8]),  // input wire [7 : 0] addrb
    .doutb(s[0+:8])  // output reg [7 : 0] doutb
);
`else
blk_mem_gen_0 u_blk_sbox_1 (
    .clka(clk2_in),    // input wire clka
    .ena(clk_en_rom),      // input wire ena
    .addra(key_split[3][0+:8]),  // input wire [7 : 0] addra
    .douta(s[24+:8]),  // output wire [7 : 0] douta
    .clkb(clk2_in),    // input wire clkb
    .enb(clk_en_rom),      // input wire ena
    .addrb(key_split[3][24+:8]),  // input wire [7 : 0] addrb
    .doutb(s[16+:8])  // output wire [7 : 0] doutb
);
blk_mem_gen_0 u_blk_sbox_2 (
    .clka(clk2_in),    // input wire clka
    .ena(clk_en_rom),      // input wire ena
    .addra(key_split[3][16+:8]),  // input wire [7 : 0] addra
    .douta(s[8+:8]),  // output wire [7 : 0] douta
    .clkb(clk2_in),    // input wire clkb
    .enb(clk_en_rom),      // input wire ena
    .addrb(key_split[3][8+:8]),  // input wire [7 : 0] addrb
    .doutb(s[0+:8])  // output wire [7 : 0] doutb
);
`endif
`else
genvar g_i;
generate
    for (g_i = 0; g_i <= 3; g_i ++) begin
        SBox sbox(clk1_in, rst_n, key_split[3][(((g_i + 1) << 3) & 8'h1f)+:8], s[(((g_i) << 3) & 8'h1f)+:8]);
    end
endgenerate
`endif


function automatic integer unsigned xor_key (byte dep);
    if (dep == 0) return key_split[dep];
    else return xor_key(dep - 1) ^ key_split[dep];
endfunction

// Optimization from DSP design
integer xor_tmp_01, xor_tmp_23;
integer xor_tmp;
always_ff @( posedge clk2_in ) if (clk3_en) xor_tmp_01 <= key_split[0] ^ key_split[1];
always_ff @( posedge clk2_in ) if (clk3_en) xor_tmp_23 <= key_split[2] ^ key_split[3];
always_ff @( posedge clk2_in ) if (clk3_en) xor_tmp <= {24'b0, rcon} ^ s;
// always_ff @( posedge clk2_in ) xor_tmp <= rcon ^ s;
always_ff @( posedge clk2_in ) begin : ff_key_out // 3 xor in fastest clock
    if (clk3_en & ~clk3_in) begin
        key_split_out[0] <= xor_tmp ^ key_split[0];
        key_split_out[1] <= xor_tmp ^ xor_tmp_01;
        key_split_out[2] <= xor_tmp ^ xor_tmp_01 ^ key_split[2];
        key_split_out[3] <= xor_tmp ^ xor_tmp_01 ^ xor_tmp_23;
    end
end

endmodule
