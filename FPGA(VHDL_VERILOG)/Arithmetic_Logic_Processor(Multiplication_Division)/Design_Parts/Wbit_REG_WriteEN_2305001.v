module Wbit_REG_WriteEN_2305001 #(parameter W=4)(InA,RES,CLK,Out,WEN);
	input wire[W-1:0] InA;
	input wire  RES,CLK,WEN;
	output reg[W-1:0] Out;
	always@(posedge CLK)
	begin
	if(RES==1)
		Out[W-1:0]=0;
	else
		if(WEN==1)
			Out=InA;
	end

endmodule