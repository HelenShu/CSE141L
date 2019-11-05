// Create Date:    2017.01.25
// Design Name:    CSE141L
// Module Name:    reg_file 
//
// Additional Comments: 					  $clog2

module reg_file(		 // W = data path width; D = pointer width
  input           CLK,
                  write_en,
  input  [4:0] raddrA,
                  rAddrB,
                  waddr,
  input	 [15:0]	  immValue,
  input  [15:0] data_in,
  output logic [15:0] data_outA,
  output logic [15:0] data_outB
    );

// W bits wide [W-1:0] and 2**4 registers deep 	 
logic [15:0] registers[16];	  // or just registers[16] if we know D=4 always
 	
always_comb data_outA = registers[raddrA];
always_comb begin
	if ((immValue == 0)) //is an immediate value
		data_outB <= registers[rAddrB];
	else
		data_outB <= immValue; 
	end    

// sequential (clocked) writes 
always_ff @ (posedge CLK)
  if (write_en && waddr)	                             // && waddr requires nonzero pointer address
// if (write_en) if want to be able to write to address 0, as well
    registers[waddr] <= data_in;

endmodule
