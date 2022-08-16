module ALU_2305001(InA,InB,ALU_Control,Result,ZCo,Fwrite,clk);
			output reg[7:0] Result;
			output reg[1:0] ZCo;
			input wire signed [7:0] InA,InB;
			input Fwrite,clk;
			input wire [2:0] ALU_Control;
			reg [1:0] ZC;
			
			always@(posedge clk)begin
			if(Fwrite==1'b1)
				begin
				ZCo=ZC;
				end
			else begin
					ZCo=ZCo;
					end
			
			end
			always@(*)begin
				case(ALU_Control)
					3'b000:	begin 
									{ZC[1],Result[7:0]}=InA+InB;
			
								end
					3'b001:	begin
									{ZC[1],Result[7:0]}=InA-InB;
									
									
								end
												
					3'b010: begin Result=InA&InB;
								ZC[1]=ZC[1];
								end
					3'b011: begin Result=InA|InB;
								ZC[1]=ZC[1];
								end
					3'b100: begin Result=InA^InB;
									ZC[1]=ZC[1];
								end
					3'b101: begin Result=8'h00;
									ZC[1]=ZC[1];
								end
					3'b111: begin Result=InA;//shift
								ZC[1]=ZC[1];
								end
					
					default: begin Result=InA;
								ZC[1]=ZC[1];
								end
				endcase
				if(Result==0)ZC[0]=1;
				else ZC[0]=0;
		end		
		
endmodule