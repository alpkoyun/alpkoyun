module Wbit_Datamemory #(parameter W=32)(InA,clk,Out,Add,WEN);
input clk,WEN;
input [31:0] Add,InA;
output wire [31:0] Out;

reg [7:0] dmemory [63:0];



initial begin
$readmemh("Datamemory_data.txt",dmemory);
end

assign Out={dmemory[Add+3],dmemory[Add+2],dmemory[Add+1],dmemory[Add]};

always @(posedge clk)begin

	if(WEN==1)
	begin
		{dmemory[Add+3],dmemory[Add+2],dmemory[Add+1],dmemory[Add]}=InA;

	end

end


endmodule