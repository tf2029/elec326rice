// 16-bit processor instruction decoder

`define ADDI 4'b0100
`define SUBI 4'b0101
`define LOAD 4'b0110
`define STOR 4'b0111
`define BEQ  4'b1000
`define BGE  4'b1001
`define BLE  4'b1010
`define BC   4'b1011
`define J    4'b1100

module decoder(
        input [15:0] instruction_pi,

        output [2:0] alu_func_po,

        output [2:0] destination_reg_po,
        output [2:0] source_reg1_po,
        output [2:0] source_reg2_po,

        output [11:0] immediate_po,

        output arith_2op_po,
        output arith_1op_po,

        output movi_lower_po,
        output movi_higher_po,

        output addi_po,
        output subi_po,

        output load_po,
        output store_po,

        output branch_eq_po,
        output branch_ge_po,
        output branch_le_po,
        output branch_carry_po,

        output jump_po,

        output stc_cmd_po,
        output stb_cmd_po,
        output halt_cmd_po,
        output rst_cmd_po
);

   // Input signals have the suffix "_pi" and output signals the suffix "_po".

assign addi_po = (instruction_pi[15:12] == `ADDI);
assign subi_po = (instruction_pi[15:12] == `SUBI);
assign load_po = (instruction_pi[15:12] == `LOAD);
assign store_po = (instruction_pi[15:12] == `STOR);

assign branch_eq_po = (instruction_pi[15:12] == `BEQ);
assign branch_ge_po = (instruction_pi[15:12] == `BGE);
assign branch_le_po = (instruction_pi[15:12] == `BLE);
assign branch_carry_po = (instruction_pi[15:12] == `BC);
assign jump_po = (instruction_pi[15:12] == `J);

assign arith_1op_po = (instruction_pi[15:12] == 4'b0010);
assign arith_2op_po = (instruction_pi[15:12] == 4'b0001);
assign movi_lower_po = (instruction_pi[15:12] == 4'b0011) && (instruction_pi[8] == 1'b0);
assign movi_higher_po = (instruction_pi[15:12] == 4'b0011) && (instruction_pi[8] == 1'b1);

assign stc_cmd_po  = (instruction_pi == 16'b1111_0000_0000_0001);
assign stb_cmd_po  = (instruction_pi == 16'b1111_0000_0000_0010);
assign rst_cmd_po  = (instruction_pi == 16'b1111_1010_1010_1010);
assign halt_cmd_po = (instruction_pi == 16'b1111_1111_1111_1111);

assign destination_reg_po = instruction_pi[11:9];
assign alu_func_po = instruction_pi[2:0];
assign immediate_po = instruction_pi[11:0];
assign source_reg1_po = (branch_eq_po || branch_ge_po || branch_le_po) ? instruction_pi[11:9] : instruction_pi[8:6];
assign source_reg2_po = (branch_eq_po || branch_ge_po || branch_le_po || branch_carry_po) ? instruction_pi[8:6] : instruction_pi[5:3];

endmodule // decoder

