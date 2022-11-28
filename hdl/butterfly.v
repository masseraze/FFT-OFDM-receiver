module butterfly
#(
    parameter WIDTH = 16,
    parameter INT = 8,
    parameter DEC = 8
)
(
    input clk, rst,
    input en,
    input signed [WIDTH-1:0] xa_real, xa_imag,
    input signed [WIDTH-1:0] xb_real, xb_imag,
    input signed [WIDTH-1:0] w_real, w_imag,
    output valid,
    output signed [WIDTH-1:0] ya_real, ya_imag,
    output signed [WIDTH-1:0] yb_real, yb_imag
);

    reg [2:0] en_stg;
    always @(posedge clk) begin
        if(rst) begin
            en_stg <= 0;
        end
        else begin
            en_stg <= {en_stg[1:0], en};
        end
    end

    // input sign-extension
    wire signed [WIDTH*2-1:0] xa_real_ext, xa_imag_ext;

    assign xa_real_ext = { {INT{xa_real[WIDTH-1]}}, xa_real, {DEC{1'h0}} };
    assign xa_imag_ext = { {INT{xa_imag[WIDTH-1]}}, xa_imag, {DEC{1'h0}} };

    // stage 0: xb multiply, xa delay
    reg signed [WIDTH*2-1:0] xb_w_real0;
    reg signed [WIDTH*2-1:0] xb_w_real1;
    reg signed [WIDTH*2-1:0] xb_w_imag0;
    reg signed [WIDTH*2-1:0] xb_w_imag1;
    reg signed [WIDTH*2-1:0] xa_real_d0;
    reg signed [WIDTH*2-1:0] xa_imag_d0;

    always @(posedge clk) begin
        if(rst) begin
            xb_w_real0 <= 0;
            xb_w_real1 <= 0;
            xb_w_imag0 <= 0;
            xb_w_imag1 <= 0;
            xa_real_d0 <= 0;
            xa_imag_d0 <= 0;
        end
        else if(en) begin
            xb_w_real0 <= xb_real * w_real;
            xb_w_real1 <= xb_imag * w_imag;
            xb_w_imag0 <= xb_real * w_imag;
            xb_w_imag1 <= xb_imag * w_real;
            xa_real_d0 <= xa_real_ext;
            xa_imag_d0 <= xa_imag_ext;
        end
    end

    // stage 1: xb_w combine, xa delay
    reg signed [WIDTH*2-1:0] xb_w_real;
    reg signed [WIDTH*2-1:0] xb_w_imag;
    reg signed [WIDTH*2-1:0] xa_real_d1;
    reg signed [WIDTH*2-1:0] xa_imag_d1;

    always @(posedge clk) begin
        if(rst) begin
            xb_w_real <= 0;
            xb_w_imag <= 0;
            xa_real_d1 <= 0;
            xa_imag_d1 <= 0;
        end
        else if(en_stg[0]) begin
            xb_w_real <= xb_w_real0 - xb_w_real1;
            xb_w_imag <= xb_w_imag0 + xb_w_imag1;
            xa_real_d1 <= xa_real_d0;
            xa_imag_d1 <= xa_imag_d0;
        end
    end

    // stage 2: butterfly result
    reg signed [WIDTH*2-1:0] ya_real_ext;
    reg signed [WIDTH*2-1:0] ya_imag_ext;
    reg signed [WIDTH*2-1:0] yb_real_ext;
    reg signed [WIDTH*2-1:0] yb_imag_ext;

    always @(posedge clk) begin
        if(rst) begin
            ya_real_ext <= 0;
            ya_imag_ext <= 0;
            yb_real_ext <= 0;
            yb_imag_ext <= 0;
        end
        else if(en_stg[1]) begin
            ya_real_ext <= xa_real_d1 + xb_w_real;
            ya_imag_ext <= xa_imag_d0 + xb_w_imag;
            yb_real_ext <= xa_real_d1 - xb_w_real;
            yb_imag_ext <= xa_imag_d0 - xb_w_imag;
        end
    end

    assign ya_real = ya_real_ext[DEC+WIDTH-1:DEC];
    assign ya_imag = ya_imag_ext[DEC+WIDTH-1:DEC];
    assign yb_real = yb_real_ext[DEC+WIDTH-1:DEC];
    assign yb_imag = yb_imag_ext[DEC+WIDTH-1:DEC];
    assign valid = en_stg[2];




endmodule