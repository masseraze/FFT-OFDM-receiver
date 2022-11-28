module top
#(
    parameter WIDTH = 16,
    parameter FFT_SIZE = 16
)
(
    input clk, rst,
    input en,
    input signed [WIDTH-1:0] din0_real,
    input signed [WIDTH-1:0] din0_imag,

    output valid,
    output [FFT_SIZE-1:0] dout0_real

);

    wire signed [WIDTH-1:0] d_real [0:2][0:FFT_SIZE-1];
    wire signed [WIDTH-1:0] d_imag [0:1][0:FFT_SIZE-1];
    
    wire [1:0] d_en;

    s_p s_p(
        .clk(clk), .rst(rst),
        .en(en),
        .din0_real(din0_real), .din0_imag(din0_imag),

        .valid(d_en[0]),
        .dout0_real(d_real[0][0]), .dout0_imag(d_imag[0][0]),
        .dout1_real(d_real[0][1]), .dout1_imag(d_imag[0][1]), 
        .dout2_real(d_real[0][2]), .dout2_imag(d_imag[0][2]), 
        .dout3_real(d_real[0][3]), .dout3_imag(d_imag[0][3]), 
        .dout4_real(d_real[0][4]), .dout4_imag(d_imag[0][4]), 
        .dout5_real(d_real[0][5]), .dout5_imag(d_imag[0][5]), 
        .dout6_real(d_real[0][6]), .dout6_imag(d_imag[0][6]), 
        .dout7_real(d_real[0][7]), .dout7_imag(d_imag[0][7]), 
        .dout8_real(d_real[0][8]), .dout8_imag(d_imag[0][8]), 
        .dout9_real(d_real[0][9]), .dout9_imag(d_imag[0][9]), 
        .dout10_real(d_real[0][10]), .dout10_imag(d_imag[0][10]), 
        .dout11_real(d_real[0][11]), .dout11_imag(d_imag[0][11]), 
        .dout12_real(d_real[0][12]), .dout12_imag(d_imag[0][12]), 
        .dout13_real(d_real[0][13]), .dout13_imag(d_imag[0][13]), 
        .dout14_real(d_real[0][14]), .dout14_imag(d_imag[0][14]), 
        .dout15_real(d_real[0][15]), .dout15_imag(d_imag[0][15])

    );

    fft16 fft16(
        .clk(clk), .rst(rst),
        .en(d_en[0]),

        .x0_real(d_real[0][0]), .x0_imag(d_imag[0][0]),
        .x1_real(d_real[0][1]), .x1_imag(d_imag[0][1]), 
        .x2_real(d_real[0][2]), .x2_imag(d_imag[0][2]), 
        .x3_real(d_real[0][3]), .x3_imag(d_imag[0][3]), 
        .x4_real(d_real[0][4]), .x4_imag(d_imag[0][4]), 
        .x5_real(d_real[0][5]), .x5_imag(d_imag[0][5]), 
        .x6_real(d_real[0][6]), .x6_imag(d_imag[0][6]), 
        .x7_real(d_real[0][7]), .x7_imag(d_imag[0][7]), 
        .x8_real(d_real[0][8]), .x8_imag(d_imag[0][8]), 
        .x9_real(d_real[0][9]), .x9_imag(d_imag[0][9]),
        .x10_real(d_real[0][10]), .x10_imag(d_imag[0][10]),
        .x11_real(d_real[0][11]), .x11_imag(d_imag[0][11]),
        .x12_real(d_real[0][12]), .x12_imag(d_imag[0][12]),
        .x13_real(d_real[0][13]), .x13_imag(d_imag[0][13]),
        .x14_real(d_real[0][14]), .x14_imag(d_imag[0][14]),
        .x15_real(d_real[0][15]), .x15_imag(d_imag[0][15]),
        
        .valid(d_en[1]),

        .y0_real(d_real[1][0]), .y0_imag(d_imag[1][0]),
        .y1_real(d_real[1][1]), .y1_imag(d_imag[1][1]), 
        .y2_real(d_real[1][2]), .y2_imag(d_imag[1][2]), 
        .y3_real(d_real[1][3]), .y3_imag(d_imag[1][3]), 
        .y4_real(d_real[1][4]), .y4_imag(d_imag[1][4]), 
        .y5_real(d_real[1][5]), .y5_imag(d_imag[1][5]), 
        .y6_real(d_real[1][6]), .y6_imag(d_imag[1][6]), 
        .y7_real(d_real[1][7]), .y7_imag(d_imag[1][7]), 
        .y8_real(d_real[1][8]), .y8_imag(d_imag[1][8]), 
        .y9_real(d_real[1][9]), .y9_imag(d_imag[1][9]), 
        .y10_real(d_real[1][10]), .y10_imag(d_imag[1][10]), 
        .y11_real(d_real[1][11]), .y11_imag(d_imag[1][11]), 
        .y12_real(d_real[1][12]), .y12_imag(d_imag[1][12]), 
        .y13_real(d_real[1][13]), .y13_imag(d_imag[1][13]), 
        .y14_real(d_real[1][14]), .y14_imag(d_imag[1][14]), 
        .y15_real(d_real[1][15]), .y15_imag(d_imag[1][15])
    );

    equalizer equal(
        .clk(clk), .rst(rst),
        .en(d_en[1]),
        .din0_real(d_real[1][0]), .din0_imag(d_imag[1][0]),
        .din1_real(d_real[1][1]), .din1_imag(d_imag[1][1]), 
        .din2_real(d_real[1][2]), .din2_imag(d_imag[1][2]), 
        .din3_real(d_real[1][3]), .din3_imag(d_imag[1][3]), 
        .din4_real(d_real[1][4]), .din4_imag(d_imag[1][4]), 
        .din5_real(d_real[1][5]), .din5_imag(d_imag[1][5]), 
        .din6_real(d_real[1][6]), .din6_imag(d_imag[1][6]), 
        .din7_real(d_real[1][7]), .din7_imag(d_imag[1][7]), 
        .din8_real(d_real[1][8]), .din8_imag(d_imag[1][8]), 
        .din9_real(d_real[1][9]), .din9_imag(d_imag[1][9]), 
        .din10_real(d_real[1][10]), .din10_imag(d_imag[1][10]), 
        .din11_real(d_real[1][11]), .din11_imag(d_imag[1][11]), 
        .din12_real(d_real[1][12]), .din12_imag(d_imag[1][12]), 
        .din13_real(d_real[1][13]), .din13_imag(d_imag[1][13]), 
        .din14_real(d_real[1][14]), .din14_imag(d_imag[1][14]), 
        .din15_real(d_real[1][15]), .din15_imag(d_imag[1][15]),
        
        .valid(valid),

        .dout0_real(d_real[2][0]),
        .dout1_real(d_real[2][1]),
        .dout2_real(d_real[2][2]), 
        .dout3_real(d_real[2][3]),
        .dout4_real(d_real[2][4]),
        .dout5_real(d_real[2][5]),
        .dout6_real(d_real[2][6]),
        .dout7_real(d_real[2][7]), 
        .dout8_real(d_real[2][8]),
        .dout9_real(d_real[2][9]),
        .dout10_real(d_real[2][10]),
        .dout11_real(d_real[2][11]), 
        .dout12_real(d_real[2][12]),
        .dout13_real(d_real[2][13]),
        .dout14_real(d_real[2][14]),
        .dout15_real(d_real[2][15])

    );

    bpsk_demod bpsk_demod(
        // input
        .din0_real(d_real[2][0]),
        .din1_real(d_real[2][1]),
        .din2_real(d_real[2][2]), 
        .din3_real(d_real[2][3]),
        .din4_real(d_real[2][4]),
        .din5_real(d_real[2][5]),
        .din6_real(d_real[2][6]),
        .din7_real(d_real[2][7]), 
        .din8_real(d_real[2][8]),
        .din9_real(d_real[2][9]),
        .din10_real(d_real[2][10]),
        .din11_real(d_real[2][11]), 
        .din12_real(d_real[2][12]),
        .din13_real(d_real[2][13]),
        .din14_real(d_real[2][14]),
        .din15_real(d_real[2][15]),

        // output
        .dout0_real(dout0_real)
    );



endmodule