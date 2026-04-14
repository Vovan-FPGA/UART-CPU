module mem(
    input           clk,
    input   [15:0]    adr,
    output  [7:0]    data_out
);

reg [7:0] data;

always @(*) begin
    case (adr)
        16'h0001: data <= 8'h4C;
        16'h0002: data <= 8'h45;
        16'h0003: data <= 8'h44;
        16'h0004: data <= 8'h20;
        16'h0005: data <= 8'h31;
        16'h0006: data <= 8'h20;
        16'h0007: data <= 8'h4F;
        16'h0008: data <= 8'h4E;
        16'h0009: data <= 8'h0D;
        16'h000A: data <= 8'h0A;

        16'h0011: data <= 8'h4C;
        16'h0012: data <= 8'h45;
        16'h0013: data <= 8'h44;
        16'h0014: data <= 8'h20;
        16'h0015: data <= 8'h32;
        16'h0016: data <= 8'h20;
        16'h0017: data <= 8'h4F;
        16'h0018: data <= 8'h4E;
        16'h0019: data <= 8'h0D;
        16'h001A: data <= 8'h0A;

        16'h0021: data <= 8'h4C;
        16'h0022: data <= 8'h45;
        16'h0023: data <= 8'h44;
        16'h0024: data <= 8'h20;
        16'h0025: data <= 8'h33;
        16'h0026: data <= 8'h20;
        16'h0027: data <= 8'h4F;
        16'h0028: data <= 8'h4E;
        16'h0029: data <= 8'h0D;
        16'h002A: data <= 8'h0A;

        16'h0031: data <= 8'h4C;
        16'h0032: data <= 8'h45;
        16'h0033: data <= 8'h44;
        16'h0034: data <= 8'h20;
        16'h0035: data <= 8'h34;
        16'h0036: data <= 8'h20;
        16'h0037: data <= 8'h4F;
        16'h0038: data <= 8'h4E;
        16'h0039: data <= 8'h0D;
        16'h003A: data <= 8'h0A;

        16'h0101: data <= 8'h4C;
        16'h0102: data <= 8'h45;
        16'h0103: data <= 8'h44;
        16'h0104: data <= 8'h20;
        16'h0105: data <= 8'h31;
        16'h0106: data <= 8'h20;
        16'h0107: data <= 8'h4F;
        16'h0108: data <= 8'h4F;
        16'h0109: data <= 8'h46;
        16'h010A: data <= 8'h0D;
        16'h010B: data <= 8'h0A;

        16'h0111: data <= 8'h4C;
        16'h0112: data <= 8'h45;
        16'h0113: data <= 8'h44;
        16'h0114: data <= 8'h20;
        16'h0115: data <= 8'h32;
        16'h0116: data <= 8'h20;
        16'h0117: data <= 8'h4F;
        16'h0118: data <= 8'h4F;
        16'h0119: data <= 8'h46;
        16'h011A: data <= 8'h0D;
        16'h011B: data <= 8'h0A;

        16'h0121: data <= 8'h4C;
        16'h0122: data <= 8'h45;
        16'h0123: data <= 8'h44;
        16'h0124: data <= 8'h20;
        16'h0125: data <= 8'h33;
        16'h0126: data <= 8'h20;
        16'h0127: data <= 8'h4F;
        16'h0128: data <= 8'h4F;
        16'h0129: data <= 8'h46;
        16'h012A: data <= 8'h0D;
        16'h012B: data <= 8'h0A;

        16'h0131: data <= 8'h4C;
        16'h0132: data <= 8'h45;
        16'h0133: data <= 8'h44;
        16'h0134: data <= 8'h20;
        16'h0135: data <= 8'h34;
        16'h0136: data <= 8'h20;
        16'h0137: data <= 8'h4F;
        16'h0138: data <= 8'h4F;
        16'h0139: data <= 8'h46;
        16'h013A: data <= 8'h0D;
        16'h013B: data <= 8'h0A;

        default: begin
            data <= 8'h00;
        end

    endcase
end

assign data_out = data;

    
endmodule