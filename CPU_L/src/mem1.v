module mem1(
    input           clk,
    input   [15:0]    adr,
    output  [7:0]    data_out
);

reg [7:0] data;

always @(*) begin
    case (adr)
        16'h0000: data <= 8'h30;
        16'h0001: data <= 8'h31;
        16'h0002: data <= 8'h32;
        16'h0003: data <= 8'h33;
        16'h0004: data <= 8'h34;
        16'h0005: data <= 8'h35;
        16'h0006: data <= 8'h36;
        16'h0007: data <= 8'h37;
        16'h0008: data <= 8'h38;
        16'h0009: data <= 8'h39;

        16'h000A: data <= 8'h41;
        16'h000B: data <= 8'h42;
        16'h000C: data <= 8'h43;
        16'h000D: data <= 8'h44;
        16'h000E: data <= 8'h45;
        16'h000F: data <= 8'h46;
        


        16'h0010: data <= 8'h4C;
        16'h0011: data <= 8'h45;
        16'h0012: data <= 8'h44;
        16'h0013: data <= 8'h20;


        default: begin
            data <= 8'h00;
        end

    endcase
end



assign data_out = data;

    
endmodule