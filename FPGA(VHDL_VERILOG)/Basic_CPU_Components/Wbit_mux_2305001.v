module Wbit_mux_2305001 #(parameter W=4)(InA,InB,Select,Out);
			output [W-1:0] Out;
			input  wire[W-1:0] InA,InB;
			input Select;
			genvar i;
				
				assign Out= Select ? InB: InA;
				
			
endmodule