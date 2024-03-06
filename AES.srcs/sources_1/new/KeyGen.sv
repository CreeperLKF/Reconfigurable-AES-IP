/**
 * @file KeyGen.sv
 * @author Kefan.Liu@outlook.com
 * @brief Extend Key
 * @note
 * In AES128, a round of keygen will generate 4 integers, which is same as encrypt round
 * It consumes 1 large clock now
 * However, in AES192/AES256, the round is extended, which requires about 2 large clock now
*/

`include "definitions.svh"

module KeyGen (
    input clk1_in, clk2_in, clk3_in, clk3_en, rst_n, // u know who
    input AES_KEY key_in, // input key (only used in first round)
    
    output AES_KEY_EXPANDED_K key_ex_out // output key
);

localparam byte RCON[0:9] = { // a table
    8'h01, 8'h02, 8'h04, 8'h08, 8'h10, 8'h20, 8'h40, 8'h80, 8'h1b, 8'h36
};

`ifdef KF_USE_PIPELINE
// pipeline expand
wire AES_KEY_EXPANDED_K key_tmp_in;
assign key_tmp_in[0] = key_in;
assign key_tmp_in[AES_KEY_ROUND:1] = key_ex_out[AES_KEY_ROUND-1'b1:0];

genvar g_i;
generate
    for (g_i = 0; g_i <= AES_KEY_ROUND; g_i ++)
        KeyGenRoll #(
            RCON[g_i]
        ) keygenroll (
            .clk1_in(clk1_in),
            .clk2_in(clk2_in),
            .clk3_en(clk3_en),
            .rst_n(rst_n),
            .key_in(key_tmp_in[g_i]),
            .key_out(key_ex_out[g_i])
        );
endgenerate
`else
// reuse module
bit clk3_en_lst;
always_ff @( posedge clk3_in ) clk3_en_lst <= clk3_en;
wire clk3_en_pos = clk3_en & ~clk3_en_lst;
bit [3:0] rcon_cnt;
always_ff @( posedge clk3_in ) rcon_cnt <= clk3_en ? rcon_cnt + 1'b1 : '0;
wire which = rcon_cnt[0];

wire AES_KEY_EXPANDED_K keygenroll_key_in;
AES_KEY_EXPANDED_K key_tmp;
always_ff @( posedge clk2_in ) begin
    if (clk3_en) // change at finish
        if (clk1_in & clk3_in)
            key_tmp <= key_ex_out;
        else
            key_tmp <= key_tmp;
end
assign keygenroll_key_in = clk3_en_pos ? key_in : key_tmp; // is the first round

KeyGenRoll keygenroll (
    .clk1_in(clk1_in), .clk2_in(clk2_in), .clk3_in(clk3_in), .clk3_en(clk3_en), .rst_n(rst_n),
    .rcon(RCON[rcon_cnt]), .key_in(keygenroll_key_in),
    .key_out(key_ex_out)
);
`endif

endmodule