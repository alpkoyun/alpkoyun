module Mux4x1 #(parameter W=8)(InA,InB,InC,InD,Select,Out);
			output [W-1:0] Out;
			input  wire[W-1:0] InA,InB,InC,InD;
			input [1:0]Select;
				
				assign Out= Select[1] ? (Select[0] ? InD:InC ): (Select[0] ? InB:InA );
				
			
endmodule