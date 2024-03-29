/**
 * @file DROM_TBox.sv
 * @author Kefan.Liu@outlook.com
 * @brief Implement DROM. Interface is compatible with IP Core.
*/

`include "definitions.svh"

module DROM_TBox (
    input wire clka,
    input wire ena,
    input wire [7 : 0] addra,
    output reg [31 : 0] douta,
    input wire clkb,
    input wire enb,
    input wire [7 : 0] addrb,
    output reg [31 : 0] doutb
);

localparam [31:0] SBox [0:255] = '{
    32'hc66363a5, 32'hf87c7c84, 32'hee777799, 32'hf67b7b8d,
    32'hfff2f20d, 32'hd66b6bbd, 32'hde6f6fb1, 32'h91c5c554,
    32'h60303050, 32'h02010103, 32'hce6767a9, 32'h562b2b7d,
    32'he7fefe19, 32'hb5d7d762, 32'h4dababe6, 32'hec76769a,
    32'h8fcaca45, 32'h1f82829d, 32'h89c9c940, 32'hfa7d7d87,
    32'heffafa15, 32'hb25959eb, 32'h8e4747c9, 32'hfbf0f00b,
    32'h41adadec, 32'hb3d4d467, 32'h5fa2a2fd, 32'h45afafea,
    32'h239c9cbf, 32'h53a4a4f7, 32'he4727296, 32'h9bc0c05b,
    32'h75b7b7c2, 32'he1fdfd1c, 32'h3d9393ae, 32'h4c26266a,
    32'h6c36365a, 32'h7e3f3f41, 32'hf5f7f702, 32'h83cccc4f,
    32'h6834345c, 32'h51a5a5f4, 32'hd1e5e534, 32'hf9f1f108,
    32'he2717193, 32'habd8d873, 32'h62313153, 32'h2a15153f,
    32'h0804040c, 32'h95c7c752, 32'h46232365, 32'h9dc3c35e,
    32'h30181828, 32'h379696a1, 32'h0a05050f, 32'h2f9a9ab5,
    32'h0e070709, 32'h24121236, 32'h1b80809b, 32'hdfe2e23d,
    32'hcdebeb26, 32'h4e272769, 32'h7fb2b2cd, 32'hea75759f,
    32'h1209091b, 32'h1d83839e, 32'h582c2c74, 32'h341a1a2e,
    32'h361b1b2d, 32'hdc6e6eb2, 32'hb45a5aee, 32'h5ba0a0fb,
    32'ha45252f6, 32'h763b3b4d, 32'hb7d6d661, 32'h7db3b3ce,
    32'h5229297b, 32'hdde3e33e, 32'h5e2f2f71, 32'h13848497,
    32'ha65353f5, 32'hb9d1d168, 32'h00000000, 32'hc1eded2c,
    32'h40202060, 32'he3fcfc1f, 32'h79b1b1c8, 32'hb65b5bed,
    32'hd46a6abe, 32'h8dcbcb46, 32'h67bebed9, 32'h7239394b,
    32'h944a4ade, 32'h984c4cd4, 32'hb05858e8, 32'h85cfcf4a,
    32'hbbd0d06b, 32'hc5efef2a, 32'h4faaaae5, 32'hedfbfb16,
    32'h864343c5, 32'h9a4d4dd7, 32'h66333355, 32'h11858594,
    32'h8a4545cf, 32'he9f9f910, 32'h04020206, 32'hfe7f7f81,
    32'ha05050f0, 32'h783c3c44, 32'h259f9fba, 32'h4ba8a8e3,
    32'ha25151f3, 32'h5da3a3fe, 32'h804040c0, 32'h058f8f8a,
    32'h3f9292ad, 32'h219d9dbc, 32'h70383848, 32'hf1f5f504,
    32'h63bcbcdf, 32'h77b6b6c1, 32'hafdada75, 32'h42212163,
    32'h20101030, 32'he5ffff1a, 32'hfdf3f30e, 32'hbfd2d26d,
    32'h81cdcd4c, 32'h180c0c14, 32'h26131335, 32'hc3ecec2f,
    32'hbe5f5fe1, 32'h359797a2, 32'h884444cc, 32'h2e171739,
    32'h93c4c457, 32'h55a7a7f2, 32'hfc7e7e82, 32'h7a3d3d47,
    32'hc86464ac, 32'hba5d5de7, 32'h3219192b, 32'he6737395,
    32'hc06060a0, 32'h19818198, 32'h9e4f4fd1, 32'ha3dcdc7f,
    32'h44222266, 32'h542a2a7e, 32'h3b9090ab, 32'h0b888883,
    32'h8c4646ca, 32'hc7eeee29, 32'h6bb8b8d3, 32'h2814143c,
    32'ha7dede79, 32'hbc5e5ee2, 32'h160b0b1d, 32'haddbdb76,
    32'hdbe0e03b, 32'h64323256, 32'h743a3a4e, 32'h140a0a1e,
    32'h924949db, 32'h0c06060a, 32'h4824246c, 32'hb85c5ce4,
    32'h9fc2c25d, 32'hbdd3d36e, 32'h43acacef, 32'hc46262a6,
    32'h399191a8, 32'h319595a4, 32'hd3e4e437, 32'hf279798b,
    32'hd5e7e732, 32'h8bc8c843, 32'h6e373759, 32'hda6d6db7,
    32'h018d8d8c, 32'hb1d5d564, 32'h9c4e4ed2, 32'h49a9a9e0,
    32'hd86c6cb4, 32'hac5656fa, 32'hf3f4f407, 32'hcfeaea25,
    32'hca6565af, 32'hf47a7a8e, 32'h47aeaee9, 32'h10080818,
    32'h6fbabad5, 32'hf0787888, 32'h4a25256f, 32'h5c2e2e72,
    32'h381c1c24, 32'h57a6a6f1, 32'h73b4b4c7, 32'h97c6c651,
    32'hcbe8e823, 32'ha1dddd7c, 32'he874749c, 32'h3e1f1f21,
    32'h964b4bdd, 32'h61bdbddc, 32'h0d8b8b86, 32'h0f8a8a85,
    32'he0707090, 32'h7c3e3e42, 32'h71b5b5c4, 32'hcc6666aa,
    32'h904848d8, 32'h06030305, 32'hf7f6f601, 32'h1c0e0e12,
    32'hc26161a3, 32'h6a35355f, 32'hae5757f9, 32'h69b9b9d0,
    32'h17868691, 32'h99c1c158, 32'h3a1d1d27, 32'h279e9eb9,
    32'hd9e1e138, 32'hebf8f813, 32'h2b9898b3, 32'h22111133,
    32'hd26969bb, 32'ha9d9d970, 32'h078e8e89, 32'h339494a7,
    32'h2d9b9bb6, 32'h3c1e1e22, 32'h15878792, 32'hc9e9e920,
    32'h87cece49, 32'haa5555ff, 32'h50282878, 32'ha5dfdf7a,
    32'h038c8c8f, 32'h59a1a1f8, 32'h09898980, 32'h1a0d0d17,
    32'h65bfbfda, 32'hd7e6e631, 32'h844242c6, 32'hd06868b8,
    32'h824141c3, 32'h299999b0, 32'h5a2d2d77, 32'h1e0f0f11,
    32'h7bb0b0cb, 32'ha85454fc, 32'h6dbbbbd6, 32'h2c16163a
};

always_ff @( posedge clka ) if (ena) douta <= SBox[addra];
always_ff @( posedge clkb ) if (enb) doutb <= SBox[addrb];
 
endmodule
