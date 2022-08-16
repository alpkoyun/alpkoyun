module Controltb #(parameter W = 4);
reg [3:0] Datain=4'b011;
reg clk=1'b0;
reg COMP=0;
reg CLR=0;
reg LOAD=0;
reg [2:0] OP=3'b000;
wire [3:0] R0out,R1out;

Controller uut(.OP(OP),.clk(clk),.LOAD(LOAD),.COMP(COMP),.CLR(CLR));
LAB2_2305001 uuut(.Datain(Datain),.R0out(R0out),.R1out(R1out));
initial begin
LOAD=1;
#50;
clk=~clk;
#50;
clk=~clk;
Datain=Datain+1;
#50;
clk=~clk;
#50;
clk=~clk;
OP=3'b000;
COMP=1;
clk=~clk;



end

endmodule