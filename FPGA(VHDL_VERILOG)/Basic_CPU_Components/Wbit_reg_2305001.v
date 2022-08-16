module Wbit_reg_2305001 #(parameter W=4)(InA,RES,CLK,Out);
	input wire[W-1:0] InA;
	input wire 	RES,CLK;
	output reg[W-1:0] Out;
	always@(posedge CLK)
	begin
	if(RES==1)
		Out[W-1:0]=0;
	else
		Out=InA;
	end

endmodule