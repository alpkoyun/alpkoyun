module Mux2x1 #(parameter W=4)(InA,InB,Select,Out);
			output [W-1:0] Out;
			input  wire[W-1:0] InA,InB;
			input Select;
			
				
				assign Out= Select ? InB: InA;
				
			
endmodule