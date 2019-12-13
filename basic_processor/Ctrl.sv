// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 8:0] 	Instruction,	   // machine code
  input       	ZERO,		   // ALU out[7:0] = 0
  input		GREATER,
  output logic 	jump_en,
  output logic [15:0] Target
  );

//jump, branch equals, branch greater than
always_comb begin
  if((Instruction[8:5] ==  kJ) || ((Instruction[8:5] == kBRE) && (ZERO == 1)) || ((Instruction[8:5] == kBRGT) && (GREATER == 1)))
    jump_en = 1;
  else
    jump_en = 0;

  //lookup table
  if ((jump_en)) begin 
 	 case(Instruction[4:0])		   //skips value 0
		5'b00000:   	Target = 16'h0003; //start-ish of program 1
		5'b00001:	Target = 16'h01F7; //end of program 1
		5'b00010:	Target = 16'h044F; //2_bit_error
		5'b00011:	Target = 16'h0431; //Upper_byte
		5'b00100:	Target = 16'h0427; //Lower_0
		5'b00101:	Target = 16'h042C; //Lower_1
		5'b00110:	Target = 16'h0456; //Decode
		5'b00111:	Target = 16'h0445; //Upper_0
		5'b01000:	Target = 16'h044A; //Upper_1
		5'b01001:	Target = 16'h049E; //End of Program2
		5'b01010:	Target = 16'h0201; //Program2 Loop
		/*5'b01011:			   //start-ish of program 3
		5'b01100:			   //Match
		5'b01101:			   //Next
		5'b01110:			   //ByteMatch
		5'b01111:			   //NextByte
		5'b10000:			   //Part1_2_End
		5'b10001:			   //P3_Loop3
		5'b10010:			   //Match_3
		5'b10011:			   //Next_3
		5'b10100:			   //NextByte_3
		5'b10101:			   //LastByte
		5'b10110:			   //LastByte_NoMatch
		5'b10111:			   //End  */
		default: 	Target = 0;
	endcase
	end
   else  Target = 0;
end

endmodule
