module Wbit_mux_2305001 #(parameter W=4)(InA,InB,Select,Out);
			output reg [W-1:0] Out;
			input  wire[W-1:0] InA,InB;
			input  Select;
			
			always@(Select)begin
			Out= Select ? InB : InA;
			end
endmodule