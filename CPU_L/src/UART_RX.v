module UART_RX (
    input clk,
    input reset,
    input rx,
    output reg [7:0] data_out,
    output reg rx_ready
);
    localparam BAUD_RATE =  25000000;//25000000 9600 115200
    localparam CLK_FREQ = 50000000;
    localparam BAUD_TICKS = CLK_FREQ / BAUD_RATE;
    localparam HALF_BAUD = BAUD_TICKS / 2;

    reg [15:0] baud_counter;
    reg [3:0] bit_index;
    reg [7:0] shift_reg;
    reg [1:0] state;

    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            state <= IDLE;
            rx_ready <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    rx_ready <= 1'b0;
                    if (rx == 1'b0) begin // обнаружение стартового бита
                        state <= START;
                        baud_counter <= HALF_BAUD - 1;
                    end
                end

                START: begin
                    if (baud_counter == 0) begin
                        // проверка, что это действительно старт
                        if (rx == 1'b0) begin
                            state <= DATA;
                            bit_index <= 0;
                            baud_counter <= BAUD_TICKS - 1;
                        end else begin
                            state <= IDLE; // ложный старт
                        end
                    end else begin
                        baud_counter <= baud_counter - 1;
                    end
                end

                DATA: begin
                    if (baud_counter == 0) begin
                        baud_counter <= BAUD_TICKS - 1;
                        shift_reg <= {rx, shift_reg[7:1]}; // сборка битов
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
                    if (baud_counter == 0) begin
                        if (rx == 1'b1) begin // проверка стоп-бита
                            data_out <= shift_reg;
                            rx_ready <= 1'b1;
                        end
                        state <= IDLE;
                    end else begin
                        baud_counter <= baud_counter - 1;
                    end
                end
            endcase
        end
    end
endmodule