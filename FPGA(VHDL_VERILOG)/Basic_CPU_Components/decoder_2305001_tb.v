module decoder_tb_v;
    reg [1:0] Din;
    wire [3:0] Dout;
    
    decoder_2305001 uut(
        .Dout(Dout), 
        .Din(Din)
    );
    initial begin
        // Initialize Inputs
        
        Din =2'b00; #20;
        Din = 2'b01; #20;
          Din = 2'b10; #20;
        Din = 2'b11; #20;
    end
endmodule