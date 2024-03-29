/**
 * @file RowShift.sv
 * @author Kefan.Liu@outlook.com
 * @brief row shift operation
 * @note
 * The rowshift is used whether or not it uses T-Box
*/

`include "definitions.svh"

module RowShift(
    input AES_BOX din,
    output AES_BOX qout
);

genvar g_i, g_j;
generate
    for (g_i = 0; g_i < 4; g_i = g_i + 1)
        for (g_j = 0; g_j < 4; g_j = g_j + 1)
            assign qout[(g_i << 2) | g_j] = din[(((g_i + g_j) & 'b11) << 2) | g_j];
endgenerate

endmodule