module equalizer
#(
    parameter WIDTH = 16,
    parameter INT = 8,
    parameter DEC = 8

)
(
    input clk, rst,
    input en,
    input signed [WIDTH-1:0] din0_real, din0_imag,
    input signed [WIDTH-1:0] din1_real, din1_imag,
    input signed [WIDTH-1:0] din2_real, din2_imag,
    input signed [WIDTH-1:0] din3_real, din3_imag,
    input signed [WIDTH-1:0] din4_real, din4_imag,
    input signed [WIDTH-1:0] din5_real, din5_imag,
    input signed [WIDTH-1:0] din6_real, din6_imag,
    input signed [WIDTH-1:0] din7_real, din7_imag,
    input signed [WIDTH-1:0] din8_real, din8_imag,
    input signed [WIDTH-1:0] din9_real, din9_imag,
    input signed [WIDTH-1:0] din10_real, din10_imag,
    input signed [WIDTH-1:0] din11_real, din11_imag,
    input signed [WIDTH-1:0] din12_real, din12_imag,
    input signed [WIDTH-1:0] din13_real, din13_imag,
    input signed [WIDTH-1:0] din14_real, din14_imag,
    input signed [WIDTH-1:0] din15_real, din15_imag,

    output valid,
    output signed [WIDTH-1:0] dout0_real,
    output signed [WIDTH-1:0] dout1_real,
    output signed [WIDTH-1:0] dout2_real,
    output signed [WIDTH-1:0] dout3_real,
    output signed [WIDTH-1:0] dout4_real,
    output signed [WIDTH-1:0] dout5_real,
    output signed [WIDTH-1:0] dout6_real,
    output signed [WIDTH-1:0] dout7_real,
    output signed [WIDTH-1:0] dout8_real,
    output signed [WIDTH-1:0] dout9_real,
    output signed [WIDTH-1:0] dout10_real,
    output signed [WIDTH-1:0] dout11_real,
    output signed [WIDTH-1:0] dout12_real,
    output signed [WIDTH-1:0] dout13_real,
    output signed [WIDTH-1:0] dout14_real,
    output signed [WIDTH-1:0] dout15_real

);

    /* function: din*(1/sqrt(FFT_SIZE))*(1/chan_resp) */
    integer i;

    // fft coefficient: (1/sqrt(FFT_SIZE));
    wire signed [WIDTH-1:0] fft_coef;
    /*==== consider precision! ====*/
    assign fft_coef = 16'h002D; // 1/sqrt(32)

    // equalizer coefficient: (1/chan_resp)
    wire signed [WIDTH-1:0] eq_coef_real [0:15];
    wire signed [WIDTH-1:0] eq_coef_imag [0:15];

    //real
    assign eq_coef_real[0] = 16'h008E;
    assign eq_coef_real[1] = 16'h0093;
    assign eq_coef_real[2] = 16'h00A9;
    assign eq_coef_real[3] = 16'h00E8;
    assign eq_coef_real[4] = 16'h0127;
    assign eq_coef_real[5] = 16'h0174;
    assign eq_coef_real[6] = 16'h0234;
    assign eq_coef_real[7] = 16'h01F3;
    assign eq_coef_real[8] = 16'h01AB;
    assign eq_coef_real[9] = 16'h01F3;
    assign eq_coef_real[10] = 16'h0234;
    assign eq_coef_real[11] = 16'h0174;
    assign eq_coef_real[12] = 16'h0127;
    assign eq_coef_real[13] = 16'h00E8;
    assign eq_coef_real[14] = 16'h00A9;
    assign eq_coef_real[15] = 16'h0093;

    // imag
    assign eq_coef_imag[0] = 16'h0000;
    assign eq_coef_imag[1] = 16'h003A;
    assign eq_coef_imag[2] = 16'h007C;
    assign eq_coef_imag[3] = 16'h00B5;
    assign eq_coef_imag[4] = 16'h00C5;
    assign eq_coef_imag[5] = 16'h00ED;
    assign eq_coef_imag[6] = 16'h00A8;
    assign eq_coef_imag[7] = 16'hFFE4;
    assign eq_coef_imag[8] = 16'h0000;
    assign eq_coef_imag[9] = 16'h001C;
    assign eq_coef_imag[10] = 16'hFF58;
    assign eq_coef_imag[11] = 16'hFF13;
    assign eq_coef_imag[12] = 16'hFF3B;
    assign eq_coef_imag[13] = 16'hFF4B;
    assign eq_coef_imag[14] = 16'hFF84;
    assign eq_coef_imag[15] = 16'hFFC6;

    // operating data
    wire signed [WIDTH-1:0] din_real [0:15];
    wire signed [WIDTH-1:0] din_imag [0:15];

    //real
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

    // imag
    assign din_imag[0] = din0_imag;
    assign din_imag[1] = din1_imag;
    assign din_imag[2] = din2_imag;
    assign din_imag[3] = din3_imag;
    assign din_imag[4] = din4_imag;
    assign din_imag[5] = din5_imag;
    assign din_imag[6] = din6_imag;
    assign din_imag[7] = din7_imag;
    assign din_imag[8] = din8_imag;
    assign din_imag[9] = din9_imag;
    assign din_imag[10] = din10_imag;
    assign din_imag[11] = din11_imag;
    assign din_imag[12] = din12_imag;
    assign din_imag[13] = din13_imag;
    assign din_imag[14] = din14_imag;
    assign din_imag[15] = din15_imag;


    reg [2:0] en_stg;
    always @(posedge clk) begin
        if(rst) begin
            en_stg <= 0;
        end
        else begin
            en_stg <= {en_stg[1:0], en};
        end
    end


    // stage0: multiply fft coefficient
    reg signed [WIDTH*2-1:0] d_real [0:15];
    reg signed [WIDTH*2-1:0] d_imag [0:15];

    always @(posedge clk) begin
        if(rst) begin
            for(i=0; i<=15; i=i+1) begin
                d_real[i] <= 0;
                d_imag[i] <= 0; 
            end
        end
        else if(en) begin
            for(i=0; i<=15; i=i+1) begin
                d_real[i] <= din_real[i] * fft_coef;
                d_imag[i] <= din_imag[i] * fft_coef; 
            end
        end
    end

    // stage1: multiply

    reg signed [WIDTH*3-1:0] dc_real0 [0:15];
    reg signed [WIDTH*3-1:0] dc_real1 [0:15];

    always @(posedge clk) begin
        if(rst) begin
            for(i=0; i<=15; i=i+1) begin
                dc_real0[i] <= 0;
                dc_real1[i] <= 0;
            end
        end
        else if(en_stg[0]) begin
            for(i=0; i<=15; i=i+1) begin
                dc_real0[i] <= d_real[i] * eq_coef_real[i];
                dc_real1[i] <= d_imag[i] * eq_coef_imag[i];
            end
        end
    end

    // stage2
    reg signed [WIDTH*3-1:0] dc_real [0:15];

    always @(posedge clk) begin
        if(rst) begin
            for(i=0; i<=15; i=i+1) begin
                dc_real[i] <= 0;
            end
        end
        else if(en_stg[1]) begin
            for(i=0; i<=15; i=i+1) begin
                dc_real[i] <= dc_real0[i] - dc_real1[i];
            end
        end
    end

    // output
    reg signed [WIDTH-1:0] dout_real [0:15];
    reg signed [WIDTH*3-1:0] dc_real_temp;

    always @(*) begin
        for(i=0; i<=15; i=i+1) begin
            dc_real_temp = dc_real[i];
            dout_real[i] = dc_real_temp[DEC*2+WIDTH-1:DEC*2];
        end
    end

    assign valid = en_stg[2];

    // real
    assign dout0_real = dout_real[0];
    assign dout1_real = dout_real[1];
    assign dout2_real = dout_real[2];
    assign dout3_real = dout_real[3];
    assign dout4_real = dout_real[4];
    assign dout5_real = dout_real[5];
    assign dout6_real = dout_real[6];
    assign dout7_real = dout_real[7];

    assign dout8_real = dout_real[8];
    assign dout9_real = dout_real[9];
    assign dout10_real = dout_real[10];
    assign dout11_real = dout_real[11];
    assign dout12_real = dout_real[12];
    assign dout13_real = dout_real[13];
    assign dout14_real = dout_real[14];
    assign dout15_real = dout_real[15];

endmodule