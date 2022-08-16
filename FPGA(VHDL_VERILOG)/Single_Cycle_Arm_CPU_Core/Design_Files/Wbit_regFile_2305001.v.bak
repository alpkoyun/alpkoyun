module Wbit_regFile_2305001 #(parameter W=4)(InA,RES,CLK,Out0,Out1,Add0,Add1,Add2,WEN);
	input wire[W-1:0] InA;
	input wire [0:0] RES,CLK,WEN;
	input wire [1:0] Add0,Add1,Add2;
	output wire[W-1:0] Out0,Out1;
	reg [W-1:0] data [3:0];
	assign Out0=data[Add0];
	assign Out1=data[Add1];
	always@(posedge CLK)
	begin
		if(RES==1)begin
			data[0]<=0;
			data[1]<=0;
			data[2]<=0;
			data[3]<=0;
			end
		else
			if(WEN==1)
				data[Add2]<=InA;
	end

endmodule