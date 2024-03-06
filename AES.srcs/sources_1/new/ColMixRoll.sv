/**
 * @file ColMixRoll.sv
 * @note Copied from tbox
*/

`include "definitions.svh"

module ColMixRoll(
    input integer din,
    output integer qout
);

function automatic byte aes_mul_2 (byte din);
    return (din[7]) ? ({din[6:0], 1'b0} ^ 8'h1b) : {din[6:0], 1'b0};
endfunction

function automatic byte aes_mul_3 (byte din);
    return aes_mul_2(din) ^ din;
endfunction

assign qout[7:0] = aes_mul_2(din[7:0]) ^ aes_mul_3(din[15:8]) ^ din[23:16] ^ din[31:24];
assign qout[15:8] = din[7:0] ^ aes_mul_2(din[15:8]) ^ aes_mul_3(din[23:16]) ^ din[31:24];
assign qout[23:16] = din[7:0] ^ din[15:8] ^ aes_mul_2(din[23:16]) ^ aes_mul_3(din[31:24]);
assign qout[31:24] = aes_mul_3(din[7:0]) ^ din[15:8] ^ din[23:16] ^ aes_mul_2(din[31:24]);

endmodule