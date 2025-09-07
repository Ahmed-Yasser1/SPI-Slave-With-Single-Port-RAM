module SPI_tb ();
    reg MOSI, SS_n, clk, rst_n;
    wire MISO;

    SPI_wrapper dut (.*);

    initial begin
        clk = 0;
        forever
            #1 clk = ~ clk;
    end

    initial begin
        $readmemb("mem.dat", dut.ram.mem);
        rst_n = 1'b0;
        MOSI = 1'b0;
        SS_n = 1'b0;
        @(negedge clk);
        rst_n = 1'b1;
        $display("================================");
        $display("Write Address Phase: START");
        $display("================================");
        repeat (2) @(negedge clk);
        repeat (10) @(negedge clk);
        SS_n = 1'b1;
        repeat (2) @(negedge clk);
        $display("================================");
        $display("Write Address Phase: END");
        $display("================================");
        $display("================================");
        $display("Write Data Phase: START");
        $display("================================");
        SS_n = 1'b0;
        repeat (3) @(negedge clk);
        MOSI = 1'b1;
        @(negedge clk);
        repeat (10) @(negedge clk);
        SS_n = 1'b1;
        repeat (2) @(negedge clk);
        $display("================================");
        $display("Write Data Phase: END");
        $display("================================");
        $display("================================");
        $display("Read Address Phase: START");
        $display("================================");
        SS_n = 1'b0;
        MOSI = 1'b1;
        repeat (3) @(negedge clk);
        MOSI = 1'b0;
        repeat (10) @(negedge clk);
        SS_n = 1'b1;
        repeat (2) @(negedge clk);
        $display("================================");
        $display("Read Address Phase: END");
        $display("================================");
        $display("================================");
        $display("Read Data Phase: START");
        $display("================================");
        SS_n = 1'b0;
        MOSI = 1'b1;
        repeat (2) @(negedge clk);
        repeat (20) @(negedge clk);
        SS_n = 1'b1;
        repeat (2) @(negedge clk);
        $display("================================");
        $display("Read Data Phase: END");
        $display("================================");
        $stop;
    end
endmodule
