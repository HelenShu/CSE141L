module get_addresses(
  input [8:0]     instAddress,
  output logic [4:0] rAddrA,
  output logic [4:0] rAddrB,
  output logic [4:0] wAddr,
  output logic [7:0] immValue
    );
 
always_comb begin
  if ((instAddress[8:5] == 4'b0000)) //Move instruction
	begin
	rAddrA = 5'b01111;
	rAddrB = instAddress[4:0];
	wAddr  = instAddress[4:0];
	immValue = 8'hF0;
	end
  else if ((instAddress[8:7] == 2'b00) || instAddress[8:5] == 4'b1100) //R-type instruction
	begin
	//accumulator register
	rAddrA = 5'b01111;
	rAddrB = instAddress[4:0];
	wAddr = 5'b01111;
	immValue = 8'hF0;
	end
  else if ((instAddress[8:6] == 3'b010)) //ShiftLeft, ShiftRight
	begin
	rAddrA = {3'b000, instAddress[4:3]};
	rAddrB = 5'b10000;
	wAddr = {3'b000, instAddress[4:3]};
	immValue = {4'h0, 1'b0, instAddress[2:0]};
	end
  else if ((instAddress[8:5] == 4'b0110)) //store
    begin
	rAddrA = {1'b0, instAddress[4:1]};
	rAddrB = {4'b0000, instAddress[0]};
	wAddr = 5'b10000;
	immValue = 8'hF0;
    end
  else if ((instAddress[8:5] == 4'b0111)) //load
    begin
	rAddrA = 5'b10000;
	rAddrB = {4'b0000, instAddress[0]};
	wAddr = {1'b0, instAddress[4:1]};
	immValue = 8'hF0;
    end
  else if ((instAddress[8:6] == 3'b100)) //branch equals, jump 
	begin
	rAddrA = 5'b10000;
	rAddrB = 5'b10000;
	wAddr  = 5'b10000;
	immValue = {3'b000, instAddress[4:0]};
	end
  else if ((instAddress[8:5] == 4'b1101 || instAddress[8:5] == 4'b1110)) //Addi, Andi
	begin
	rAddrA = 5'b01111;
	rAddrB = 5'b10000;
	wAddr  = 5'b01111;
	immValue = {3'b000, instAddress[4:0]};
	end
  else if ((instAddress[8:5] == 4'b1111)) //shift left registers
	begin
	rAddrA = {3'b000, instAddress[4:3]};
	rAddrB = instAddress[2:0];
	wAddr  = {3'b000, instAddress[4:3]};
	immValue = 8'hF0;
	end
  else if ((instAddress[8:5] == 4'b1010)) //compare
	begin
	rAddrA = {3'b000, instAddress[4:3]};
	rAddrB = {2'b00, instAddress[2:0]};
	wAddr = 5'b10000;
	immValue = 8'hF0;
	end
  else //set everything to 0
	begin
	rAddrA = 5'b10000;
	rAddrB = 5'b10000;
	wAddr  = 5'b10000;
	immValue = 8'hF0;
	end
end

endmodule
