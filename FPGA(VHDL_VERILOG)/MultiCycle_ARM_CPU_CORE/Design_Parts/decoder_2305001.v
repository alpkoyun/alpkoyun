module decoder_2305001(Dout, Din);
    input [1:0] Din;
    output [3:0] Dout;
    
    reg [3:0] Dout;
    
    always @(Din)
    begin
        
       
			if (Din == 2'b00)
				 Dout= 4'b0001;
			else if (Din == 2'b01)
				 Dout= 4'b0010;
			else if (Din == 2'b10)
				 Dout = 4'b0100;
			else if (Din == 2'b11)
				 Dout = 4'b1000;
        
    end
endmodule