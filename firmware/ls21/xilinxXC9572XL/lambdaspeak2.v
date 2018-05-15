`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: LambdaSpeak
// Engineer: Michael Wessel
// 
// Create Date:    01:43:46 02/01/2018
// Design Name: 
// Module Name:    Main 
// Project Name: LambdaSpeak 2.1 
// Target Devices: XC9572XL 10TQ100 
// Tool versions: Xilinx WebPACK ISE 
// Description: With SPO256-AL2 Support
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
	
	// turned on when in SPO SSA1 or DKtronics mode :
	i_SPO256_SSA1, 
	i_SPO256_DKTRONICS, 

	// from SPO256 
	i_SPO256_SBY, 
	i_SPO256__LRQ, 
	
	iADR, 	
	ioCPC_DATA, 
	
	// to ATMega / from ATMega Data 
	
	iATMEGA_DATA, 
	oATMEGA_DATA, 	
	
	// CPC IOReq Write to FBEE or FBFE or FFxx
	oSPEECH_WRITE  
	
);

input [15:0] iADR; 
input i_IORQ; 
input i_RD; 
input i_WR; 

input i_AMDRUM; 

input i_SPO256_SSA1; 
input i_SPO256_DKTRONICS; 
input i_SPO256_SBY; 
input i_SPO256__LRQ; 

output oSPEECH_WRITE; 

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

wire oSPEECH_READ      = ( ssa_adr1 | ssa_adr2 | dk_adr ) & read & 
                           ! i_AMDRUM & ! i_SPO256_SSA1 & ! i_SPO256_DKTRONICS ;
									
wire oSPEECH_READ_SPO_SSA1       = ( ssa_adr1 | ssa_adr2 ) & read & ! i_AMDRUM & i_SPO256_SSA1 ;  

wire oSPEECH_READ_SPO_DKTRONICS  =  dk_adr & read & ! i_AMDRUM & i_SPO256_DKTRONICS ;  

wire oSPEECH_WRITE = ( ssa_adr1 | ssa_adr2 | dk_adr | ( amdrum_adr & i_AMDRUM ) ) & write; 															

reg [7:0] cpc_data = 0; 
reg [7:0] atmega_data = 0; 
reg [7:0] spo_status_ssa1 = 0; 
reg [7:0] spo_status_dktronics = 0; 

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


always @(posedge oSPEECH_READ_SPO_SSA1 ) 
begin
	spo_status_ssa1[7] <= i_SPO256_SBY ;
	spo_status_ssa1[6] <= i_SPO256__LRQ ; 
end


always @(posedge oSPEECH_READ_SPO_DKTRONICS ) 
begin
	spo_status_dktronics[6] <= i_SPO256_SBY ;
	spo_status_dktronics[7] <= i_SPO256__LRQ ; 
end

// make the output of the atmega data available to cpc when it wants to read it 
// this is either atmega output or spo output

assign ioCPC_DATA    = oSPEECH_READ ? atmega_data : 
                      ( oSPEECH_READ_SPO_SSA1 ? spo_status_ssa1 : 
		      ( oSPEECH_READ_SPO_DKTRONICS ? spo_status_dktronics : 8'bz ) ) ; 

	 
endmodule

