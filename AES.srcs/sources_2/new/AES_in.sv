/**
 * @file AES_in.sv
 * @author Kefan.Liu@outlook.com
 * @brief input interface of AES
 * @note
 * The cmd_in should follow the followint rules:
 * 1. Keep high when input. (The ready will be low at input)
 * 2. CMD_ST is not required after AES_eng detect it. (different from the handout for 
 *  continuous input )
 * 3. You can input for the next round after ST. The input is buffered.
 * 4. CMD_ID is required for the state machine. (specified in the handout)
*/

`include "definitions.svh"

module AES_in (
    input clk_in, rst_n, // you just know that

    input byte data_in, // data input
    input [1:0] cmd_in, // command input

    output AES_TXT key_out, // key_output (buffered)
    output AES_TXT plain_out, // plain_output (buffered)
    output reg [1:0] state_out // [1]: if AES_in is ready, [0]: if AES_eng should start
);

typedef enum logic [1:0] {
    CMD_ID = 2'd0,
    CMD_ST = 2'd1,
    CMD_SK = 2'd2,
    CMD_SP = 2'd3
} CMD_STATE;

CMD_STATE cmd_in_lst; // one clk1_in delay

always_ff @( posedge clk_in) begin: ff_cmd_in_lst
    if (!rst_n) // To prevent chaos at start
        cmd_in_lst <= CMD_ID;
    else
        cmd_in_lst <= CMD_STATE'(cmd_in);
end

byte unsigned cur_byte; // the current byte of the input
AES_BOX key_out_box, plain_out_box; // the buffered input

always_ff @( posedge clk_in) begin : ff_state_out_0
    if(!rst_n)
        state_out[0] <= '0;
    else // The engine starts after 1 clk1_in
        state_out[0] <= cmd_in == CMD_ST;
end
always_comb state_out[1] = ~cmd_in[1];

always_ff @( posedge clk_in) begin : ff_out
    if (!rst_n) begin
        key_out <= '0;
        plain_out <= '0;
    end else begin // The output is buffered
        if (cmd_in == CMD_ST && cmd_in_lst == CMD_ID) begin
            key_out <= {>>{key_out_box}};
            plain_out <= {>>{plain_out_box}};
        end else begin
            key_out <= key_out;
            plain_out <= plain_out;
        end
    end
end

always_ff @( posedge clk_in) begin : ff_cur_byte
    if (cmd_in == CMD_SK) // The byte counter. The range is limited
        if (cur_byte == AES_KEY_LEN >> 8'd3)
            cur_byte <= '0;
        else
            cur_byte <= cur_byte + 1'b1;
    else if (cmd_in == CMD_SP)
        if (cur_byte == AES_TXT_LEN >> 8'd3)
            cur_byte <= '0;
        else
            cur_byte <= cur_byte + 1'b1;
    else
        cur_byte <= '0;
end

always_ff @( posedge clk_in or negedge rst_n ) begin : ff_key_out_box
    if (!rst_n) // for security concerns
        key_out_box <= '{16{8'b0}};
    else begin
        key_out_box <= key_out_box;
        if (cmd_in == CMD_SK)
            key_out_box[cur_byte] <= data_in;
    end
end

always_ff @( posedge clk_in or negedge rst_n ) begin : ff_plain_out_box
    if (!rst_n) // for security concerns
        plain_out_box <= '{16{8'b0}};
    else begin
        plain_out_box <= plain_out_box;
        if (cmd_in == CMD_SP)
            plain_out_box[cur_byte] <= data_in;
    end
end

endmodule