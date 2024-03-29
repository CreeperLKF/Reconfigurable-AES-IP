/**
 * @file definitions.svh
 * @author Kefan.Liu@outlook.com
 * @brief all definitions and switches
 * @note 
 * To calculate key round:
 * AES_128: 4 * 10 = 4 * 10
 * AES_192: 4 * 12 = 6 * 8
 * AES_256: 4 * 14 = 8 * 7
 * 唯一的中文备注部分：
 * 目前只能跑AES_128，因为密钥生成那个位置你会发现两边生成/使用的密钥不对等（AES256还好处理，但是AES192难受）
 * 所以可能得上多个时钟来解决这个同步问题，或者是再加一个周期，理想情况下就是分频
 * 其实更理想的情况是通过DDR2解决访问问题，不过懒得写，而且对于集成芯片一般用不上DDR
 * 人工仿真DDR2的话就是分出一堆子周期来让那个SBox共用，在这种情况下TBox查表会更快
 * 目前情况是密钥扩展部分一个周期和加密一个周期
 * // 现在是全部流水线展开，后续会收缩面积
 * // 还没有优化时序
 * 现在做了一些优化，但是我懒得写AES_192和AES_256了。其实很好改的。
*/

`ifndef _DEFINITIONS_SVH
`define _DEFINITIONS_SVH

`define KF_DEBUG // enable debug variables
`define KF_USE_ROM // use ROM or LUT in design
`define KF_USE_TBOX // use TBox or calculate normally
// `define KF_USE_PIPELINE // use full pipeline
// `define KF_USE_EXTRA_CLK_EN // use extra clk enable to reduce power
`define KF_IC // compatible design for IC synthesis

typedef enum byte unsigned { 
    AES_128 = 'd127,
    AES_192 = 'd191,
    AES_256 = 'd255
} AES_ALL_TYPE;
typedef logic [127:0] AES_TXT;
typedef logic [127:0] AES_KEY;
typedef byte AES_BOX [15:0];
typedef byte AES_SOX [3:0];
typedef integer AES_TOX [3:0];
typedef integer AES_BOX_E [15:0];
typedef AES_TXT AES_BOX_T [3:0];

`ifdef KF_USE_PIPELINE
typedef AES_KEY AES_KEY_EXPANDED_K [AES_KEY_ROUND:0];
typedef AES_TXT AES_KEY_EXPANDED_T [AES_TXT_ROUND:0];
`else
typedef AES_KEY AES_KEY_EXPANDED_K;
typedef AES_TXT AES_KEY_EXPANDED_T;
`endif

`endif