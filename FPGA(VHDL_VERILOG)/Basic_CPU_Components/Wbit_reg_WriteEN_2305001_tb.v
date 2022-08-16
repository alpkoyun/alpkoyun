module Wbit_reg_WriteEN_2305001_tb #(parameter W=4);
	reg[W-1:0] InA;
	reg  RES,CLK,WEN;
	wire[W-1:0] Out;
	Wbit_REG_WriteEN_2305001 uut(.InA(InA),.CLK(CLK),.Out(Out),.RES(RES),.WEN(WEN));
	initial begin
		InA=4'b1100;
		CLK=0;
		RES=0;
		WEN=0;
		#5;
		CLK=1;
		#5;
		CLK=0;
		WEN=1;
		#5;
		CLK=1;
		#5;
		CLK=0;
		RES=1;
		#5;
		CLK=1;
		#5;
		
   end
endmodule