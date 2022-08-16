module Wbit_ALU_2305001(InA,InB,ALU_Control,clk,Result,Flag,Flagwrite);
			output reg[31:0] Result;
			output reg Flag;
			input clk;
			input wire signed [31:0] InA,InB;
			input wire Flagwrite;
			input wire [2:0] ALU_Control;
			wire unsigned [31:0] sb;
			reg PrevFlag;
			assign sb=InB;
			
			initial begin
			PrevFlag=0;
			Flag=0;
			end
			
			always@(*)begin
				case(ALU_Control)
					3'b000:	begin 
									Result[31:0]=InA+InB;
			
								end
					3'b001:	begin
									Result[31:0]=InA-InB;
									if(Result==32'h00000000)begin PrevFlag=1'b1;end
									else begin  PrevFlag=1'b0;   end
									
								end
												
					3'b010: Result=InA&InB;
					3'b011: Result=InA|InB;
					3'b100: Result=InA>>sb;		
					3'b101: Result=InA<<sb;
					default: Result=InA;
				endcase
				
		end		
		
		
		always@(posedge clk)
		begin
		if(Flagwrite==1)
		Flag=PrevFlag;
		end
endmodule