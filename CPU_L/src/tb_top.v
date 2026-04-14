module tb_top();

reg clk = 0;
reg rst = 1;

wire d;

always #10 clk <= ~clk ;

wire [7:0]  data_rx;
wire        ready_rx;

reg [7:0]   data_tx;
reg         ready_tx;


initial begin
$dumpfile("tb_top.vcd");
$dumpvars(0, tb_top);


rst = 0;

#10;
rst = 1;
#10;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h20;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h30;
start_tx = 1;
#20;
start_tx = 0;
#500;


data_tx = 8'h0D;
start_tx = 1;
#20;
start_tx = 0;
#500;

data_tx = 8'h0A;
start_tx = 1;
#20;
start_tx = 0;
#500;


#10000;
$finish;
end

UART_RX rx(
    .clk(clk),
    .reset(rst),
    .rx(d),
    .data_out(data_rx),
    .rx_ready(ready_rx)
);  

wire [31:0]cmd_uart;
wire [47:0]data_uart;
wire ready_uart;

manager m1(
    .clk(clk),
    .ready(ready_rx),
    .data_in(data_rx),
    .cmd_out(cmd_uart),
    .data_out(data_uart),
    .gotov(ready_uart)
);

CPU_L_test cpu(
    .clk(clk),
    .reset(~rst),
    .cmd_out(cmd_uart),
    .data_out(data_uart),
    .gotov(ready_uart),
    .vovan()
);

reg start_tx;



UART_TX tx(
    .clk(clk),
    .reset(rst),
    .tx_start(start_tx),
    .data_in(data_tx),
    .tx(d),
    .tx_busy()
);

endmodule