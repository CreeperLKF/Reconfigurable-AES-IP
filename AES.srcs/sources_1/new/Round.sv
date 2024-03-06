/**
 * @file Round.sv
 * @author Kefan.Liu@outlook.com
 * @brief Round operation
*/

`include "definitions.svh"

module Round (
    input clk1_in, clk2_in, clk3_in, clk3_en, rst_n, // ukw
    input AES_KEY_EXPANDED_T key_ex_in, // expanded key input
    input AES_KEY key_in, // the original key (used in the first round)
    input AES_TXT plain_in, // the plain text (used in the first round)

    output AES_TXT cipher_out, // the encrypted text
    output reg ok_out // if the encryption is done
);

`ifdef KF_USE_PIPELINE
AES_KEY_EXPANDED_T cipher_tmp;
assign cipher_tmp[0] = key_in ^ plain_in; // Round 0 optimized out

RoundIT #('0) roundit[AES_TXT_ROUND:1](clk1_in, rst_n, key_ex_in[AES_TXT_ROUND-1'b1:0], 
    cipher_tmp[AES_TXT_ROUND-1'b1:0], cipher_tmp[AES_TXT_ROUND:1]);

RoundIT #('1) roundfin(clk1_in, rst_n, key_ex_in[AES_TXT_ROUND], cipher_tmp[AES_TXT_ROUND], cipher_out);
`else
bit clk3_en_lst; // delay
always_ff @( posedge clk3_in ) clk3_en_lst <= clk3_en;
wire clk3_en_pos = clk3_en & ~clk3_en_lst; // if the first clock of clk3_en
reg clk3_en_pos_1;
always_ff @( posedge clk3_in ) if (clk3_en) clk3_en_pos_1 <= clk3_en_pos; // delay

AES_KEY_EXPANDED_T cipher_tmp;
bit [3:0] round_cnt;
wire which = round_cnt[0];
always_ff @( posedge clk3_in ) begin
    if (clk3_en) // the current round
        round_cnt <= &round_cnt ? round_cnt : round_cnt + 1'b1;
    else
        round_cnt <= '0;
end
reg is_final;
always_ff @( posedge clk2_in ) if (clk3_en) is_final <= round_cnt == AES_TXT_ROUND + 1'b1;
always_ff @( posedge clk3_in ) begin : ff_out
    if (!rst_n) begin // output
        cipher_out <= '0;
        ok_out <= 1'b0;
    end else if (clk3_en) begin
        if (round_cnt == AES_TXT_ROUND + 2'd2) begin
            cipher_out <= cipher_tmp; // output latched
            ok_out <= 1'b1;
        end else begin
            cipher_out <= cipher_out;
            ok_out <= 1'b0;
        end
    end else begin
        cipher_out <= cipher_out;
        ok_out <= 1'b0;
    end
end

wire AES_TXT roundit_plain_in = clk3_en_pos_1 ? key_in ^ plain_in : cipher_tmp;
wire AES_TXT roundit_cipher_out;
always_ff @( posedge clk2_in ) begin
    if (clk3_en) // latch the input
        if (clk1_in & clk3_in)
            cipher_tmp <= roundit_cipher_out;
        else
            cipher_tmp <= cipher_tmp;
end

`ifdef KF_USE_TBOX
RoundT roundit( // The same interface
`else
RoundIT roundit(
`endif
    .clk1_in(clk1_in), 
    .clk2_in(clk2_in), 
    .clk3_in(clk3_in), 
    .clk3_en(clk3_en), 
    .rst_n(rst_n), 
    .is_final(is_final),
    .key_in(key_ex_in), 
    .plain_in(roundit_plain_in),
    .cipher_out(roundit_cipher_out)
);
`endif

endmodule