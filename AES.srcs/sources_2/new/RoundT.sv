/**
 * @file RoundT.sv
 * @author Kefan.Liu@outlook.com
 * @brief One Round using T-Box
 * @note
 * In AES128 it has the same period as Keygen
 * In AES192/AES256, it has up to 2 large clock periods 
*/

`include "definitions.svh"

module RoundT (
    input clk1_in, clk2_in, clk3_in, clk3_en, rst_n,

    input AES_TXT key_in,
    input is_final,
    input AES_TXT plain_in,

    output wire AES_TXT cipher_out
);

AES_BOX after_rowshift;
AES_BOX_E after_bytesub_e;
AES_BOX_T after_bytesub; // This variable is used for fit different SystemVerilog standards
assign after_bytesub = AES_BOX_T'(after_bytesub_e);
AES_BOX_T after_colshift;
wire clk_en_rom;
`ifdef KF_USE_EXTRA_CLK_EN
assign clk_en_rom = clk3_en & clk3_in;
`else
assign clk_en_rom = clk3_en;
`endif

RowShift rowshift(AES_BOX'(plain_in), after_rowshift); // re-arrange input
ByteSubT bytesub( // substitute byte
    .clk1_in(clk1_in), 
    .clk2_in(clk2_in), 
    .clk3_en(clk_en_rom), 
    .rst_n(rst_n), 
    .plain_in(after_rowshift), 
    .plain_out(after_bytesub_e) // unable to directly cast for 2-d array using type'()
);
ColShift colshift[3:0](after_bytesub, after_colshift); // re-arrange output
AES_TOX key_tox;
assign key_tox = {>>{key_in}};
AES_TOX cipher_tox;
assign cipher_out = {>>{cipher_tox}};
ColMixT colmixt[3:0](clk1_in, clk2_in, clk3_en, is_final, key_tox, after_colshift, cipher_tox);

endmodule