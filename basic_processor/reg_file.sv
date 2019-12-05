// Create Date:    2017.01.25
// Design Name:    CSE141L
// Module Name:    reg_file 
//
// Additional Comments: 					  $clog2

module reg_file(		 // W = data path width; D = pointer width
  input           CLK,
		  reset,
  input  [4:0]    raddrA,
                  rAddrB,
                  waddr,
  input	 [7:0]	  immValue,
  input  [7:0] data_in,
  output logic [7:0] data_outA,
  output logic [7:0] data_outB
    );

// W bits wide [W-1:0] and 2**4 registers deep 	 
logic [15:0] registers[16];	  // or just registers[16] if we know D=4 always

// sequential (clocked) writes 
always_ff @ (posedge CLK) begin
   if (reset) begin
	// you may initialize your memory w/ constants, if you wish
        for(int i = 4'b0000; i < 4'b1000;i = i + 4'b0001)
	    registers[i] <= 0;
   end
   else if (waddr != 5'b10000) //register 16 doesn't exist
      registers[waddr] <= data_in;
end

always_comb begin 
	if (raddrA == 5'b10000) //not using register
		data_outA = 8'h00;
	else
		data_outA = registers[raddrA];
	end
always_comb begin
	if ((immValue == 8'hF0)) //is an immediate value
		data_outB <= registers[rAddrB];
	else
		data_outB <= immValue; 
	end    
endmodule
