module router(
    output  [31:0] d_in,
    input   [15:0] data_1,
	input   [15:0] data_2
);
    
    assign d_in={data_1,data_2};

endmodule