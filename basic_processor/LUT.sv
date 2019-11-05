// CSE141L
// possible lookup table for PC target
// leverage a few-bit pointer to a wider number
module LUT(
  input[4:0] addr,
  output logic[15:0] Target
  );

always_comb 
  case(addr)		   //-16'd30;
	5'b00000:   	Target = 16'h0000; //start-ish of program 1
	5'b00001:	Target = 16'h0f03; //end of program 1
	5'b00010:	Target = 16'h0003; //start-ish of program 2
	/*5'b00011:			   //2_bit_error
	5'b00100:			   //Upper_byte
	5'b00101:			   //Lower_0
	5'b00110:			   //Lower_1
	5'b00111:			   //Upper_0
	5'b01000:			   //Upper_1
	5'b01001:			   //Decode
	5'b01010:			   //end of program 2
	5'b01011:			   //start-ish of program 3
	5'b01100:			   //Match
	5'b01101:			   //Next
	5'b01110:			   //NextByte
	5'b01111:			   //ByteMatch
	5'b10000:			   //Part1_2_End
	5'b10001:			   //Loop3
	5'b10010:			   //Next_3
	5'b10011:			   //NextByte_3
	5'b10100:			   //LastByte
	5'b10101:			   //end of program 3  */
	default: 	Target = 16'h0;
  endcase

endmodule
