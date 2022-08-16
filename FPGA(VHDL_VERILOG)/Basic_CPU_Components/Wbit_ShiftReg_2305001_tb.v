module Wbit_ShiftReg_2305001_tb #(parameter W=4);
	reg[W-1:0] InA;
	reg [0:0] RES,CLK,InR,InL,PEN,LEN;
	wire[W-1:0] Out;
	Wbit_ShiftReg_2305001 uut(.InA(InA),.CLK(CLK),.Out(Out),.RES(RES),.InR(InR),.InL(InL),.PEN(PEN),.LEN(LEN));
	initial begin
		InA=4'b1100;
		CLK=0;
		RES=0;
		InR=0;
		InL=1;
		LEN=0;
		PEN=1;
		#5;
		CLK=1;
		#5;
		CLK=0;
		PEN=0;
		#5;
		CLK=1;
		#5;
		CLK=0;
		RES=1;
		#5;
		CLK=1;
		#5;
		CLK=0;
		RES=0;
		LEN=1;
		#5;
		CLK=1;
		#5;
		
   end
endmodule