/**
 * @file ColMixT.sv
 * @author Kefan.Liu@outlook.com
 * @brief Mix Columns
*/

`include "definitions.svh"

module ColMixT(
    input clk1_in, clk2_in, clk3_en,
    input is_final,
    input integer key_in, 
    input AES_TOX din,
    output integer qout
);

integer d1, d2, key_in_1;
AES_SOX ds [3:0];
assign ds = {>>{din}};

always_ff @( posedge clk2_in ) begin : ff_d
    if (clk3_en) begin
        if (is_final) begin // if in final, just extract the result byte
            d1 <= {16'b0, ds[1][2], ds[0][1]};
            d2 <= {ds[3][0], ds[2][3], 16'b0};
        end else begin // otherwise xor operation is required
            d1 <= din[0] ^ din[1];
            d2 <= din[2] ^ din[3];
        end
    end
end

always_ff @( posedge clk1_in ) if (clk3_en) key_in_1 <= key_in; // the rest things are the same
always_ff @( posedge clk2_in ) if (clk3_en) qout <= key_in_1 ^ d1 ^ d2;

endmodule