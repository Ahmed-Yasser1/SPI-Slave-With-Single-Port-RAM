module RAM (din, clk, rst_n, rx_valid, dout, tx_valid);
    parameter MEM_DIPTH = 256;
    parameter ADDR_SIZE = 8;

    input clk, rst_n, rx_valid;
    input [9 : 0] din;
    output reg [7 : 0] dout;
    output reg tx_valid;

    reg [ADDR_SIZE - 1 : 0] mem [MEM_DIPTH - 1 : 0];
    reg [7 : 0] add;

    always @ (posedge clk) begin
        if (! rst_n) begin
            dout <= 0;
            tx_valid <= 0;
            add <= 0;
        end
            
        else begin
            if (rx_valid) begin
                case (din[9 : 8])
                    2'b00 : add <= din[7 : 0];
                    2'b01 : mem[add] <= din[7 : 0];
                    2'b10 : add <= din[7 : 0];
                    2'b11 : begin
                        dout <= mem[add];
                        tx_valid <= 1'b1;
                    end
                endcase
            end
        end
    end
endmodule