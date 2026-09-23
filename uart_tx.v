//====================================================
// UART TRANSMITTER
//====================================================
module uart_tx (
    input clk,
    input rst,
    input start,
    input [7:0] data,
    output reg tx,
    output reg busy
);
parameter CLKS_PER_BIT = 10;
reg [7:0] data_reg;
reg [3:0] clk_count;
reg [3:0] bit_count;
always @(posedge clk) begin
    if (rst) begin
        tx        <= 1'b1;
        busy      <= 1'b0;
        data_reg  <= 8'b0;
        clk_count <= 0;
        bit_count <= 0;
    end
    else begin
        // Start transmission
        if (start && !busy) begin
            data_reg  <= data;
            busy      <= 1'b1;
            clk_count <= 0;
            bit_count <= 0;
            // Start bit
            tx <= 1'b0;
        end
        else if (busy) begin
            if (clk_count == CLKS_PER_BIT-1) begin
                clk_count <= 0;
                // Data bits
                if (bit_count < 8) begin
                    tx <= data_reg[bit_count];
                    bit_count <= bit_count + 1;
                end
                // Stop bit
                else begin
                    tx <= 1'b1;
                    busy <= 1'b0;
                end
            end
            else begin
                clk_count <= clk_count + 1;
            end
        end
    end
end
endmodule


