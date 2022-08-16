module Wbit_ALU_2305001_tb #(parameter W=5);
	reg signed[W-1:0] InA,InB;
	reg [2:0] ALU_Control;

	wire [3:0] NZCV;
	wire [W-1:0] Result;
	 
	Wbit_ALU_2305001 uut(.InA(InA),.InB(InB),.Result(Result),.ALU_Control(ALU_Control),.NZCV(NZCV));
	initial begin
		InA=4;
		InB=3;
		ALU_Control=2;
		#20;
		InA=4;
		InB=3;
		ALU_Control=3;
		#20;
		InA=4;
		InB=5;
		ALU_Control=4;
		#20;
		InA=4;
		InB=5;
		ALU_Control=5;
		#20;
		InA=5'b11111;
		InB=5'b11111;
		ALU_Control=6;
		#20;
		InA=5'b00101;
		InB=5'b11100;
		ALU_Control=7;
		#20;
		InA=5'b00101;
		InB=5'b11100;
		ALU_Control=1;
		#20;
		InB=5'b00101;
		InA=5'b11100;
		ALU_Control=1;
		#20;
		InA=5'b00101;
		InB=5'b11110;
		ALU_Control=1;
		#20;
		InA=5'b11111;
		InB=5'b11100;
		ALU_Control=1;
		#20;
		InA=5'b11111;
		InB=5'b00001;
		ALU_Control=0;
		#20;
		InA=5'b11111;
		InB=5'b11111;
		ALU_Control=1;
		#20;
	end
endmodule
