//This file defines the parameters used in the alu
// CSE141L
package definitions;
    
// Instruction map
    const logic [3:0]kMOV  = 4'b0000;
    const logic [3:0]kXOR  = 4'b0001;
    const logic [3:0]kADD  = 4'b0010;
    const logic [3:0]kAND  = 4'b0011;
    const logic [3:0]kLSH  = 4'b0100;
    const logic [3:0]kRSH  = 4'b0101;
    const logic [3:0]kSTORE= 4'b0110;
    const logic [3:0]kLOAD = 4'b0111;
    const logic [3:0]kBRE  = 4'b1000;
    const logic [3:0]kJ    = 4'b1001;
    const logic [3:0]kCOMP = 4'b1010;
    const logic [3:0]kBRGT = 4'b1011;
    const logic [3:0]kSUB  = 4'b1100;
    const logic [3:0]kADDI = 4'b1101;
    const logic [3:0]kANDI = 4'b1110;
    const logic [3:0]kSHLR  = 4'b1111;

// enum names will appear in timing diagram
    typedef enum logic[3:0] {
	MOV, XOR, ADD, AND, LSH, RSH, STORE, LOAD, BRE, J, COMP, BRGT, SUB, ADDI, ANDI, SHLR
    } op_mne;
// note: kADD is of type logic[2:0] (3-bit binary)
//   ADD is of type enum -- equiv., but watch casting
//   see ALU.sv for how to handle this   
endpackage // definitions
