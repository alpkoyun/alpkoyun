module pcregister(input wire [7:0] pc,output reg [7:0] pcout,input clk,input wen,input RST);

initial begin
pcout=0;

end
always@(posedge clk) begin
if(RST==1)begin
	pcout=0;
end
else begin
	if(wen==1'b1)
	pcout=pc;
	end




end


endmodule