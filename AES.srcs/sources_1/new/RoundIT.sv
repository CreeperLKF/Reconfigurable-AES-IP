/**
 * @file RoundIT.sv
 * @author Kefan.Liu@outlook.com
 * @brief One Round
 * @note
 * In AES128 it has the same period as Keygen
 * In AES192/AES256, it has up to 2 large clock periods 
*/

`include "definitions.svh"

`ifdef KF_USE_PIPELINE
module RoundIT #(
    parameter bit isFinal = '0
)(
    input clk1_in, clk3_en, rst_n,

    input AES_TXT key_in,
    input AES_TXT plain_in,

    output AES_TXT cipher_out
);

AES_BOX after_bytesub, after_rowshift;
ByteSub bytesub(clk1_in, rst_n, AES_BOX'(plain_in), after_bytesub);
RowShift rowshift(after_bytesub, after_rowshift);

generate
    if (isFinal)
        always_ff @( posedge clk1_in ) begin
            if (clk3_en) cipher_out <= key_in ^ AES_TXT'(after_rowshift);
        end
    else begin
        AES_TXT after_colmix;
        ColMix colmix(AES_TXT'(after_rowshift), after_colmix);
        always_ff @( posedge clk1_in ) begin
            if (clk3_en) cipher_out <= key_in ^ after_colmix;
        end
    end
endgenerate


endmodule
`else
module RoundIT (
    input clk1_in, clk2_in, clk3_in, clk3_en, rst_n,

    input AES_TXT key_in,
    input is_final,
    input AES_TXT plain_in,

    output AES_TXT cipher_out
);

AES_BOX after_bytesub, after_rowshift;
wire clk_en_rom;
`ifdef KF_USE_EXTRA_CLK_EN
assign clk_en_rom = clk3_en & clk3_in;
`else
assign clk_en_rom = clk3_en;
`endif
ByteSub bytesub(clk1_in, clk2_in, clk_en_rom, rst_n, AES_BOX'(plain_in), after_bytesub);
RowShift rowshift(after_bytesub, after_rowshift);

AES_TXT after_colmix;
ColMix colmix(AES_TXT'(after_rowshift), after_colmix);
always_ff @( posedge clk1_in ) begin
    if (clk3_en) cipher_out <= key_in ^ (is_final ? AES_TXT'(after_rowshift) : after_colmix);
end


endmodule
`endif