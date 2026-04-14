module out_manager(
    input               clk,
    input               TX_b,
    input       [2:0]   cmd_in,
    input       [7:0]   data_in,
    input               ready,
    output reg  [15:0]  data_out,
    output reg          gotov
);

reg [1:0] count_1 = 0;
reg [3:0] count_2 = 1;
reg [2:0] tm = 0;
reg [2:0] tG = 0;
reg old_TX_b;

reg [1:0] stat = 1;

// always @(posedge clk) begin
//     old_TX_b <= TX_b;
//     tm <= {tm[2:0], TX_b};
// end

// always @(posedge clk) begin
//      tG <= {tG[2:0], gotov};
// end

reg [15:0] cont = 0;

always @(posedge clk) begin

case (stat)
    
    2'b00:begin


    if (TX_b == 0 && gotov == 0) begin
        gotov <= 1;
        
        case (cmd_in)
            3'b000: begin
                data_out <= 16'h0100 + cont;
                cont <= cont + 1;
                if (cont != 16'h01) begin
                    data_out <= 16'h0100 + cont;
                    cont <= cont + 1;
                end else begin
                    pass
                end
            end
        endcase
        
        if (count_1 == 3) begin
            if (count_2 == 4'hB) begin
                count_1 <= 0;
                stat <= 1;
                count_2 <= 1;
            end else begin
                count_2 <= count_2 + 1;
            end
        end else begin
            if (count_2 == (data_in[3-count_1] ? 4'hA : 4'hB)) begin
                count_1 <= count_1 + 1;
                count_2 <= 1;
            end else begin
                count_2 <= count_2 + 1;
            end
        end
    end else begin
        gotov <= 0;
    end

    end

    2'b01: begin
        gotov <= 0;
        if (ready) begin
            stat <= 0;
        end
    end
    
endcase

end

endmodule