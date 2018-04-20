`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: LambdaSpeak
// Engineer: Michael Wessel
// 
// Create Date:    01:43:46 02/01/2018
// Design Name: 
// Module Name:    Main 
// Project Name: LambdaSpeak 2
// Target Devices: XC9572XL 10TQ100 
// Tool versions: Xilinx WebPACK ISE 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Main(

	/// from CPC: 
	i_IORQ,
	i_RD,
	i_WR,
	// turned on when in amdrum mode: 
	i_AMDRUM, 
	
	iADR, 	
   ioCPC_DATA, 
	
	// to ATMega / from ATMega Data 
	
	iATMEGA_DATA, 
	oATMEGA_DATA, 	
	
	// CPC IOReq Write to FBEE 
	oSPEECH_WRITE_SSA_AND_AMDRUM,
	oSPEECH_WRITE_DK  
	
);

input [15:0] iADR; 
input i_IORQ; 
input i_RD; 
input i_WR; 
input i_AMDRUM; 

output oSPEECH_WRITE_SSA_AND_AMDRUM; 
output oSPEECH_WRITE_DK; 

inout  [7:0] ioCPC_DATA; 

input  [7:0] iATMEGA_DATA; 
output [7:0] oATMEGA_DATA; 

wire iorq = ~ i_IORQ; 
wire iord = ~ i_RD; 
wire iowr = ~ i_WR; 

wire read = iorq & iord; 
wire write = iorq & iowr; 

wire ssa_adr1   = iADR[15:0] == 16'hFBEE; 
wire ssa_adr2   = iADR[15:0] == 16'hFAEE; 
wire   dk_adr   = iADR[15:0] == 16'hFBFE; 
wire amdrum_adr = iADR[15:8] == 8'hFF; 

wire oSPEECH_READ      = ( ssa_adr1 | ssa_adr2 | dk_adr ) & read & ! i_AMDRUM ;

wire oSPEECH_WRITE_SSA_AND_AMDRUM = ( ssa_adr1 | ssa_adr2 | ( amdrum_adr & i_AMDRUM ) ) & write; 
wire oSPEECH_WRITE_DK             = dk_adr & write;  
wire oSPEECH_WRITE                = oSPEECH_WRITE_SSA_AND_AMDRUM | oSPEECH_WRITE_DK; 

reg [7:0] cpc_data = 0; 
reg [7:0] atmega_data = 0; 

assign oATMEGA_DATA = cpc_data;

// when decoder_write, store CPC databus byte in cpc_data 
always @(posedge oSPEECH_WRITE ) 
begin
	cpc_data <= ioCPC_DATA; 
end


always @(posedge oSPEECH_READ ) 
begin
	atmega_data <= iATMEGA_DATA; 
end


// make the output of the atmega data from pinc available to cpc when it wants to read it 

assign ioCPC_DATA    = oSPEECH_READ ? atmega_data : 8'bz; 

	 
endmodule

