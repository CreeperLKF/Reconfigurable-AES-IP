/**
 * @file AES_out.sv
 * @author Kefan.Liu@outlook.com
 * @brief output interface of AES
*/

`include "definitions.svh"

module AES_out(
    input clk_in, rst_n, // you know who

    input AES_BOX cipher_in,
    input [1:0] state_in, // [1]: if AES_in is ready, [0]: if AES_out should start

    output byte data_out, // output data
    output wire ready_out, // if the AES is inputing data (the inverse of cmd_in[1])
    output reg ok_out // if the data is ready (keep at output)
);

typedef enum logic { 
    AO_IDLE,
    AO_OUTPUT
} AES_out_STATE;

AES_out_STATE aes_out_state; // just as its name
assign ready_out = state_in[1]; // that's it. no delay.

byte unsigned cur_byte; // the current byte for output

always_ff @( posedge clk_in or negedge rst_n ) begin : ff_aes_out_state
    if (!rst_n) // just as its name
        aes_out_state <= AO_IDLE;
    else if (state_in[0])
        aes_out_state <= AO_OUTPUT;
    else if (cur_byte == AES_TXT_LEN >> 8'd3)
        aes_out_state <= AO_IDLE;
    else
        aes_out_state <= aes_out_state;
end

always_ff @( posedge clk_in or negedge rst_n) begin : ff_out
    if (!rst_n) begin // reset for stability and security
        data_out <= '0;
        ok_out <= '0;
    end else if (aes_out_state == AO_OUTPUT) begin
        data_out <= cipher_in[cur_byte];
        ok_out <= '1;
    end else begin
        data_out <= '0;
        ok_out <= '0;
    end
end

always_ff @( posedge clk_in or negedge rst_n ) begin : ff_cur_byte
    if (!rst_n) // reset for stability
        cur_byte <= '0;
    else if (aes_out_state == AO_OUTPUT)
        if (cur_byte == AES_TXT_LEN >> 8'd3)
            cur_byte <= '0;
        else
            cur_byte <= cur_byte + 1'b1;
    else
        cur_byte <= '0;
end


endmodule