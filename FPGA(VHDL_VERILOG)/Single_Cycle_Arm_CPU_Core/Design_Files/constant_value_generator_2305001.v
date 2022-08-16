module constant_value_generator_2305001 #(parameter W=8, Value=4)(bus_out);
			output wire[W-1:0] bus_out;
			assign bus_out[W-1:0]=Value;	
endmodule