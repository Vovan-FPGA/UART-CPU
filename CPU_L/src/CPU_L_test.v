module CPU_L_test(
    input clk,
    input reset,

    input [4*8 - 1 : 0] cmd_out,
    input [((16 - 4) * 4) - 1 : 0]data_out,
    input gotov,

    output ready,
    output [7:0]data_tx,
    output [2:0] cmd_tx,

    output reg [3:0] LED,
    output vovan
);

localparam     CMD_MEM_SIZE      = 8,
               ADDR_CMD_MEM_SIZE = $clog2(CMD_MEM_SIZE),
               CMD_SIZE          = 16,
               MEM_SIZE          = 16,
               ADDR_MEM_SIZE     = $clog2(MEM_SIZE),
               LIT_SIZE          = 8,
               RF_SIZE           = 8,
               ADDR_RF_SIZE      = $clog2(RF_SIZE),
               COP_SIZE          = 4;

    // Коды операций
    localparam NOP   = 4'b0000,  // Нет операции
               ADD   = 4'b0001,  // Сложение: R3 = R1 + R2
               SUB   = 4'b0010,  // Вычитание: R3 = R1 - R2
               MOVI  = 4'b0011,  // Загрузка константы: R1 = literal
               MOVR  = 4'b0100,  // Копирование регистра: R3 = R1
               LOAD  = 4'b0101,  // Загрузка из памяти: R3 = mem[addr_m_1]
               STORE = 4'b0110,  // Сохранение в память: mem[addr_m_1] = R1
               JMP   = 4'b0111,  // Безусловный переход: pc = addr_to_jump
               JZ    = 4'b1000,  // Переход если равно нулю: if(R1 == 0) pc = addr_to_jump
               JNZ   = 4'b1001,  // Переход если не равно нулю: if(R1 != 0) pc = addr_to_jump
               CMP   = 4'b1010,  // Сравнение: устанавливает флаги (R1 - R2)
               INC   = 4'b1011,  // Инкремент: R1 = R1 + 1
               DEC   = 4'b1100,  // Декремент: R1 = R1 - 1
               AND   = 4'b1101,  // Логическое И: R3 = R1 & R2
               LD    = 4'b1110,  // Логическое ИЛИ: R3 = R1 | R2
               END   = 4'b1111;  // Исключающее ИЛИ: R3 = R1 ^ R2

    reg [CMD_SIZE - 1 : 0]          cmd_mem [0 : CMD_MEM_SIZE - 1];
    reg [LIT_SIZE - 1 : 0]          mem     [0 : MEM_SIZE - 1];
    reg [LIT_SIZE - 1 : 0]          rf      [0 : RF_SIZE - 1];
    reg [CMD_SIZE - 1 : 0]          cmd;
    reg [ADDR_CMD_MEM_SIZE - 1 : 0] pc = 0;
    reg [LIT_SIZE - 1 : 0]          OpA, OpB;
    reg [31 : 0]                    res;
    reg [2:0]                       stage_counter = 0;
    reg                             zero_flag;    // Флаг нуля для сравнения
    reg                             eq_flag;      // Флаг равенства
    reg                             less_flag;    // Флаг меньше
    
    integer i;


    wire [COP_SIZE - 1 : 0] cop = cmd [CMD_SIZE - 1 -: COP_SIZE];
    wire [ADDR_MEM_SIZE - 1 : 0] addr_m_1 = cmd[CMD_SIZE - 1 - COP_SIZE -: ADDR_MEM_SIZE];
    wire [ADDR_RF_SIZE - 1 : 0] addr_r_1 = cmd[CMD_SIZE - 1 - COP_SIZE -: ADDR_RF_SIZE];
    wire [ADDR_RF_SIZE - 1 : 0] addr_r_2 = cmd[CMD_SIZE - 1 - COP_SIZE - ADDR_RF_SIZE -: ADDR_RF_SIZE];
    wire [ADDR_RF_SIZE - 1 : 0] addr_r_3 = cmd[CMD_SIZE - 1 - COP_SIZE - 2*ADDR_RF_SIZE -: ADDR_RF_SIZE];
    wire [LIT_SIZE - 1 : 0]     literal  = cmd[ 0 +: LIT_SIZE];
    wire [ADDR_CMD_MEM_SIZE - 1 : 0] addr_to_jump = cmd[0 +: ADDR_CMD_MEM_SIZE];

initial begin
        for(i = 0; i < RF_SIZE; i = i + 1)
            rf[i] = 0;
        for(i = 0; i < MEM_SIZE; i = i + 1)
            mem[i] = 0;
        //$readmemb("mem.mem", mem);
        $readmemb("C:/intelFPGA_lite/prog/pr_1_test_A/CPU_L/src/cmd_mem.mem", cmd_mem);
    end

reg mod = 0;

