module fetchregister(input wire [23:0] pc,output reg [23:0] pcout,input clk,input wen);

initial begin
pcout=0;

end
always@(posedge clk) begin
if(wen==1'b1)
pcout=pc;



end


endmodule