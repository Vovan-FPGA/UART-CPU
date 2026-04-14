module tb_m1();
    
reg clk = 0;
reg rst;

always #10 clk <= ~clk;

wire        bis;
wire [15:0]  data_out;
wire        gotov;

reg  [2:0]  cmd;
reg  [7:0] data;
reg         ready;

initial begin
$dumpfile("tb_m1.vcd");
$dumpvars(0, tb_m1);
#10
rst <= 0;
#10
rst <= 1;

#10
cmd <= 3'b000;
data<= 8'h03;
ready<=1'b1;
#10
ready<=1'b0;

#10000;
$finish;
end

out_manager1 uut(
    .clk(clk),
    .TX_b(bis),

    .cmd_in(cmd),
    .data_in(data),
    .ready(ready),

    .data_out(data_out),
    .gotov(gotov)

);

wire [7:0] da;

mem1 mm(
    .clk(clk),
    .adr(data_out),
    .data_out(da)
);

wire d;

UART_TX tx(
    .clk(clk),
    .reset(rst),
    .tx_start(gotov),
    .data_in(da),
    .tx(d),
    .tx_busy(bis)
);

wire [7:0] data_fin;
wire ready_fin;

UART_RX rx (
    .clk(clk),
    .reset(rst),
    .rx(d),
    .data_out(data_fin),
    .rx_ready(ready_fin)
);


endmodule