// Контроль стадий конвейера
always @(posedge clk ) begin
    if (mod) begin
        if (reset) begin
            stage_counter <= 0;
        end else if (stage_counter == 4) begin
            stage_counter <= 0;
        end else begin
            stage_counter <= stage_counter + 1;
        end
    end else begin
        
    end
    
end

// Стадия 0: Выборка команды
always @(posedge clk ) begin
    if (mod) begin
        if (reset) begin
            cmd <= {(CMD_SIZE){1'b0}};
        end else begin
            if (stage_counter == 0) begin
                cmd <= cmd_mem[pc];
            end
        end
            
    end else begin
        
    end
    
end

// Стадия 1: Чтение первого операнда
always @(posedge clk ) begin
    if (mod) begin
        if (reset) begin
            OpA <= 0;
        end else begin
            if (stage_counter == 1) begin
                case (cop)
                    ADD, SUB, MOVR, CMP, AND: begin
                        OpA <= rf[addr_r_1];
                    end
                    INC, DEC, JZ, JNZ: begin
                        OpA <= rf[addr_r_1];
                    end
                    STORE: begin
                        OpA <= rf[addr_r_1];
                    end
                    LOAD: begin
                        OpA <= mem[addr_m_1];
                    end
                    MOVI: begin
                        OpA <= literal;
                    end
                    LD:begin
                        OpA <= literal;
                    end
                    default: OpA <= 0;
                endcase
            end
        end
            
    end else begin
        
    end
    
end

// Стадия 2: Чтение второго операнда
always @(posedge clk ) begin
    if (mod) begin
        if (reset) begin
            OpB <= 0;
        end else begin
            if (stage_counter == 2) begin
                case (cop)
                    ADD, SUB, CMP, AND: begin
                        OpB <= rf[addr_r_2];
                    end
                    INC, DEC: begin
                        OpB <= 1;
                    end
                    default: OpB <= 0;
                endcase
            end
        end
        
    end else begin
        
    end
    
end

// Стадия 3: Выполнение операции
always @(posedge clk ) begin
    if (mod) begin
        
        
        if (reset) begin
            res <= {(2*LIT_SIZE){1'b0}};
        end else begin
            if (stage_counter == 3) begin
                case (cop)
                    ADD: res <= OpA + OpB;
                    SUB: res <= OpA - OpB;
                    MOVI, MOVR, LOAD: res <= OpA;
                    INC: res <= OpA + 1;
                    DEC: res <= OpA - 1;
                    CMP: begin
                        res <= OpA - OpB;
                        // Устанавливаем флаги
                        eq_flag <= (OpA == OpB);
                        less_flag <= ($signed(OpA) < $signed(OpB));
                        zero_flag <= (OpA == OpB);
                    end
                    AND: res <= OpA & OpB;
                    LD:begin
                        res <= OpA[3:0];
                    end
                    default: res <= 0;
                endcase
            end
        end
    end else begin
        
    end
end

// Стадия 4: Запись результата и обновление PC
always @(posedge clk ) begin
    if (mod) begin
        
        if (reset) begin
            pc <= 0;
        end else begin
            if (stage_counter == 4) begin
                case (cop)
                    JMP: begin
                        pc <= addr_to_jump;
                    end
                    JZ: begin
                        if (zero_flag) pc <= addr_to_jump;
                        else pc <= pc + 1;
                    end
                    JNZ: begin
                        if (!zero_flag) pc <= addr_to_jump;
                        else pc <= pc + 1;
                    end
                    default: pc <= pc + 1;
                endcase
            end
        end
        
    end else begin
        
    end
end

// Запись в регистровый файл
always @(posedge clk ) begin
    if (mod) begin
        if (stage_counter == 4) begin
            case (cop)
                ADD, SUB, MOVR, LOAD, INC, DEC, AND: begin
                    rf[addr_r_3] <= res[LIT_SIZE-1:0];
                end
                MOVI: begin
                    rf[addr_r_1] <= OpA;
                end
                LD:begin
                    LED <= res[3:0];
                end
                END:begin
                    mod <= 0;
                end
                default: ;
            endcase
        end
        
    end else begin
        if(gotov)begin
            case (cmd_out)
                32'h30303030:begin
                    mod <= 1;
                end

                32'h30303031:begin
                    ;
                end
            endcase
        end
        else begin
            
        end
    end
    
end

// Запись в память
always @(posedge clk ) begin
    if (mod) begin
    if (stage_counter == 4) begin
        case (cop)
            STORE: begin
                mem[addr_m_1] <= OpA;
            end
            default: ;
        endcase
    end
        
    end else begin
        
    end

end

wire [11:0] rr1 = rf[0];
wire [11:0] rr2 = rf[1];

wire [11:0] rr3 = rf[2];

wire [11:0] rr4 = rf[3];

wire [11:0] rr5 = rf[4];

wire [11:0] rr6 = rf[5];

wire [11:0] rr7 = rf[6];

wire [11:0] rr8 = rf[7];


assign vovan = ((stage_counter == 0)) ? 1'b1 : 1'b0;

endmodule

