module s_p
#(parameter WIDTH = 16)
(
    input clk, rst,
    input en,
    input signed [WIDTH-1:0] din0_real,
    input signed [WIDTH-1:0] din0_imag,

    output valid,
    output signed [WIDTH-1:0] dout0_real, dout0_imag,
    output signed [WIDTH-1:0] dout1_real, dout1_imag,
    output signed [WIDTH-1:0] dout2_real, dout2_imag,
    output signed [WIDTH-1:0] dout3_real, dout3_imag,
    output signed [WIDTH-1:0] dout4_real, dout4_imag,
    output signed [WIDTH-1:0] dout5_real, dout5_imag,
    output signed [WIDTH-1:0] dout6_real, dout6_imag,
    output signed [WIDTH-1:0] dout7_real, dout7_imag,
    output signed [WIDTH-1:0] dout8_real, dout8_imag,
    output signed [WIDTH-1:0] dout9_real, dout9_imag,
    output signed [WIDTH-1:0] dout10_real, dout10_imag,
    output signed [WIDTH-1:0] dout11_real, dout11_imag,
    output signed [WIDTH-1:0] dout12_real, dout12_imag,
    output signed [WIDTH-1:0] dout13_real, dout13_imag,
    output signed [WIDTH-1:0] dout14_real, dout14_imag,
    output signed [WIDTH-1:0] dout15_real, dout15_imag,
	
	output en_flag,
	output [4:0] count
);

    integer i;
    // shift registers for storing data
    reg signed [WIDTH-1:0] shift_real [0:19];
    reg signed [WIDTH-1:0] shift_imag [0:19];

    reg en_flag;
    reg valid;
    reg [4:0] count;

    always @(posedge clk) begin
        if(rst) begin
            en_flag <= 0;
            count <= 0;

            for(i=0; i<=19; i=i+1) begin
                shift_real[i] <= 0;
                shift_imag[i] <= 0;
            end
        end
        else if(en == !en_flag) begin
            en_flag <= ~en_flag; // 1 <-> 0

            if(count == 19) begin
                count <= 0;
            end
            else count <= count + 1;

            shift_real[19] <= din0_real;
            shift_imag[19] <= din0_imag;
            for(i=18; i>=0; i=i-1) begin
                shift_real[i] <= shift_real[i+1];
                shift_imag[i] <= shift_imag[i+1];
            end
        end
    end

    // output valid
    always @(posedge clk) begin
        if(rst) begin
            valid <= 0;
        end
        else if(count == 19) begin
            valid <= 1;
        end
        else begin
            valid <= 0;
        end
    end

    /* cyclic prefix removal */
    // output real
    assign dout0_real = shift_real[4];
    assign dout1_real = shift_real[5];
    assign dout2_real = shift_real[6];
    assign dout3_real = shift_real[7];
    assign dout4_real = shift_real[8];
    assign dout5_real = shift_real[9];
    assign dout6_real = shift_real[10];
    assign dout7_real = shift_real[11];

    assign dout8_real = shift_real[12];
    assign dout9_real = shift_real[13];
    assign dout10_real = shift_real[14];
    assign dout11_real = shift_real[15];
    assign dout12_real = shift_real[16];
    assign dout13_real = shift_real[17];
    assign dout14_real = shift_real[18];
    assign dout15_real = shift_real[19];

    // output imag
    assign dout0_imag = shift_imag[4];
    assign dout1_imag = shift_imag[5];
    assign dout2_imag = shift_imag[6];
    assign dout3_imag = shift_imag[7];
    assign dout4_imag = shift_imag[8];
    assign dout5_imag = shift_imag[9];
    assign dout6_imag = shift_imag[10];
    assign dout7_imag = shift_imag[11];

    assign dout8_imag = shift_imag[12];
    assign dout9_imag = shift_imag[13];
    assign dout10_imag = shift_imag[14];
    assign dout11_imag = shift_imag[15];
    assign dout12_imag = shift_imag[16];
    assign dout13_imag = shift_imag[17];
    assign dout14_imag = shift_imag[18];
    assign dout15_imag = shift_imag[19];

    
endmodule