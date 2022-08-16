module Wbit_regFile_2305001_tb #(parameter W=4);
	reg[W-1:0] InA;
	reg[1:0] Add0,Add1,Add2;
	reg [0:0] RES,CLK,WEN;
	wire[W-1:0] Out0,Out1;
	Wbit_regFile_2305001 uut(.InA(InA),.CLK(CLK),.Out0(Out0),.RES(RES),.Out1(Out1),.WEN(WEN),.Add0(Add0),.Add1(Add1),.Add2(Add2));
	initial begin
		InA=4'b1100;
		CLK=0;
		RES=0;
		Add2=0;
		WEN=1;
		#5;
		CLK=1;
		#5;
		CLK=0;
		InA=4'b0011;
		Add2=1;
		#5;
		CLK=1;
		#5;
		Add0=0;
		Add1=1;
		#5;
		CLK=0;
		Add2=3;
		InA=4'b0001;
		#5;
		CLK=1;
		#5;
		Add1=3;
		#5;
		CLK=0;
		RES=1;
		#5;
		CLK=1;
		#5;
		
		
   end
endmodule