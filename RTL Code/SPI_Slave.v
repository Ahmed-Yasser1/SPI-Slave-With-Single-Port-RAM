module SPI_slave (MOSI, MISO, SS_n, clk, rst_n, rx_data, rx_valid, tx_data, tx_valid);
    parameter IDLE = 3'b000;
    parameter CHK_CMD = 3'b001;
    parameter WRITE = 3'b010;
    parameter READ_ADD = 3'b011;
    parameter READ_DATA = 3'b100;

    input MOSI, SS_n, clk, rst_n, tx_valid;
    input [7 : 0] tx_data;
    output reg MISO;
    output rx_valid;
    output reg [9 : 0] rx_data;

    (* fsm_encoding = "gray" *)
    reg [2 : 0] cs, ns;
    reg read_mode;
    reg [3 : 0] count_add, count_data;

    //Next State Logic
    always @ (*) begin
        case (cs)
            IDLE : begin
                if (SS_n == 1'b0)
                    ns = CHK_CMD;
                else
                    ns = IDLE; 
            end

            CHK_CMD : begin
                if ((MOSI == 1'b0) && (SS_n == 1'b0))
                    ns = WRITE;
                else if ((MOSI == 1'b1) && (SS_n == 1'b0) && (read_mode == 1'b0))
                    ns = READ_ADD;
                else if ((MOSI == 1'b1) && (SS_n == 1'b0) && (read_mode == 1'b1))
                    ns = READ_DATA;
                else
                    ns = IDLE;
            end
                
            WRITE : begin
                if (SS_n == 1'b1)
                    ns = IDLE;
                else
                    ns = WRITE;
            end

            READ_ADD : begin
                if (SS_n == 1'b1)
                    ns = IDLE;
                else
                    ns = READ_ADD;
            end
        
            READ_DATA : begin
                if (SS_n == 1'b1)
                    ns = IDLE;
                else
                    ns = READ_DATA;
            end
                
            default : ns = IDLE;
        endcase
    end

    //State Memory
    always @ (posedge clk) begin
        if (! rst_n)
            cs <= IDLE;
        else
            cs <= ns;
    end

    //Output Logic
    always @ (posedge clk) begin
        if (! rst_n) begin
            MISO <= 0;
            rx_data <= 0;
            count_add <= 0;
            count_data <= 0;
            read_mode <= 0;
        end

        else begin
            case (cs)
                IDLE : begin
                    MISO <= 0;
                    rx_data <= 0;
                    count_add <= 0;
                    count_data <= 0;
                end

                WRITE : begin
                   if (count_add < 10) begin
                        rx_data[9 - count_add] <= MOSI;
                        count_add <= count_add + 1;
                    end 
                end

                READ_ADD : begin
                   if (count_add < 10) begin
                        rx_data[9 - count_add] <= MOSI;
                        count_add <= count_add + 1;
                    end
                    if (count_add == 10) begin
                        read_mode <= 1'b1;
                    end 
                end

                READ_DATA : begin
                    if (count_add < 10) begin
                        rx_data[9 - count_add] <= MOSI;
                        count_add <= count_add + 1;
                    end
                    if ((tx_valid == 1'b1) && (count_add == 10)) begin
                        if (count_data < 8) begin
                            MISO <= tx_data[7 - count_data];
                            count_data <= count_data + 1;
                            read_mode <= 1'b0;
                        end
                        else
                            MISO <= 0;
                    end   
                end

                default : begin
                    MISO <= 0;
                    rx_data <= 0;
                    count_add <= 0;
                    count_data <= 0;
                end
            endcase
        end
    end

    assign rx_valid = ((((cs == WRITE) || (cs == READ_ADD) || (cs == READ_DATA)) && (count_add == 10)))? 1'b1 : 1'b0;

endmodule