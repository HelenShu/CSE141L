// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[8:0] instAddress,	   // machine code
  output logic [7:0] rAddrA, //helps our regfile parse
  output logic [7:0] rAddrB, //helps regfile parse
  output logic [7:0] wAddr   //helps regile parse
  output logic write_en            //tells regfile we're writing
  
	

  input       ZERO,			   // ALU out[7:0] = 0
  output logic jump_en,
               branch_en,
               ReadMem,   //feeding these to datameme
               WriteMem,  //feeding these to damameme
  );

/*
  logic [1:0] opType;
  logic [1:0] function;
  
    always_comb begin
      opType = instAddress[8:7]
      if(opType == 2'b00)
        begin
        funct = instAddress[6:5];
        end
      else
        begin
        funct = instAddress[6];
        end
    end
  */
  
    //controls the regfile?
    
  
    
    
    
  // sequential (clocked) writes 
always_comb 
  //resetting values when running?
  write_en <= 0;
  rAddrA <= 0;
  rAddrB <= 0;
  ReadMem <= 0;
  WriteMem <= 0; 
  jump_en <= 0;
 //Little confused about the instruction breakdown here.
// basically add in write enable where necessary. Also change memRead and MemWrite where necesassry.

	  
begin
if ((instAddress[8:7] == 2'b00)) //R-type instruction
      begin
        if (function [6:5] == 2'b00)) //shift
	  begin
	    rAddrA <= [4:3];
	    rAddrB <= [2:0];
	    wAddr  <= [4:3];
     	    write_en <= 1;
	    ReadMem <= 0;
  	    WriteMem <= 0; 
  	    jump_en <= 0;

	  end
      else
          begin
          //rAddrA is accumulator
          rAddrB <= instAddress[4:0];
          //wAddr is accumulator
	  write_en <= 1;
	  ReadMem <= 0;
          WriteMem <= 0; 
          jump_en <= 0;

          end
      end
		
else if ((instAddress[8:6] == 3'b101)) //compare
    begin
      rAddrA <= instAddress[5:3];
      rAddrB <= instAddress[3:0];
      wAddr  <= instAddress[5:3];
      write_en <= 1;
      ReadMem <= 0;
      WriteMem <= 0; 
      jump_en <= 0;

    end
		
else if((instAddress[8:6] ==  kJ)) //jump
     rAddrA <= instAddress[5];
     rAddrB <= instAddress[4:0];
     wAddr  <= instAddress[5];
     ReadMem <= 0;
     WriteMem <= 0;
     write_en <= 1;
     jump_en <= 1;


//These Operations control loading and storing so set memread and memwrite
else if((instAddress[8:6]==3'b010))	//store
      rAddrA <= instAddress[5];
      rAddrB <= instAddress[4:0];
      wAddr  <= instAddress[5];
      ReadMem <= 0;
      WriteMem <= 1; 
      jump_en <= 0;
      write_en <= 0;
			

else if((instAddress[8:6]==3'b011))	//load
      rAddrA <= instAddress[5];
      rAddrB <= instAddress[4:0];
      wAddr  <= instAddress[5];
      ReadMem <= 1;
      WriteMem <= 0; 
      jump_en <= 0;
      write_en <= 1;

		
else if((instAddress[8:6] == kBRE && ZERO)) //branch equals not sure if branch_en or jump_en based on implementation
      rAddrA <= instAddress[5];
      rAddrB <= instAddress[4:0];
      wAddr  <= instAddress[5];
      ReadMem <= 0;
      WriteMem <= 0; 
      jump_en <= 1;
      write_en <= 1;
else
  else				 // Assuming this is move??
      rAddrA <= instAddress[5:3];
      rAddrB <= instAddress[3:0];
      wAddr  <= instAddress[5:3];
      ReadMem <= 0;
      WriteMem <= 0; 
      jump_en <= 0;
      write_en <= 1;

  end
   
 

endmodule

   // ARM instructions sequence
   //				cmp r5, r4
   //				beq jump_label
