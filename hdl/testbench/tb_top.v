module tb_top;

    parameter WIDTH = 16;
    parameter FFT_SIZE = 16;
    parameter CYCLE = 10;

    // inputs
    reg clk, rst;
    reg en;
    reg signed [WIDTH-1:0] din_real [0:119];
    reg signed [WIDTH-1:0] din_imag [0:119];
    reg signed [WIDTH-1:0] din_real_s;
    reg signed [WIDTH-1:0] din_imag_s;

    initial begin
        $readmemh("./input_real.txt", din_real);
        $readmemh("./input_imag.txt", din_imag);
    end

    // outputs
    wire valid;
    wire [FFT_SIZE-1:0] dout_real;

    top top(
        .clk(clk), .rst(rst),
        .en(en),
        .din0_real(din_real_s),
        .din0_imag(din_imag_s),

        .valid(valid),
        .dout0_real(dout_real)
    );

    always #(CYCLE/2) clk = ~clk;

    integer i;

    initial begin
        clk = 0;
        rst = 0;
        #(CYCLE*0.25) rst = 1;
        #(CYCLE*2) rst = 0;
        #(CYCLE*2000) $finish;
    end

    reg [31:0] count;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            din_real_s <= 0;
            din_imag_s <= 0;
            en <= 0;
            count <= 0;
        end
        else begin
            
            if(count <= 120) begin
                en <= ~en;
                count <= count + 1;
                din_real_s <= din_real[count];
                din_imag_s <= din_imag[count];
            end

        end
    end

    
endmodule