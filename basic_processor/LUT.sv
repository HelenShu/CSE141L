// CSE141L
// possible lookup table for PC target
// leverage a few-bit pointer to a wider number
module LUT(
	input[1:0] opcode,
	input[4:0] immediate,
  output logic[15:0] Target
  );
  
	logic branch_type;
	//dunno if this will work. appending opcode to immediate for more more address lookups?

always_comb 
begin

branch_type <= {opcode,immediate};
	case(branch_type)//-16'd30;
	2'b00:   Target = 16'hffff;//-1
	2'b01:	 Target = 16'h0f03;
	2'b10:	 Target = 16'h0003;
	default: Target = 16'h0;
  endcase
end
endmodule
