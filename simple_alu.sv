module simple_alu (
  input logic clk,
  input logic rst_n,
  input logic [2:0] avs_address,
  input logic [31:0] avs_write_data,
  input logic avs_write,
  input logic avs_read,
  output logic [31:0] avs_read_data
);

  // Internal register for storing data
  logic [15:0] operand_reg_1;
  logic [15:0] operand_reg_2;
  logic [3:0]  operator_reg;
  logic [31:0] result_reg;
  logic [31:0] mult_res_reg;
  logic [15:0] div_res_reg;
  logic        bad_access;
  logic perform_operation ;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      operand_reg_1 <= '0;
      operand_reg_2 <= '0;
		operator_reg  <= '0;
		perform_operation <= 1'b0;
	end else if (avs_write) begin
		case (avs_address)
		0: operand_reg_1 <= avs_write_data[15:0];
		1: operand_reg_2 <= avs_write_data[15:0];
	   2: operator_reg  <= avs_write_data[3:0];
		default:  bad_access <= 1'b1;	
		endcase
		perform_operation <= (avs_address == 3'd2) ? 1'b1 : 1'b0;
	end
  end
  
//  mult1 u_mult1(
//	.dataa(operand_reg_1),
//	.datab(operand_reg_2),
//	.result(mult_res_reg));
//  div1 u_div1(
//	.denom(operand_reg_2),
//	.numer(operand_reg_1),
//	.quotient(div_res_reg),
//	.remain());
/* verilator lint_off WIDTH */	
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      result_reg    <= '0;
	 end else if (perform_operation) begin
	 case (operator_reg)
	 0: begin
		 result_reg[31:17] <= '0;
		 result_reg[16:0]  <= operand_reg_1 + operand_reg_2; // add
	 end
	 1: begin
		 result_reg[31:17] <= '0;
		 result_reg[16:0]  <= operand_reg_1 - operand_reg_2; // sub
	 end
	 2: result_reg <= operand_reg_1 * operand_reg_2; //mult_res_reg[15:0];  // mul
	 3: result_reg <= operand_reg_1 / operand_reg_2; //div_res_reg; // div
	 4: begin
		 result_reg[31:16] <= '0;
		 result_reg[15:0] <= operand_reg_1 << operand_reg_2; // left_shift
	    end
	 5: begin
		 result_reg[31:16] <= '0;
		 result_reg[15:0] <= operand_reg_1 >> operand_reg_2; // left_shift
	    end
	 default: result_reg <= '0;
	 endcase
	 end 
  end
  // Read logic
  always_comb begin
    if (avs_read)
      avs_read_data = {16'd0,result_reg};
    else
      avs_read_data = '0;
  end

endmodule
