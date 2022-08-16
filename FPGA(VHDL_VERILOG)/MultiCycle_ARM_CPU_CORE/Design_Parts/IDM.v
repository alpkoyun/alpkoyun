module IDM(Data,clk,Out,Add,wen);
input clk,wen;
input unsigned [7:0] Add,Data;
output wire [23:0] Out;
reg [7:0] memory [255:0];
initial begin
$readmemb("memorysorted1.txt",memory);
end

assign Out={memory[Add+2],memory[Add+1],memory[Add]};
always @(posedge clk)begin
	if(wen==1)
	begin
		memory[Add]=Data;

	end
end

endmodule