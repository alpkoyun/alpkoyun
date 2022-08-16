module immediateExtender(input wire ImmSourceControl,
input wire [11:0]ImmediateSource,
output reg [31:0]Immediate);

always @(ImmSourceControl,ImmediateSource)begin
	if(ImmSourceControl==1)begin
	Immediate={20'h00000,ImmediateSource};
	end else begin
	Immediate={24'h000000,ImmediateSource[11:7]};
	
	end
	

end


endmodule