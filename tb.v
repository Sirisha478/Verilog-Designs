//====================================================
// TESTBENCH
//====================================================
module tb;
reg clk;
reg rst;
reg start;
reg [7:0] tx_data;
wire tx;
wire busy;
wire [7:0] rx_data;
wire done;
//====================================================
// UART TX
//====================================================
uart_tx #(
    .CLKS_PER_BIT(10)
)
TX (
    .clk(clk),
    .rst(rst),
    .start(start),
    .data(tx_data),
    .tx(tx),
    .busy(busy)
);
//====================================================
// UART RX
//====================================================
uart_rx #(
    .CLKS_PER_BIT(10)
)
RX (
    .clk(clk),
    .rst(rst),
    .rx(tx),
    .data(rx_data),
    .done(done)
);
//====================================================
// CLOCK
//====================================================
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end
//====================================================
// TEST
//====================================================
initial begin
    rst     = 1;
    start   = 0;
    tx_data = 8'h00;
    #20;
    rst = 0;
    // Send ASCII A
    #20;
    tx_data = 8'h41;
    start = 1;
    #10;
    start = 0;
    // Wait for complete UART frame
    #1200;
    $display("----------------------------------------");
    $display("Transmitted Data   = %h", tx_data);
    $display("Received Data      = %h", rx_data);
    $display("Received Character = %c", rx_data);
    $display("RX Done            = %b", done);
    $display("----------------------------------------");
    $finish;
end

//====================================================
// MONITOR
//====================================================
initial begin
    $monitor(
        "Time=%0t | TX=%b | Busy=%b | RX_DATA=%h | Done=%b",
        $time,
        tx,
        busy,
        rx_data,
        done
    );
end
endmodule
