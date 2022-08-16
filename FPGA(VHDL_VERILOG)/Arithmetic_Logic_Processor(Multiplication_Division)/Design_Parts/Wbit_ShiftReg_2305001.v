module Wbit_ShiftReg_2305001 #(parameter W=4)(InA,InR,InL,RES,CLK,Out,PEN,LEN);//PEN is parallel enable  LEN is left and right serial in	
	input wire[W-1:0] InA;
	input wire RES,CLK,PEN,LEN,InR,InL;
	output reg[W-1:0] Out;
	always@(posedge CLK)
	begin
	if(RES==1)
		Out[W-1:0]=0;
	else
		if(PEN==1)
			Out=InA;
		else begin
			if(LEN==0)
				Out={Out[W-2:0],InR};
			else
				Out={InL,Out[W-1:1]};
		end
	end

endmodule