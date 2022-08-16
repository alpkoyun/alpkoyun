module Shifter(InA,Shift,Shiftout);
			output reg[7:0] Shiftout;
			
			input wire signed [7:0] InA;
			
			input wire [2:0] Shift;
			
			always@(*)begin
				case(Shift)
					3'b000: Shiftout={InA[6:0],InA[7]};//rotate left
					3'b001: Shiftout={InA[0],InA[7:1]};//rotate right
					3'b010: Shiftout={InA[6:0],1'b0};//shift left
					3'b011: Shiftout={1'b0,InA[7:1]};//shift right
					3'b100: Shiftout=InA>>>1'b1;
					default: Shiftout=InA;
				endcase
				
		end		
		
		
	
endmodule