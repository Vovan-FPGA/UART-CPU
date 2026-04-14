module UART_TX (
    input clk,
    input reset,
    input tx_start,
    input [7:0] data_in,
    output reg tx,
    output reg tx_busy
);
    localparam BAUD_RATE = 25000000;
    localparam CLK_FREQ = 50000000; // 50 МГц
    localparam BAUD_TICKS = CLK_FREQ / BAUD_RATE; // 434 для 115200

    reg [15:0] baud_counter;
    reg [3:0] bit_index;
    reg [7:0] shift_reg;
    reg [1:0] state;

    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            tx <= 1'b1;
            tx_busy <= 1'b0;
            state <= IDLE;
            baud_counter <= 0;
            bit_index <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    if (tx_start) begin
                        shift_reg <= data_in;
                        state <= START;
                        tx_busy <= 1'b1;
                        baud_counter <= BAUD_TICKS - 1;
                    end
                end

                START: begin
                    tx <= 1'b0; // стартовый бит
                    if (baud_counter == 0) begin
                        baud_counter <= BAUD_TICKS - 1;
                        state <= DATA;
                        bit_index <= 0;
                    end else begin
                        baud_counter <= baud_counter - 1;
                    end
                end

                DATA: begin
                    tx <= shift_reg[0]; // младший бит вперед
                    if (baud_counter == 0) begin
                        baud_counter <= BAUD_TICKS - 1;
                        shift_reg <= {1'b0, shift_reg[7:1]}; // сдвиг
                        if (bit_index == 7) begin
                            state <= STOP;
                        end else begin
                            bit_index <= bit_index + 1;
                        end
                    end else begin
                        baud_counter <= baud_counter - 1;
                    end
                end

                STOP: begin
                    tx <= 1'b1;
                    if (baud_counter == 0) begin
                        state <= IDLE;
                    end else begin
                        baud_counter <= baud_counter - 1;
                    end
                end
            endcase
        end
    end
endmodule