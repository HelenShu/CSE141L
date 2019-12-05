// Create Date:    2016.10.15
// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision 2018.01.27
// Additional Comments: 
//   combinational (unclocked) ALU
import definitions::*;			  // includes package "definitions"
module ALU(
  input [ 7:0] INPUTA,      	  // value from accumulator
               INPUTB,		  // value from register/immediate
  input [ 3:0] OP,				  // ALU opcode, part of microcode
  input        SC_IN,             // shift in/carry in 
  input	       ZERO_IN,
  input        GREATER_IN,
  output logic [7:0] OUT,		  // or:  output reg [7:0] OUT,
  output logic SC_OUT,			  // shift out/carry out
  output logic ZERO,              // zero out flag
  output logic GREATER
    );
	 
  op_mne op_mnemonic;	// type enum: used for convenient waveform viewing
	
  always_comb begin

  case(OP)
    kADD : begin
	   {SC_OUT, OUT} = {1'b0,INPUTA} + INPUTB + SC_IN;
	   SC_OUT = 0;
	   ZERO = 0;
	   GREATER = 0;
	   end
    kADDI : begin
	   {SC_OUT, OUT} = {1'b0,INPUTA} + INPUTB + SC_IN;
	   SC_OUT = 0;
	   ZERO = 0;
	   GREATER = 0;
	   end
    kSUB : begin
	   OUT = {1'b0,INPUTA} - INPUTB;
	   ZERO = 0;
	   GREATER = 0;
	   SC_OUT = 0;
	   end
    kLSH : begin
	   {SC_OUT, OUT} = {INPUTA << (INPUTB - 8'b00000001), 1'b0};
	   ZERO = 0;
	   GREATER = 0;
	   end
    kRSH : begin
	   {OUT, SC_OUT} = {1'b0, INPUTA >> (INPUTB - 8'b00000001)};
	   ZERO = 0;
	   GREATER = 0;
	   end
    kXOR : begin 
 	   OUT = INPUTA^INPUTB;  	
	   SC_OUT = 0;
	   ZERO = 0;
	   GREATER = 0;			
	   end
    kAND : begin                                          
           OUT = INPUTA & INPUTB;
	   ZERO = 0;
	   GREATER = 0;
	   SC_OUT = 0;
	   end
    kANDI : begin                                           
           OUT = INPUTA & INPUTB;
	   ZERO = 0;
	   GREATER = 0;
	   SC_OUT = 0;
	   end
    kMOV : begin                                           
           OUT = INPUTA;
	   ZERO = 0;
	   GREATER = 0;
	   SC_OUT = 0;
	   end
    kSHLR : begin
	   {SC_OUT, OUT} = {INPUTA << (INPUTB - 8'b00000001), 1'b0};
	   ZERO = 0;
	   GREATER = 0;
	   end
    kCOMP : begin                                           
           ZERO = INPUTA - INPUTB == 0 ? 1 : 0;
	   GREATER = INPUTA - INPUTB > 0 ? 1 : 0;
	   SC_OUT = 0;
	   OUT = 0;
	   end
    default: begin
	SC_OUT = 0;
	OUT = 0;
	ZERO = ZERO_IN;
	GREATER = GREATER_IN;
	end
  endcase

  op_mnemonic = op_mne'(OP); // displays operation name in waveform viewer
  
  end								 
endmodule
