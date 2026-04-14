module tb_CPU_L_test();
    
reg clk = 0;
reg rst;

always #10 clk <= ~clk;

initial begin
$dumpfile("tb_CPU_L_test.vcd");
$dumpvars(0, tb_CPU_L_test);


rst = 1;

#10;

rst = 0;
#10000;
$finish;
end

CPU_L_test uut(
    .clk(clk),
    .reset(rst),
    .vovan()
);


endmodule