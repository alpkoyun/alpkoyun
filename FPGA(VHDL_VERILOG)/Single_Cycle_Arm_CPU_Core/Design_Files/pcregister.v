module pcregister(input wire [31:0] pc,output reg [31:0] pcout,input clk);

initial begin
pcout=0;

end
always@(posedge clk) begin
pcout=pc;



end


endmodule