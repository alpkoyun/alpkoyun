module controller(
output wire Flag,
input clk,
output wire [31:0] Instruction,
output wire [31:0] PrC,
output wire [31:0] ro1,
output wire [31:0] ro2
);
 wire [31:0] Memoryout;
 wire [31:0] R1;
 wire [31:0] R2;
 wire [31:0] ALUout;
 wire [31:0] Extended;
reg MemoryWrite;
 reg Resultsel;
 reg ImmSourceControl;
 reg [2:0] ALUcontrol;
 reg Instwen;
 reg Regsel;
 reg Regwen;
 reg rst;
 reg Aluasel;
 reg Alubsel;
 reg Flagwrite;
 reg [31:0] Instdatain;
Datapath uut(.Flagwrite(Flagwrite),.Aluasel(Aluasel),.Alubsel(Alubsel),.Regwen(Regwen),
.Instwen(Instwen),.Regsel(Regsel),.ALUcontrol(ALUcontrol),.ImmSourceControl(ImmSourceControl),
.Resultsel(Resultsel),.MemoryWrite(MemoryWrite),.clk(clk),.Instruction(Instruction),
.R1(R1),.R2(R2),.PrC(PrC),.ALUout(ALUout),.Memoryout(Memoryout),
.ro1(ro1),.ro2(ro2),.rst(rst),.Extended(Extended),.Flagg(Flag));

initial begin
rst=0;
Regwen=0;
MemoryWrite=0;
Instwen=0;

end
always@(*)begin

case(Instruction[27:26])
	2'b00:begin
			case(Instruction[25:20])
			
			6'b001000:begin//ADD
				Instwen=0;
				Regsel=0;
				Regwen=1;
				Aluasel=0;
				Alubsel=0;
				ALUcontrol=3'b000;
				Flagwrite=0;
				MemoryWrite=0;
				Resultsel=1;
						end
			6'b000100:begin//sub
						Instwen=0;
						Regsel=0;
						Regwen=1;
						Aluasel=0;
						Alubsel=0;
						ALUcontrol=3'b001;
						Flagwrite=0;
						MemoryWrite=0;
						Resultsel=1;
						end
						
			6'b000000:begin//and
						Instwen=0;
						Regsel=0;
						Regwen=1;
						Aluasel=0;
						Alubsel=0;
						ALUcontrol=3'b010;
						Flagwrite=0;
						MemoryWrite=0;
						Resultsel=1;
						end
			6'b011000:begin//orr
						Instwen=0;
						Regsel=0;
						Regwen=1;
						Aluasel=0;
						Alubsel=0;
						ALUcontrol=3'b011;
						Flagwrite=0;
						MemoryWrite=0;
						Resultsel=1;
						end
			6'b010101:begin//cmp
						Instwen=0;
						Regsel=0;
						Regwen=0;
						Aluasel=0;
						Alubsel=0;
						ALUcontrol=3'b001;
						Flagwrite=1;
						MemoryWrite=0;
						Resultsel=1;
						end
			6'b011010:begin//lsl lslr
			
							case(Instruction[6:5])
							
							2'b00:begin//lsl
									Instwen=0;
									Regsel=0;
									Regwen=1;
									Aluasel=1;
									Alubsel=1;
									ALUcontrol=3'b101;
									Flagwrite=0;
									MemoryWrite=0;
									Resultsel=1;
									ImmSourceControl=0;
							
									end
							
							2'b01: begin//lsr
									Instwen=0;
									Regsel=0;
									Regwen=1;
									Aluasel=1;
									Alubsel=1;
									ALUcontrol=3'b100;
									Flagwrite=0;
									MemoryWrite=0;
									Resultsel=1;
									ImmSourceControl=0;
									end
							default:begin
							Regwen=0;
							MemoryWrite=0;
							Instwen=0;
							Flagwrite=0;
							end
							
			
					endcase
				end
			default:begin
				Regwen=0;
				MemoryWrite=0;
				Instwen=0;
				Flagwrite=0;
				end
			
			endcase
		end
	
	
	
	2'b01:begin
		
		case(Instruction[25:20])
		
		6'b011000:begin//str
					Instwen=0;
					Regsel=1;
					Regwen=0;
					Aluasel=0;
					Alubsel=1;
					ALUcontrol=3'b000;
					Flagwrite=0;
					MemoryWrite=1;
					Resultsel=1;
					ImmSourceControl=1;
					end
		6'b011001:begin //ldr
					Instwen=0;
					Regsel=1;
					Regwen=1;
					Aluasel=0;
					Alubsel=1;
					ALUcontrol=3'b000;
					Flagwrite=0;
					MemoryWrite=0;
					Resultsel=0;
					ImmSourceControl=1;
		
					end
		default:begin
				Regwen=0;
				MemoryWrite=0;
				Instwen=0;
				Flagwrite=0;
				end
		
		endcase
		
		end
	default:begin
				Regwen=0;
				MemoryWrite=0;
				Instwen=0;
				Flagwrite=0;
				end
endcase

end

endmodule