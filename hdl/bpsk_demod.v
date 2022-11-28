module bpsk_demod
#(
    parameter WIDTH = 16,
    parameter FFT_SIZE = 16
)
(
    input signed [WIDTH-1:0] din0_real,
    input signed [WIDTH-1:0] din1_real,
    input signed [WIDTH-1:0] din2_real,
    input signed [WIDTH-1:0] din3_real,
    input signed [WIDTH-1:0] din4_real,
    input signed [WIDTH-1:0] din5_real,
    input signed [WIDTH-1:0] din6_real,
    input signed [WIDTH-1:0] din7_real,
    input signed [WIDTH-1:0] din8_real,
    input signed [WIDTH-1:0] din9_real,
    input signed [WIDTH-1:0] din10_real,
    input signed [WIDTH-1:0] din11_real, 
    input signed [WIDTH-1:0] din12_real, 
    input signed [WIDTH-1:0] din13_real, 
    input signed [WIDTH-1:0] din14_real, 
    input signed [WIDTH-1:0] din15_real,

    output [FFT_SIZE-1:0] dout0_real

);


    // operating data
    wire signed [WIDTH-1:0] din_real [0:FFT_SIZE-1];
    assign din_real[0] = din0_real;
    assign din_real[1] = din1_real;
    assign din_real[2] = din2_real;
    assign din_real[3] = din3_real;
    assign din_real[4] = din4_real;
    assign din_real[5] = din5_real;
    assign din_real[6] = din6_real;
    assign din_real[7] = din7_real;
    assign din_real[8] = din8_real;
    assign din_real[9] = din9_real;
    assign din_real[10] = din10_real;
    assign din_real[11] = din11_real;
    assign din_real[12] = din12_real;
    assign din_real[13] = din13_real;
    assign din_real[14] = din14_real;
    assign din_real[15] = din15_real;

    /*
    bpsk demodulation:
    data_demod_p(real(data_demod_p)>0) = 0;
    data_demod_p(real(data_demod_p)<0) = 1;
    */
    
    integer i;
    reg [FFT_SIZE-1:0] dout_real;
    reg signed [WIDTH-1:0] din_real_temp;

    always @(*) begin
        for(i=0; i<=FFT_SIZE-1; i=i+1) begin
            din_real_temp = din_real[i];
            dout_real[i] = (din_real_temp[WIDTH-1] == 0)? 0:1;
        end
    end


    // output
    assign dout0_real = dout_real;

endmodule