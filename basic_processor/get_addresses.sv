module reg_file (		 // W = data path width; D = pointer width
  input [8:0]     instAddress,
  output logic [7:0] rAddrA,
  output logic [7:0] rAddrB,
  output logic [7:0] wAddr 
    );

// sequential (clocked) writes 
always_comb
  if ((instAddress[8:7] == 2'b00)) //R-type instruction
      begin
      if (instAddress[6:5] == 2'b00)) //shift
	  begin
	    rAddrA <= [4:3];
	    rAddrB <= [2:0];
	    wAddr  <= [4:3];
	  end
      else
          begin
          //rAddrA is accumulator
          rAddrB <= instAddress[4:0];
          //wAddr is accumulator
          end
      end
  else if ((instAddress[8:6] == 3'b101)) //compare
    begin
      rAddrA <= instAddress[5:3];
      rAddrB <= instAddress[3:0];
      wAddr  <= instAddress[5:3];
    end
  else   
    begin
      rAddrA <= instAddress[5];
      rAddrB <= instAddress[4:0];
      wAddr  <= instAddress[5];
    end

endmodule
