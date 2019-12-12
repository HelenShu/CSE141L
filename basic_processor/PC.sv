// CSE141L
// program counter
// accepts branch and jump instructions
// default = increment by 1
// issues halt when PC reaches 63
module PC(
  input init,
        jump_en,
	CLK,
  input [15:0] Target,
  output logic halt,
  output logic[ 15:0] PC);

always @(posedge CLK)
  if(init) begin
    if (PC) 
	PC <= PC;
    else
    	PC <= 0;
    halt <= 0;
  end
  else begin
    if((PC == 503) || (PC == 1190)) begin	//should be for end of all three programs
	halt <= 1;		 // just a randomly chosen number
	PC <= PC + 1;
    end 
    else if(jump_en)
	PC <= Target;	//have module that calculates target, or send it in
    else 
	PC <= PC + 1;	     // default == increment by 1
  end


endmodule
        