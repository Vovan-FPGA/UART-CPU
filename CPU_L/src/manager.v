module manager #(
    parameter N = 16,
    parameter CMD_M = 4
) (
    input clk,
    input ready,
    input [7:0] data_in,
    output [CMD_M*8 - 1 : 0] cmd_out,
    output [((N - CMD_M) * 4) - 1 : 0]data_out,
    output gotov
);

reg gv = 0;

reg [1:0]stat = 0;
reg [(N * 8) - 1 : 0] out_reg = 0;

reg [(CMD_M*8) - 1 : 0] CMD = 0;
reg [((N - CMD_M) * 8) - 1 : 0] DATA = 0;

reg [3:0]  tv = 0;

localparam  CMD_S = 0,
            DATA_A = 1,
            DATA_B = 2,
            DATA_C = 3;

always @(posedge clk) begin
    case (stat)
        CMD_S:begin
            if (ready) begin
                if (data_in == 8'h0A) begin
                    out_reg <= 0;
                end
                
                else if (data_in == 8'h20) begin
                    stat <= DATA_A;
                    CMD <= out_reg [(CMD_M*8) - 1 : 0];
                    out_reg <= 0;
                end 
                else begin
                    out_reg <= {out_reg[((N*8)-1) - 8:0],data_in};
                end
                // if (data_in == 8'h0D) begin
                //     gv <= 1;
                //     count <= 0;
                // end
            end
            else begin
                gv <= 0;
            end

            end
        DATA_A: begin
            if (ready) begin
                if (data_in == 8'h0D) begin
                    DATA <= out_reg[((N - CMD_M) * 4) - 1 : 0];
                    gv <= 1;
                    stat <= CMD_S;
                    out_reg <= 0;
                end
                else if(data_in == 8'h20)begin
                    
                end
                else begin
                    out_reg <= {out_reg[((N*8)-1) - 4:0], tv};
                    gv <= 0;
                end
                // if (data_in == 8'h0D) begin
                //     gv <= 1;
                //     count <= 0;
                // end
                end
            end

    endcase
end

always @(*) begin
    case (data_in)

        8'h30: tv <= 4'h0; 
        8'h31: tv <= 4'h1; 
        8'h32: tv <= 4'h2; 
        8'h33: tv <= 4'h3; 
        8'h34: tv <= 4'h4; 
        8'h35: tv <= 4'h5; 
        8'h36: tv <= 4'h6; 
        8'h37: tv <= 4'h7; 
        8'h38: tv <= 4'h8; 
        8'h39: tv <= 4'h9;

        8'h41: tv <= 4'hA; 
        8'h42: tv <= 4'hB; 
        8'h43: tv <= 4'hC; 
        8'h44: tv <= 4'hD;
        8'h45: tv <= 4'hE; 
        8'h46: tv <= 4'hF;

        8'h20: tv <= 4'hA; 
        
        default: begin
            tv <= 4'h0;
        end

    endcase
end

assign data_out = DATA;
assign cmd_out = CMD;
assign gotov = gv;

    
endmodule