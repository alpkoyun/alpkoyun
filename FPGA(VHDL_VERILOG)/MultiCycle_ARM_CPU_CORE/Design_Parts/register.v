module register(input wire [7:0] in,output reg [7:0] outt,input clk);

initial begin
outt=0;

end
always@(posedge clk) begin
outt=in;
end


endmodule