module Wbit_regFile_2305001 #(parameter W=32)(InA,RES,CLK,Out0,Out1,Add0,Add1,Add2,WEN,ro1,ro2);
	input wire[W-1:0] InA;
	input wire  RES,CLK,WEN;
	input wire [3:0] Add0,Add1,Add2;
	output wire[W-1:0] Out0,Out1,ro1,ro2;
	reg [W-1:0] data [15:0];
	assign Out0=data[Add0];
	assign Out1=data[Add1];
	assign ro1=data[1];
	assign ro2=data[2];
	integer i;
	initial begin
	
	for(i=0;i<16;i=i+1)begin
	data[i]=32'h00000000;
	end
	
	end
	always@(posedge CLK)
	begin
		if(RES==1)begin
			for(i=0;i<16;i=i+1)begin
				data[i]=0;
			end
			
			end
		else
			if(WEN==1)begin
				data[Add2]=InA;
				end
	end

endmodule