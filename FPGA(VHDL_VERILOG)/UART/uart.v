/*
 * Milkymist VJ SoC
 * Copyright (C) 2007, 2008, 2009, 2010 Sebastien Bourdeauducq
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

module uart #(
	parameter csr_addr = 4'h0,
	parameter clk_freq = 100000000,
	parameter baud = 115200
) (
	input sys_clk,
	input sys_rst,
	input uart_rx,
	output uart_tx
);

reg [15:0] divisor=clk_freq/baud/16;
wire [7:0] rx_data;
reg [7:0] tx_data=8'h41;
reg tx_wr=1'b0;
reg [31:0] enableclk_counter=clk_freq;
wire enable0;
assign enable0 = (enableclk_counter == 32'd0);

wire tx_done;
wire rx_done;

uart_transceiver transceiver(
	.sys_clk(sys_clk),
	.sys_rst(sys_rst),

	.uart_rx(uart_rx),
	.uart_tx(uart_tx),

	.divisor(divisor),

	.rx_data(rx_data),

	.tx_data(tx_data),
	.tx_wr(tx_wr)
);





always @(posedge sys_clk) begin
	if(sys_rst)
		enableclk_counter <= clk_freq - 32'b1;
	else begin
		enableclk_counter <= enableclk_counter - 16'd1;
		if(enable0)
			enableclk_counter <= clk_freq - 32'b1;
	end
end

always @(posedge sys_clk) begin
		
	 if(enable0)begin
	   tx_wr<=1;
	 
		
	end
	else begin
	 tx_wr<=0;
	end
end

endmodule
