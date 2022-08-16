module Controller
#(parameter W = 4)
(input clk,
	input [2:0]OP,
	input LOAD,
	input COMP,
	input CLR,	
	output reg [1:0]R0muxsel,
	output reg Qmuxsel,
	output reg [1:0]Aluasel,
	output reg [1:0]R1muxsel,
	output reg Alubsel,
	output reg Accrst,
	output reg Accpl,
	output reg Qpl,
	output reg Qrst,
	output reg [2:0]Aluop,
	output wire [W-1:0]R0out,
	output wire Q0,
	output wire [3:0] Qout,
	output wire [W-1:0]R1out,
	input  wire [W-1:0] Datain,
	output wire [1:0] state,
	output wire [1:0] nextstate,
	output wire [1:0] Errorout,
	output wire [3:0] Accout,
	output reg Emuxsel,
	output wire [2:0] counter
	);
	reg [2:0] Scounter=4'b100;
	reg PrevCOMP=1'b0;
	reg Mulen=1'b0;
	reg Erst;
	reg R1rst;
	reg R1en;
	reg R0rst;
	reg R0en;
	reg [1:0] State=2'b00;
	reg [1:0] Nextstate=2'b00;
	localparam Normal=2'b00;
	localparam Mulstart=2'b01;
	localparam Mulcheck=2'b10;
	localparam Mulend=2'b11;
	assign counter=Scounter;
	assign state=State;
	assign nextstate=Nextstate;
	LAB2_2305001 uuut(.R0rst(R0rst),.R1rst(R1rst),.R0en(R0en),
	.R1en(R1en),.R0muxsel(R0muxsel),.R1muxsel(R1muxsel),.Aluasel(Aluasel),
	.Alubsel(Alubsel),.Aluop(Aluop),.clk(clk),.R0out(R0out),.R1out(R1out),
	.Datain(Datain),.Qmuxsel(Qmuxsel),.Errorout(Errorout),.Q0(Q0),.Qout(Qout),.Erst(Erst),
	.Qpl(Qpl),.Accpl(Accpl),.Accrst(Accrst),.Qrst(Qrst),.Emuxsel(Emuxsel),.Accout(Accout));
	always @(posedge clk)begin
	if(((State==Mulstart)&&(Nextstate==Mulstart))||((State==Mulcheck)&&(Nextstate==Mulstart)))begin
		Scounter=Scounter-3'b001;
		if(Scounter==0) begin
		State=Mulend;
		Scounter=4;
		end else begin
		State=Mulstart;
		end
	end else begin
	
	State=Nextstate;
	end
	
	end
	initial begin
			Qmuxsel<=1'b0;
			R0rst<=0;
			R1rst<=0;
			Erst<=0;
			Accrst<=0;
			Qrst<=0;
			R1en<=0;
			R0en<=0;
			Erst<=0;
			Nextstate<=2'b00;
			Emuxsel<=1;
	end 
	always@(*)begin
		
	if (State==Normal) begin
		if(COMP==0)begin 
			if(CLR==1)begin
				R0rst<=1;
				R1rst<=1;
				Erst<=1;
				Accrst<=1;
				Qrst<=1;
				Nextstate<=Normal;
			end else if(CLR==0) begin
				if(LOAD==1)begin
					R0muxsel<=2'b01;
					R0rst<=0;
					R1rst<=0;
					Erst<=0;
					Accrst<=0;
					Qrst<=0;
					R1muxsel<=2'b01;
					R1en<=1;
					R0en<=1;
					Nextstate<=Normal;
				end else begin
					R0en<=0;
					R1en<=0;
					Nextstate<=Normal;
				end
			end
		end
		if((COMP==1)&&(PrevCOMP==0))begin
				R0rst<=0;
			
				
			if((OP!=3'b010)&&(OP!=3'b011))begin
				R0en<=1;
				R1rst<=1;
				R0muxsel<=2'b00;
				Aluasel<=2'b00;
				Alubsel<=1'b1;
				Aluop<=OP;
				Nextstate<=Normal;
				if(OP==3'b111)Aluop<=3'b011;
			
			end
			if(OP==3'b010)begin
				Nextstate<=Mulstart;
				Qpl<=1;
				Qmuxsel<=1'b0;
				Aluasel<=2'b01;
				Alubsel<=1'b1;
				Aluop<=3'b001;
				R0muxsel<=2'b00;
				R0en<=1;
				Accrst<=1;
				Erst<=1;
			
			end
		end
		
  	end else if(State==Mulstart)begin
				Emuxsel<=1;
				R1en<=0;
				R0en<=0;
				R0rst<=0;
				R1rst<=0;
				Erst<=0;
				Accrst<=0;
				Qrst<=0;
		if(({Q0,Errorout[1]}==2'b00)||({Q0,Errorout[1]}==2'b11))begin
		
			Accpl<=0;
			Qpl<=0;
			Emuxsel<=0;
			
			 Nextstate<=Mulstart;
			
			end
		
		else if(({Q0,Errorout[1]}==2'b01))begin
			Nextstate<=Mulcheck;
			Accpl<=1;
			Qpl<=1;
			Qmuxsel<=1'b1;
			Alubsel<=1'b1;
			Aluasel<=2'b10;
			Aluop<=3'b000;
		
		
		
		end
		else if(({Q0,Errorout[1]})==2'b10)begin
			Nextstate<=Mulcheck;
			Accpl<=1;
			Qpl<=1;
			Qmuxsel<=1'b1;
			Alubsel<=1'b1;
			Aluasel<=2'b10;
			Aluop<=3'b001;
			
		end
	end else if(State==Mulcheck)begin
			Accpl<=0;
			Qpl<=0;
			
			Emuxsel<=0;
		
			Nextstate<=Mulstart;
		
	end else if(State==Mulend)begin
		Emuxsel<=1;
		Nextstate<=Normal;
		R0muxsel<=2'b10;
		R0en<=1;
		R1muxsel<=2'b10;
		R1en<=1;
	end else begin
	Nextstate<=Normal;
	end
	
end

endmodule