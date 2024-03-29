/**
 * @file AES_eng.sv
 * @author Kefan.Liu@outlook.com
 * @brief The AES engine.
*/

`include "definitions.svh"

module AES_eng (
    input clk_in1, clk_in2, clk_in3, rst_n, // The clocks and reset signal

    input AES_KEY key_in, // Key input, can be changed after the first round
    input AES_TXT plain_in, // Plain text input, can be changed after the first round
    input [1:0] state_in, // [1]: if AES_in is ready, [0]: if AES_eng should start

    output AES_TXT cipher_out, // Cipher out, valid after state_out[0] is 1
    output [1:0] state_out // [1]: if AES_in is ready, [0]: if AES_out should start
);

wire AES_KEY_EXPANDED_K key_ex; // expanded key
bit clk3_en; // state_in[0] should be synchronized with clk_in3
bit clk3_en_lock; // if this goes low, clk3_en will be locked low (happens after the final round)
always_ff @( posedge clk_in3 ) clk3_en <= state_in[0] & clk3_en_lock; // enable signal
always_ff @( posedge clk_in2 ) begin : ff_clk3_en_lock
    if (!state_in[0]) // reset to high after the input release
        clk3_en_lock <= '1;
    else if (state_out[0]) // set to low after the final round
        clk3_en_lock <= '0;
    else
        clk3_en_lock <= clk3_en_lock; // remain
end
KeyGen keygen(
    .clk1_in(clk_in1), .clk2_in(clk_in2), .clk3_in(clk_in3), .clk3_en(clk3_en), .rst_n(rst_n), 
    .key_in(key_in),
    .key_ex_out(key_ex)
);
Round round(
    .clk1_in(clk_in1), .clk2_in(clk_in2), .clk3_in(clk_in3), .clk3_en(clk3_en), .rst_n(rst_n), 
    .key_ex_in(key_ex), .key_in(key_in), .plain_in(plain_in), 
    .cipher_out(cipher_out), .ok_out(state_out[0])
);
assign state_out[1] = state_in[1]; // just pass the value

endmodule