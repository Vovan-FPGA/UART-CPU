module CPU(
    input clk,
    output vovan
);

localparam     CMD_MEM_SIZE      = 8,
               ADDR_CMD_MEM_SIZE = $clog2(CMD_MEM_SIZE),
               CMD_SIZE          = 16,
               MEM_SIZE          = 16,
               ADDR_MEM_SIZE     = $clog2(MEM_SIZE),
               LIT_SIZE          = 12,
               RF_SIZE           = 8,
               ADDR_RF_SIZE      = $clog2(RF_SIZE),
               COP_SIZE          = 4;

    reg [CMD_SIZE - 1 : 0]          cmd_mem [0 : CMD_MEM_SIZE - 1];
    reg [LIT_SIZE - 1 : 0]          mem     [0 : MEM_SIZE - 1];
    reg [LIT_SIZE - 1 : 0]          rf      [0 : RF_SIZE - 1];
    reg [CMD_SIZE - 1 : 0]          cmd;
    reg [ADDR_CMD_MEM_SIZE - 1 : 0] pc = 0;
    reg [LIT_SIZE - 1 : 0]          OpA, OpB;
    reg [31 : 0]                    res;
    reg [2:0]                       stage_counter = 0;
    

    wire [COP_SIZE - 1 : 0] cop = cmd [CMD_SIZE - 1 -: COP_SIZE];
    wire [ADDR_MEM_SIZE - 1 : 0] addr_m_1= cmd[CMD_SIZE - 1 - COP_SIZE -: ADDR_MEM_SIZE];
    wire [ADDR_RF_SIZE - 1 : 0] addr_r_1 = cmd[CMD_SIZE - 1 - COP_SIZE -: ADDR_RF_SIZE];
    wire [ADDR_RF_SIZE - 1 : 0] addr_r_2 = cmd[CMD_SIZE - 1 - COP_SIZE - ADDR_RF_SIZE -: ADDR_RF_SIZE];
    wire [ADDR_RF_SIZE - 1 : 0] addr_r_3 = cmd[CMD_SIZE - 1 - COP_SIZE - 2*ADDR_RF_SIZE -: ADDR_RF_SIZE];
    wire [LIT_SIZE - 1 : 0]     literal  = cmd[ 0 +: LIT_SIZE];

initial begin
//        for(i = 0; i < MEM_SIZE; i = i + 1)
//            mem[i] = 0;
        for(i = 0; i < RF_SIZE; i = i + 1)
            rf[i] = 0;
        $readmemb("C:/VAVADO/progs/CPU_L/mem.mem", mem);
        $readmemb("C:/VAVADO/progs/CPU_L/cmd_mem.mem", cmd_mem);
    end

always @(posedge clk ) begin
        else if (reset || stage_counter == 4) begin
            stage_counter <= 0;
        end 
        else begin
            stage_counter <= stage_counter + 1;
        end
    end

    always @(posedge clk ) begin
        if (reset) begin
            cmd <= {(CMD_SIZE){1'b0}};
        end else begin
            if (stage_counter == 0) begin
                cmd <= cmd_mem[pc];
            end
        end
    end

    always @(posedge clk ) begin
        if (reset) begin
            OpA <= 0;
        end else begin
            if (stage_counter == 1) begin
                case (cop)
                    
                endcase
            end
        end
    end
    
    always @(posedge clk ) begin
        if (reset) begin
            OpB <= 0;
        end else begin
            if (stage_counter == 2) begin
                case (cop)
                    
                endcase
            end
        end
    end
    
    always @(posedge clk ) begin
        if (reset) begin
            res <= {(2*LIT_SIZE){1'b0}};
        end else begin
            if (stage_counter == 3) begin
                case (cop)

                endcase
            end
        end
    end
    
    always @(posedge clk ) begin
        if (reset) begin
            pc <= 0;
        end else begin
            if (stage_counter == 4) begin
                case (cop)
                    
                    default: pc <= pc + 1;
                endcase
            end
        end
    end

always @(posedge clk ) begin

    if (stage_counter == 4) begin
            case (cop)
                
            endcase
        end
    end

    always @(posedge clk ) begin
        
        if (stage_counter == 4) begin
            case (cop)
                
            endcase
        end
    end


endmodule