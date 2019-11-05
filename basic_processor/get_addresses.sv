module get_addresses(
  input [8:0]     instAddress,
  output logic [4:0] rAddrA,
  output logic [4:0] rAddrB,
  output logic [4:0] wAddr,
  output logic [15:0] immValue
    );
 
always_comb begin
  if ((instAddress[8:7] == 2'b00) || instAddress[8:5] == 4'b1100) //R-type instruction
	begin
	//accumulator register
	rAddrA <= 5'b10000;
	rAddrB <= instAddress[4:0];
	wAddr <= 5'b10000;
	immValue <= 0;
	end
  else if ((instAddress[8:6] == 3'b010) || instAddress[8:5] == 4'b1010) //ShiftLeft, ShiftRight, Compare
	begin
	rAddrA <= {3'b000, instAddress[4:3]};
	rAddrB <= 5'b00000;
	wAddr <= {3'b000, instAddress[4:3]};
	immValue <= {12'h000, 1'b0, instAddress[2:0]};
	end
  else if ((instAddress[8:6] == 2'b011)) //store, load
    begin
	rAddrA <= {2'b00, instAddress[4:2]};
	rAddrB <= 5'b00000;
	wAddr <= {2'b00, instAddress[4:2]};
	immValue <= {12'h000, 2'b00, instAddress[1:0]};
    end
  else if ((instAddress[8:6] == 3'b100)) //branch equals, jump 
	begin
	rAddrA <= 5'b00000;
	rAddrB <= 5'b00000;
	wAddr  <= 5'b00000;
	immValue <= {11'b000_000_00000, instAddress[4:0]};
	end
  else if ((instAddress[8:5] == 4'b1101 || instAddress[8:5] == 4'b1110)) //Addi, Andi
	begin
	rAddrA <= 5'b10000;
	rAddrB <= 5'b00000;
	wAddr  <= 5'b10000;
	immValue <= {11'b000_000_00000, instAddress[4:0]};
	end
  else if ((instAddress[8:5] == 4'b1111)) //clear
	begin
	rAddrA <= 5'b00000;
	rAddrB <= 5'b00000;
	wAddr  <= instAddress[4:0];
	immValue <= 0;
	end
  else //set everything to 0
	begin
	rAddrA <= 5'b00000;
	rAddrB <= 5'b00000;
	wAddr  <= 5'b00000;
	immValue <= 0;
	end
end

endmodule
