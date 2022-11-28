module fft16
#(
    parameter WIDTH = 16,
    parameter FFT_SIZE = 16
)
(
    input clk, rst,
    input en,

    input signed [WIDTH-1:0] x0_real, x0_imag,
    input signed [WIDTH-1:0] x1_real, x1_imag,
    input signed [WIDTH-1:0] x2_real, x2_imag,
    input signed [WIDTH-1:0] x3_real, x3_imag,
    input signed [WIDTH-1:0] x4_real, x4_imag,
    input signed [WIDTH-1:0] x5_real, x5_imag,
    input signed [WIDTH-1:0] x6_real, x6_imag,
    input signed [WIDTH-1:0] x7_real, x7_imag,
    input signed [WIDTH-1:0] x8_real, x8_imag,
    input signed [WIDTH-1:0] x9_real, x9_imag,
    input signed [WIDTH-1:0] x10_real, x10_imag,
    input signed [WIDTH-1:0] x11_real, x11_imag,
    input signed [WIDTH-1:0] x12_real, x12_imag,
    input signed [WIDTH-1:0] x13_real, x13_imag,
    input signed [WIDTH-1:0] x14_real, x14_imag,
    input signed [WIDTH-1:0] x15_real, x15_imag,

    output valid,

    output signed [WIDTH-1:0] y0_real, y0_imag,
    output signed [WIDTH-1:0] y1_real, y1_imag,
    output signed [WIDTH-1:0] y2_real, y2_imag,
    output signed [WIDTH-1:0] y3_real, y3_imag,
    output signed [WIDTH-1:0] y4_real, y4_imag,
    output signed [WIDTH-1:0] y5_real, y5_imag,
    output signed [WIDTH-1:0] y6_real, y6_imag,
    output signed [WIDTH-1:0] y7_real, y7_imag,
    output signed [WIDTH-1:0] y8_real, y8_imag,
    output signed [WIDTH-1:0] y9_real, y9_imag,
    output signed [WIDTH-1:0] y10_real, y10_imag,
    output signed [WIDTH-1:0] y11_real, y11_imag,
    output signed [WIDTH-1:0] y12_real, y12_imag,
    output signed [WIDTH-1:0] y13_real, y13_imag,
    output signed [WIDTH-1:0] y14_real, y14_imag,
    output signed [WIDTH-1:0] y15_real, y15_imag

);

    // twiddle factor
    wire signed [WIDTH-1:0] w_real [0:7];
    wire signed [WIDTH-1:0] w_imag [0:7];

    //real
    assign w_real[0] = 16'h0100;
    assign w_real[1] = 16'h00ED;
    assign w_real[2] = 16'h00B5;
    assign w_real[3] = 16'h0062;
    assign w_real[4] = 16'h0000;
    assign w_real[5] = 16'hFF9E;
    assign w_real[6] = 16'hFF4B;
    assign w_real[7] = 16'hFF13;


    //imag
    assign w_imag[0] = 16'h0000;
    assign w_imag[1] = 16'hFF9E;
    assign w_imag[2] = 16'hFF4B;
    assign w_imag[3] = 16'hFF13;
    assign w_imag[4] = 16'hFF00;
    assign w_imag[5] = 16'hFF13;
    assign w_imag[6] = 16'hFF4B;
    assign w_imag[7] = 16'hFF9E;
 

    // operating data
    wire signed [WIDTH-1:0] x_real [0:4][0:FFT_SIZE-1]; // [stage][index]
    wire signed [WIDTH-1:0] x_imag [0:4][0:FFT_SIZE-1];

    // bit-reversed order
    assign x_real[0][0] = x0_real;
    assign x_real[0][1] = x8_real;
    assign x_real[0][2] = x4_real;
    assign x_real[0][3] = x12_real;
    assign x_real[0][4] = x2_real;
    assign x_real[0][5] = x10_real;
    assign x_real[0][6] = x6_real;
    assign x_real[0][7] = x14_real;
    assign x_real[0][8] = x1_real;
    assign x_real[0][9] = x9_real;
    assign x_real[0][10] = x5_real;
    assign x_real[0][11] = x13_real;
    assign x_real[0][12] = x3_real;
    assign x_real[0][13] = x11_real;
    assign x_real[0][14] = x7_real;
    assign x_real[0][15] = x15_real;

    assign x_imag[0][0] = x0_imag;
    assign x_imag[0][1] = x8_imag;
    assign x_imag[0][2] = x4_imag;
    assign x_imag[0][3] = x12_imag;
    assign x_imag[0][4] = x2_imag;
    assign x_imag[0][5] = x10_imag;
    assign x_imag[0][6] = x6_imag;
    assign x_imag[0][7] = x14_imag;
    assign x_imag[0][8] = x1_imag;
    assign x_imag[0][9] = x9_imag;
    assign x_imag[0][10] = x5_imag;
    assign x_imag[0][11] = x13_imag;
    assign x_imag[0][12] = x3_imag;
    assign x_imag[0][13] = x11_imag;
    assign x_imag[0][14] = x7_imag;
    assign x_imag[0][15] = x15_imag;

    // butterfly enable
    wire signed [39:0] bfy_en; // 8*(4+1)
    
    assign bfy_en[7:0] = {8{en}};

    // butterfly instantiation
    /*
        for stage m:
        (1) 2^m (1 << m) butterfly unit in one group
        (2) distance between 1st units for adjacent groups: 2^(m+1) (1 << (m+1))
    */

    genvar m, k;
    
    parameter STAGE = 3;
    parameter UNITS = 7;
    parameter MSB = 3;
    generate
        for(m=0; m<=STAGE; m=m+1) begin:stage
            for(k=0; k<=UNITS; k=k+1) begin:unit
                butterfly bfy(
                    .clk(clk), .rst(rst),
                    .en(
                        bfy_en[m*(UNITS+1) + k]
                    ),
                    .xa_real(x_real[m][
                        k[m:0] < (1 << m) ? // same group ?
                        (k[MSB:m] << (m+1)) + k[m:0] : // current group index + index in group
                        (k[MSB:m] << (m+1)) + (k[m:0] - (1 << m)) // next group index + index in group
                    ]),
                    .xa_imag(x_imag[m][
                        k[m:0] < (1 << m) ?
                        (k[MSB:m] << (m+1)) + k[m:0] :
                        (k[MSB:m] << (m+1)) + (k[m:0] - (1 << m))
                    ]),
                    .xb_real(x_real[m][
                        (k[m:0] < (1 << m) ?
                        (k[MSB:m] << (m+1)) + k[m:0] :
                        (k[MSB:m] << (m+1)) + (k[m:0] - (1 << m))) + (1 << m)
                    ]),
                    .xb_imag(x_imag[m][
                        (k[m:0] < (1 << m) ?
                        (k[MSB:m] << (m+1)) + k[m:0] :
                        (k[MSB:m] << (m+1)) + (k[m:0] - (1 << m))) + (1 << m)
                    ]),
                    .w_real(w_real[
                        (k[m:0] < (1 << m) ?
                        k[m:0] :
                        (k[m:0] - (1 << m))) << (STAGE-m)
                    ]),
                    .w_imag(w_imag[
                        (k[m:0] < (1 << m) ?
                        k[m:0] :
                        (k[m:0] - (1 << m))) << (STAGE-m)
                    ]),
                    .valid(
                        bfy_en[(m+1)*(UNITS+1) + k]
                    ),
                    .ya_real(x_real[m+1][
                        k[m:0] < (1 << m) ?
                        (k[MSB:m] << (m+1)) + k[m:0] :
                        (k[MSB:m] << (m+1)) + (k[m:0] - (1 << m))
                    ]),
                    .ya_imag(x_imag[m+1][
                        k[m:0] < (1 << m) ?
                        (k[MSB:m] << (m+1)) + k[m:0] :
                        (k[MSB:m] << (m+1)) + (k[m:0] - (1 << m))
                    ]),
                    .yb_real(x_real[m+1][
                        (k[m:0] < (1 << m) ?
                        (k[MSB:m] << (m+1)) + k[m:0] :
                        (k[MSB:m] << (m+1)) + (k[m:0] - (1 << m))) + (1 << m)
                    ]),
                    .yb_imag(x_imag[m+1][
                        (k[m:0] < (1 << m) ?
                        (k[MSB:m] << (m+1)) + k[m:0] :
                        (k[MSB:m] << (m+1)) + (k[m:0] - (1 << m))) + (1 << m)
                    ])
                );
            end
        end
    endgenerate

    assign valid = bfy_en[32];

    assign y0_real = x_real[4][0];
    assign y1_real = x_real[4][1];
    assign y2_real = x_real[4][2];
    assign y3_real = x_real[4][3];
    assign y4_real = x_real[4][4];
    assign y5_real = x_real[4][5];
    assign y6_real = x_real[4][6];
    assign y7_real = x_real[4][7];
    assign y8_real = x_real[4][8];
    assign y9_real = x_real[4][9];
    assign y10_real = x_real[4][10];
    assign y11_real = x_real[4][11];
    assign y12_real = x_real[4][12];
    assign y13_real = x_real[4][13];
    assign y14_real = x_real[4][14];
    assign y15_real = x_real[4][15];

    assign y0_imag = x_imag[4][0];
    assign y1_imag = x_imag[4][1];
    assign y2_imag = x_imag[4][2];
    assign y3_imag = x_imag[4][3];
    assign y4_imag = x_imag[4][4];
    assign y5_imag = x_imag[4][5];
    assign y6_imag = x_imag[4][6];
    assign y7_imag = x_imag[4][7];
    assign y8_imag = x_imag[4][8];
    assign y9_imag = x_imag[4][9];
    assign y10_imag = x_imag[4][10];
    assign y11_imag = x_imag[4][11];
    assign y12_imag = x_imag[4][12];
    assign y13_imag = x_imag[4][13];
    assign y14_imag = x_imag[4][14];
    assign y15_imag = x_imag[4][15];




endmodule