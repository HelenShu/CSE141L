// CSE141L
// program counter
// accepts branch and jump instructions
// default = increment by 1
// issues halt when PC reaches 63
module PC(
  input init,
        jump_en,		// relative
	branch_en,		//
	
	logic[15:0] Target,      //get from output of LUT.sv
	
	CLK,
  output logic halt,
  output logic[ 9:0] PC);

always @(posedge CLK)
  if(init) begin
    PC <= 0;
    halt <= 0;
  end
  else begin
    if(PC>63)
	halt <= 1;		 // just a randomly chosen number 
	  
	  else if (branch_en) 	 // absolute jumping, dunnno if we need to change anything for branch equals
	PC <= Target;
	  
    else if(jump_en) begin
	if(PC > 13)
	    PC <= PC - 14;
	else
	    halt <= 1;       // trap error condition
        end
    else 
	  PC <= PC + 1;	     // default == increment by 1
  end
endmodule
        
