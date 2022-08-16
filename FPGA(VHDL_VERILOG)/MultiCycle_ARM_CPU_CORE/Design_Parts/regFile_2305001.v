module regFile(wdata,CLK,Out0,Out1,Add0,Add1,Add2,PC8,WEN,ro1,ro2);
	input wire[7:0] wdata;
	input wire[7:0] PC8;
	input wire  CLK,WEN;
	input wire [3:0] Add0,Add1,Add2;
	output wire[7:0] Out0,Out1,ro1,ro2;
	reg [7:0] data [14:0];
	wire [7:0] dataw [15:0];
	genvar i;
	generate
	for(i=0;i<15;i=i+1)begin:stage
	assign dataw[i]=data[i];
	
	end
	endgenerate
	assign dataw[15]=PC8;
	assign Out0=dataw[Add0];
	assign Out1=dataw[Add1];
	assign ro1=data[1];
	assign ro2=data[2];
	integer a;
	initial begin
	
	for(a=0;a<15;a=a+1)begin
	data[a]=8'h00;
	end
	
	end
	always@(posedge CLK)
	begin
			if(WEN==1)begin
				data[Add2]=wdata;
				end
	end

endmodule