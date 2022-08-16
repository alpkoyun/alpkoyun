module Wbit_reg_2305001_tb #(parameter W=4);
	reg[W-1:0] InA;
	reg [0:0] RES,CLK;
	wire[W-1:0] Out;
	Wbit_reg_2305001 uut(.InA(InA),.CLK(CLK),.Out(Out),.RES(RES));
	initial begin
		InA=4'b1100;
		CLK=0;
		RES=0;
		#5;
		CLK=1;
		#20;
		CLK=0;
		#5;
		RES=1;
		#5;
		CLK=1;
		#5;
		CLK=0;
		RES=0;
		InA=4'b1010;
		#5;
		CLK=1;
		#20;
		
   end
endmodule