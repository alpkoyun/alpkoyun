`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/16/2022 12:43:44 AM
// Design Name: 
// Module Name: Master
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Master(ss,sck,dout,dc,rst,clk,LED
    );
    output reg rst=1'b1;
    input clk;
    output reg LED=1;
    reg rstb=1;
    reg start=1'b0;
    reg [7:0] tdat=8'hAA;  //transmit data
    reg startup=1'b1;
	reg din=1'b0;
	output wire ss; 
	
	output wire sck; 
	output wire dout;
	output reg dc ;
	wire doneout;
	reg donestate=1;
    wire done;
   
    wire [7:0] rdata; //received data
    reg [1:0] state=2'b00;
    parameter starting=2'b00;
    parameter sending=2'b01;
    reg nextstate=2'b00;
    reg [2:0] counter=3'b000;
    reg [7:0] cmdarray [7:0];
    reg [7:0] dataarray [7:0];
    reg [9:0] waitcounter =1023; 
    reg  [1:0] tempnextstate=2'b00;
    wire count0;
    reg [31:0] ledcounter=100_000_000;
   spii_master uut(.rstb(rstb),.clk(clk),.start(start),.tdat(tdat)
   ,.din(din),.ss(ss),.sck(sck),.dout(dout),.done(done),.rdata(rdata));
   initial begin
   /*
   dataarray[0]<=8'hAA;
   dataarray[1]<=8'hAA;
   dataarray[2]<=8'hAA;
   dataarray[3]<=8'hAA;
   dataarray[4]<=8'hAA;
   dataarray[5]<=8'hAA;
   dataarray[6]<=8'hAA;
   dataarray[7]<=8'hAA;     
  
 
   cmdarray[0]<=8'hA6;
   cmdarray[1]<=8'hA6;
   cmdarray[2]<=8'hA6;
   cmdarray[3]<=8'hA6;
   cmdarray[4]<=8'hA6;
   cmdarray[5]<=8'hA6;
   cmdarray[6]<=8'hA6;
   cmdarray[7]<=8'hA6; 
  
   
   cmdarray[0]<=8'h21;
   cmdarray[1]<=8'hc6;
   cmdarray[2]<=8'h04;
   cmdarray[3]<=8'h14;
   cmdarray[4]<=8'h20;
   cmdarray[5]<=8'h0c;
   cmdarray[6]<=8'h40;
   cmdarray[7]<=8'h83;
   */
   $readmemh("data.mem",dataarray);
   $readmemh("cmd.mem",cmdarray);
   end
   

  assign doneout=donestate || done;
  assign counter0= (ledcounter==0);

  
 
  
   always@(posedge clk)begin
            if(state!=2'b10)
                waitcounter=1023;
            else waitcounter=waitcounter-1;
            
            if(startup==1)
                start<=1;
            else
                start<=1'b0;
                
                if(doneout==1)begin
                  if(donestate == 1'b1)begin
                      state<=tempnextstate;
                      startup<=1;
                      if(counter==3'b111)
                            counter<=0;
                      else
                            counter<=counter+1;
                    end
                  else begin
                  startup<=0;
                  state<=2'b10;
                  end
                end
                else begin                 
                    startup<=0;
                end
                 
             ledcounter<=ledcounter-1;
                if(counter0==1)begin
                    ledcounter<=100_000_000;
                    LED<=~LED;
                    end
                    
                    
                   case(nextstate)
                   2'b00:begin
                            if(donestate==1)
                            tdat<=cmdarray[counter+1];
                            else
                            tdat<=cmdarray[counter];
                   end
                   2'b01:begin
                             if(donestate==1)
                            tdat<=dataarray[counter+1];
                            else
                            tdat<=dataarray[counter];
                            end
                   2'b10:begin
                    tdat<=dataarray[0];
                   
                   end
                   default: tdat<=dataarray[0];
                   endcase
   
 end
   
   
   
   always@(counter,state,waitcounter,start)begin
   case (state)
   
   2'b00:begin
                donestate<=0;  
                
                dc<=0;
                if(counter==3'b111)begin
                tempnextstate<=2'b01;
                nextstate<=2'b01;
            end
            else begin nextstate<=2'b00;
                tempnextstate<=2'b00;
            end
            
            end
            
   2'b10:begin
               
            
             if(waitcounter==0)begin
                donestate<=1;
                nextstate<=tempnextstate;
                end
             else begin
             donestate<=0;nextstate=2'b10;
             end
            end
   2'b01:begin
            donestate<=0;  
            dc<=1;
            
            tempnextstate<=2'b01;
            nextstate<=2'b01;
            end
   
   default:begin
              
               end
   
   endcase
    
    end
    
    
endmodule
