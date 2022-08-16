module Wbit_ALU_2305001 #(parameter W=5)(InA,InB,ALU_Control,Result,NZCV);
			output reg[W-1:0] Result;
			output reg[3:0] NZCV;
			input wire signed [W-1:0] InA,InB;
			input [2:0] ALU_Control;
			always@(InA, InB, ALU_Control)begin
				case(ALU_Control)
					3'b000:	begin 
									{NZCV[1],Result[W-1:0]}=InA+InB;
									if(((InA[W-1]==0)&(InB[W-1]==0)&(Result[W-1]==1))|(((InA[W-1]==1)&(InB[W-1]==1)&(Result[W-1]==0))))
										NZCV[0]=1;
									else NZCV[0]=0;
								end
					3'b001:	begin
									{NZCV[1],Result[W-1:0]}=InA-InB;
									if(((InA[W-1]==1)&(InB[W-1]==0)&(Result[W-1]==0))|((InA[W-1]==0)&(InB[W-1]==1)&(Result[W-1]==1)))
										NZCV[0]=1;
									else NZCV[0]=0;
								end
					3'b010: begin
									{NZCV[1],Result[W-1:0]}=InB-InA;
									if(((InA[W-1]==1)&(InB[W-1]==0)&(Result[W-1]==0))|((InA[W-1]==0)&(InB[W-1]==1)&(Result[W-1]==1)))
										NZCV[0]=1;
									else NZCV[0]=0;
								end
					3'b011: Result=InA&(~InB);
					3'b100: Result=InA&InB;
					3'b101: Result=InA|InB;
					3'b110: Result=InA^InB;
					3'b111: Result=~(InA^InB);
					default: Result=InA;
				endcase
				if(Result[W-1]==1)NZCV[3]=1;
				else NZCV[3]=0 ;
				if(Result==0)NZCV[2]=1;
				else NZCV[2]=0;
				if(ALU_Control>2)
				NZCV[1:0]='b00;
			end		
endmodule