module out_manager1(
    input               clk,
    input               TX_b,
    input       [2:0]   cmd_in,
    input       [7:0]   data_in,
    input               ready,
    output reg  [15:0]  data_out,
    output reg          gotov
);


reg [15:0]  cont = 0;
reg [3:0]   xc = 3;

reg [2:0]   cmd;
reg [7:0]   data;

reg stat = 1;

always @(posedge clk) begin
    

    case (stat)

        1'b0:begin
            if (~TX_b && gotov == 0) begin

                gotov <= 1;

                case (cmd)
                    3'b000: begin
                        if (cont < 4) begin
                            data_out <= 16'h0010 + cont;
                            cont <= cont + 1;
                            gotov <= 1;
                        end
                        else begin
                            if (xc != 0) begin
                                data_out <= data[xc] ;
                                xc      <= xc - 1;
                                gotov <= 1;
                            end
                            else  begin
                                stat <= 1;
                            end
                        end

                    end    
                endcase
                    
            end
            else begin
                gotov <= 0;
            end
        end

        1'b1:begin
            gotov <= 0;
            cont  <= 0;
            xc    <= 3;
            if (ready) begin
                stat <= 0;
                cmd <= cmd_in;
                data <= data_in;
            end
        end
        
    endcase
    
    
        
    
end
    
endmodule