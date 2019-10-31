// Create Date:    2018.04.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel 
// CSE141L
// partial only										   
module TopLevel(		   // you will have the same 3 ports
    input     start,	   // init/reset, active high
    input     CLK,		   // clock -- posedge used inside design
    output    halt		   // done flag from DUT
    );

	wire [15:0] Target;// absolute value for jump
	
wire [ 9:0] PC;            // program count
wire [ 8:0] Instruction;   // our 9-bit opcode
wire [ 7:0] ReadA, ReadB;  // reg_file outputs
	wire [ 7:0] InA, InB, InW, 	   // ALU operand inputs
            ALU_out;       // ALU result
wire [ 7:0] regWriteValue, // data in to reg file
            memWriteValue, // data in to data_memory
	         Mem_Out;	   // data out from data_memory
wire   MEM_READ,	   // data_memory read enable
	    MEM_WRITE,	   // data_memory write enable
   	 reg_wr_en,	   // reg_file write enable
	    sc_clr,        // carry reg clear
	    sc_en,	       // carry reg enable
	    SC_OUT,	       // to carry register
	    ZERO,		   // ALU output = 0 flag
            jump_en,	   // to program counter: jump enable
            branch_en;	   // to program counter: branch enable
logic[15:0] cycle_ct;	   // standalone; NOT PC!
logic       SC_IN;         // carry register (loop with ALU)
//perhaps have variables for raising when programs are done? Finish when all three flags are raised
	wire [1:0] OP;
	wire [1:0] funct;
	wire [4:0] immediate;

// Fetch = Program Counter + Instruction ROM
// Program Counter
  PC PC1 (
	  .Branch_abs(jump_en),
	  .ALU_zero(ZERO),
	  .Target(Target),
	  .init       (start), 
	.halt              ,  // SystemVerilg shorthand for .halt(halt), 
	.CLK        (CLK)  ,  // (CLK) is required in Verilog, optional in SystemVerilog
	.PC             	  // program count = index to instruction memory
	);					  

// Control decoder
  Ctrl Ctrl1 (
	  .instAddress(Instruction),    // from instr_ROM
	  .rAddrA(InA),
	  .rAddrB(InB),
	  .wAddr(InW),
	  .write_en  (reg_wr_en),
	  .OP(OP),
	  .funct(funct),
	  .immediate(immediate),
	  .ZERO,			 // from ALU: result = 0
	  .jump_en,
	  .ReadMem(MEM_READ),		 // to PC
	  .WriteMem(MEM_WRITE)		 // to PC
  );
// instruction ROM actual
/*  InstROM instr_ROM1(
	.InstAddress   (PC), 
	.InstOut       (Instruction)
	);*/
//Instruction Rom for testing.
InstROM instr_ROM1(
	.InstAddress   (PC), 
	.InstOut       (Instruction)
	);

  assign load_inst = Instruction[8:6]==3'b110;  // calls out load specially

// reg file
//change to accommodate accumulator
//perhaps have sub-module to calculate the raddrs and waddr
	reg_file #(.W(8),.D(4)) reg_file1 (
		.CLK    				  ,
		.write_en  (reg_wr_en)    , 
		.raddrA    ({1'b0,InA}),         //concatenate with 0 to give us 4 bits
		.raddrB    ({1'b0,InB}), 
		.waddr     ({1'b0,InW+1}), 	  // mux above???????????
		.data_in   (regWriteValue) , 
		.data_outA (ReadA) , 
		.data_outB (ReadB)
	);
// one pointer, two adjacent read accesses: (optional approach)
//	.raddrA ({Instruction[5:3],1'b0});
//	.raddrB ({Instruction[5:3],1'b1});

    assign InA = ReadA;						          // connect RF out to ALU in
    assign InB = ReadB;
  //  assign MEM_WRITE = (Instruction == 9'h111);       // mem_store command
    assign regWriteValue = load_inst? Mem_Out : ALU_out;  // 2:1 switch into reg_file
    ALU ALU1  (
	  .INPUTA  (InA),
	  .INPUTB  (InB), 
	  .OP      (OP),
	  .funct   (funct),
	  .OUT     (ALU_out),//regWriteValue),
	  .SC_IN   ,//(SC_IN),
	  .SC_OUT  ,
	  .ZERO 
	  );
  
	data_mem data_mem1(
		.CLK 		  		     ,
		.reset		  (start),
		.DataAddress  (ReadA)    , 
		.ReadMem      (MEM_READ),          //(MEM_READ) ,   always enabled 
		.WriteMem     (MEM_WRITE), 
		.DataIn       (ALU_out), 	///????????????????????????????????
		.DataOut      (Mem_Out)   
	);
	
	LUT Branch_Tables(
		.opcode(OP),
		.immediate(immediate),
		.Target(Target)
	);
	
// count number of instructions executed
always_ff @(posedge CLK)
  if (start == 1)	   // if(start)
  	cycle_ct <= 0;
  else if(halt == 0)   // if(!halt)
  	cycle_ct <= cycle_ct+16'b1;

always_ff @(posedge CLK)    // carry/shift in/out register
  if(sc_clr)				// tie sc_clr low if this function not needed
    SC_IN <= 0;             // clear/reset the carry (optional)
  else if(sc_en)			// tie sc_en high if carry always updates on every clock cycle (no holdovers)
    SC_IN <= SC_OUT;        // update the carry  

endmodule
