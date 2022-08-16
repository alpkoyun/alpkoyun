module controller(
output wire [1:0] ZC,
input clk,
input RUN,
input RST,
output wire [23:0] Instruction,
output wire [7:0] PrC,
output wire [7:0] ro1,
output wire [7:0] ro2,
output reg pcwrite,
output reg [1:0] Resultsel,
output reg [2:0] ALUcontrol,
output reg Destinationsel,
output reg Instwen,
output reg Regsel,
output reg Regwen,
output reg [1:0] Aluasel,
output reg [1:0] Alubsel,
output reg Flagw,
output reg datawen,
output reg [1:0] addsel,
output reg [1:0] state,
output reg [1:0] nextstate,
output reg fetchen,
output reg [2:0] Shftctrl,
output wire [7:0] Resultout
);
 
 wire [7:0] Instruct;
 wire [7:0] dataout;
 wire [7:0] Adress;
 wire [7:0] Memoryout;
 wire [7:0] R1;
 wire [7:0] R2;
 wire [7:0] Extended;
 reg MemoryWrite;
 
  
Datapath uut(.Aluasel(Aluasel),.Alubsel(Alubsel),.Regwen(Regwen),
.Instwen(Instwen),.Regsel(Regsel),.Destinationsel(Destinationsel),.ALUcontrol(ALUcontrol),
.Resultsel(Resultsel),.clk(clk),.Instruction(Instruction),.ZC(ZC),.datawen(datawen),.addsel(addsel),
.R1(R1),.R2(R2),.PrC(PrC),.ro1(ro1),.ro2(ro2),.pcwrite(pcwrite),.fetchen(fetchen),
.Shftctrl(Shftctrl),.Flagw(Flagw),.Resultout(Resultout),.Instruct(Instruct),.dataout(dataout),
.Adress(Adress),.RST(RST));

initial begin
Destinationsel=1'b0;
Regsel=1'b0;
datawen=1'b0;
Instwen=1'b0;
addsel=2'b00;
pcwrite=1'b1;
Aluasel=2'b01;
state=2'b00;
nextstate=2'b01;
Regwen=1'b0;
Flagw=0;

end




always@(posedge clk)begin
state=nextstate;


end


always@(*)begin
	if(RUN==0)begin
	Destinationsel=1'b0;
	Regsel=1'b0;
	datawen=1'b0;
	Instwen=1'b0;
	addsel=2'b00;
	pcwrite=1'b0;
	Aluasel=2'b01;
	
	nextstate=2'b00;
	Regwen=1'b0;
	Flagw=0;
	end
	else begin
		case(state)

			2'b00:begin
						Flagw=0;
						
						Instwen=0;
						addsel=2'b00;
						pcwrite=1'b1;
						Aluasel=2'b01;
						Alubsel=2'b10;
						ALUcontrol=3'b000;
						Resultsel=2'b00;
						fetchen=1'b1;
						Regwen=1'b0;
						nextstate=2'b01;
					end
				
		 
		 
			2'b01:begin// instructionlara göre ayır
						fetchen=0;
						Flagw=0;
						Instwen=0;
						addsel=2'b10;
						pcwrite=1'b0;
						datawen=1'b1;
						Aluasel=2'b01;
						Alubsel=2'b10;
						ALUcontrol=3'b000;
						
						nextstate=2'b10;
						case(Instruction[23:22])
						
						2'b00:begin
								
								Regsel=0;
								Destinationsel=0;
								Resultsel=2'b00;
								end
						
						2'b01:begin
								
								Regsel=0;
								Destinationsel=0;
								Resultsel=2'b00;
								end
						
						
						2'b10:begin
								Regsel=0;
								Destinationsel=1;
								Resultsel=2'b01;
								case(Instruction[10:8])
					
							3'b001:Regwen=(~ZC[1])&Instruction[21];//if C=0
							3'b010:Regwen=(~ZC[0])&Instruction[21];//if Z=0

							3'b100:Regwen=1'b1&Instruction[21];//unconditional
									
							3'b101:Regwen=(ZC[1])&Instruction[21];//ifc=1
							3'b110:Regwen=(ZC[0])&Instruction[21];//if z=1
										
							default:pcwrite=1'b0;
							
							endcase
								end	
						
						2'b11:begin
								
								Regsel=1;
								Destinationsel=0;
								Resultsel=2'b00;
									
								end
						
						endcase
						
						
						
				
					end
		 
			2'b10:begin
					fetchen=0;
					datawen=1'b0;
					nextstate=2'b00;
					
					
					
					case(Instruction[23:22])
					
					2'b00:begin
							pcwrite=0;
							Flagw=1;
							ALUcontrol=Instruction[10:8];
							Regwen=1'b1;
							Aluasel=2'b00;
							case(Instruction[20])
								1'b0:Alubsel=2'b00;
								1'b1:Alubsel=2'b11;
							endcase
							Resultsel=2'b00;
							end
					2'b01:begin
							pcwrite=0;
							Flagw=0;
							Regwen=1'b1;
							ALUcontrol=3'b111;
							Aluasel=2'b10;
							Shftctrl=Instruction[10:8];
							Resultsel=2'b00;
							end
					2'b10:begin
							Flagw=0;
							//checkconditions
							Regwen=1'b0;
							Resultsel[1]=1;
							Resultsel[0]=Instruction[20] ? 1:0;
							case(Instruction[10:8])
							3'b001:begin
									pcwrite=(~ZC[1]);//if C=0
									end
							3'b010:begin
									pcwrite=(~ZC[0]);//if Z=0
									end
							3'b100:begin
									pcwrite=1'b1;//unconditional
									end
							3'b101:begin
									pcwrite=(ZC[1]);//ifc=1
									end
							3'b110:begin
									pcwrite=(ZC[0]);//if z=1
									end
									
							default:pcwrite=1'b0;
							
							endcase
					
							end
					2'b11:begin
							Flagw=0;
							pcwrite=0;
							ALUcontrol=3'b000;
							Aluasel=2'b00;
							Alubsel=2'b01;
							case(Instruction[21])
							1'b0:begin
									addsel=2'b10;
									Instwen=1'b1;
									Regwen=1'b0;
									end
							1'b1:begin
									Instwen=0;
									Regwen=1'b1;
									Resultsel[1]=Instruction[8];//direct bit
									Resultsel[0]=Instruction[20]&Instruction[8];//Immediate
									
									end
							
							endcase
							end
					endcase
					end
				
			
			

			endcase
	end
end

endmodule