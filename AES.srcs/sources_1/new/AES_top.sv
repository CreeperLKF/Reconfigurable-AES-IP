/**
 * @file AES_top
 * @author Kefan.Liu@outlook.com
 * @brief The module connects internal systems of AES (in, eng, out)
 * @note
 * This implementation is derived from OpenSSL-3.0.8 (use tbox)
 */

`include "definitions.svh"

module AES_top(
    input clk_sys, rst_n, // the main clock is inputed here

    input byte data_in, // data input
    input [1:0] cmd_in, // command input
    
    output byte data_out, // data output
    output ready_out, // ready for input (also indicates if the clocks are stable (ready for work))
    output ok_out // ready for output
);

wire locked, clk_100, clk_200, clk_50;

clk_wiz_0 u_clk_wiz_0 (
    // Clock out ports
    .clk_out1(clk_100),     // output clk_out1
    .clk_out2(clk_200),     // output clk_out2
    .clk_out3(clk_50),     // output clk_out3
    // .clk_out4(clk_100_1),     // output clk_out4
    .locked(locked),       // output locked
    // Clock in ports
    .clk_in1(clk_sys)      // input clk_in1
);

AES_KEY key;
AES_TXT plain, cipher;
wire [1:0] state_ie;
wire [1:0] state_eo;
// state is maintained by internal system.
// AES module should proceed state

AES_in aes_in(
    .clk_in(clk_100), .rst_n(rst_n),
    .data_in(data_in), .cmd_in(cmd_in),
    .key_out(key), .plain_out(plain), .state_out(state_ie)
);

AES_eng aes_eng(
    .clk_in1(clk_100), .clk_in2(clk_200), .clk_in3(clk_50), .rst_n(rst_n),
    .key_in(key), .plain_in(plain), .state_in(state_ie),
    .cipher_out(cipher), .state_out(state_eo)
);

wire aes_ready_out;
assign ready_out = aes_ready_out & locked;

AES_out aes_out(
    .clk_in(clk_100), .rst_n(rst_n),
    .cipher_in(AES_BOX'(cipher)), .state_in(state_eo),
    .data_out(data_out), .ready_out(aes_ready_out), .ok_out(ok_out)
);

endmodule
