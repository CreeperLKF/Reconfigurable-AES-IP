/**
 * @file ColMix.sv
 * @note Copied from tbox, could be optimized out by TBox
*/

`include "definitions.svh"

module ColMix(
    input  [127:0] din,
    output [127:0] qout
);

genvar g_i;

generate
    for (g_i = 0; g_i < 128; g_i = g_i + 32) begin : g_colmixroll
        ColMixRoll colmixroll(
            .din(din[g_i+:32]),
            .qout(qout[g_i+:32])
        );
    end
endgenerate

endmodule