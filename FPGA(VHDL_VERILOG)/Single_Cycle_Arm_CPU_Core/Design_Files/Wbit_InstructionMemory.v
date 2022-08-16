module Wbit_InstructionMemory #(parameter W=4)(InA,clk,Out,Add,WEN);
input clk,WEN;
input unsigned [31:0] Add,InA;
output wire [31:0] Out;
wire [5:0] add;
reg [7:0] memory [63:0];
assign add=Add[5:0];
initial begin

$readmemh("Instructionmemory_data.txt",memory);


end


assign Out={memory[add+3],memory[add+2],memory[add+1],memory[add]};
always @(posedge clk)begin
//Out={memory[add]};

	if(WEN==1)
	begin
		{memory[add+3],memory[add+2],memory[add+1],memory[add]}=InA;

	end

end

endmodule