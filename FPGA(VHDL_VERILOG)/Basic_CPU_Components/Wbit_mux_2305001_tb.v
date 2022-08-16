module Wbit_mux_2305001_tb;
	reg [3:0] InA,InB;
	reg Select;
	wire[3:0]	Out;
	Wbit_mux_2305001 uut(.InA(InA),.InB(InB),.Out(Out),.Select(Select));
	initial begin
		InA=4'b1100;
		InB=4'b0011;
		Select=1'b0;
		#20;
		InA=4'b1100;
		InB=4'b0011;
		Select=1'b1;
		#20;
		InA=4'b1010;
		InB=4'b0011;
		Select=1'b1;
		#20;
   end
endmodule
