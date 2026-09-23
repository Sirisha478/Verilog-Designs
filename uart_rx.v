//====================================================
// UART RECEIVER
//====================================================
module uart_rx (
    input clk,
    input rst,
    input rx,
    output reg [7:0] data,
    output reg done
);
parameter CLKS_PER_BIT = 10;
reg [7:0] data_reg;
reg [3:0] clk_count;
reg [3:0] bit_count;
reg receiving;
always @(posedge clk) begin
    if (rst) begin
        data_reg  <= 8'b0;
        data      <= 8'b0;
        clk_count <= 0;
        bit_count <= 0;
        receiving <= 1'b0;
        done      <= 1'b0;
    end
    else begin
        done <= 1'b0;
        //============================================
        // WAIT FOR START BIT
        //============================================
        if (!receiving) begin
            if (rx == 1'b0) begin
                // Start bit detected
                receiving <= 1'b1;
                bit_count <= 0;
                // Start counting from 0
                clk_count <= 0;
            end
        end
        //============================================
        // RECEIVING
        //============================================
        else begin
            // First wait half a bit to reach
            // middle of START bit
            if (bit_count == 0) begin
                if (clk_count == (CLKS_PER_BIT/2)-1) begin
                    clk_count <= 0;
                    // Now start receiving DATA bits
                    bit_count <= 1;
                end
                else begin
                    clk_count <= clk_count + 1;
                end
            end
            //========================================
            // RECEIVE DATA BITS
            //========================================
            else if (bit_count <= 8) begin
                if (clk_count == CLKS_PER_BIT-1) begin
                    clk_count <= 0;
                    // Store data bit
                    data_reg[bit_count-1] <= rx;
                    bit_count <= bit_count + 1;
                end
                else begin
                    clk_count <= clk_count + 1;
                end
            end
            //========================================
            // STOP BIT
            //========================================
            else begin
                if (clk_count == CLKS_PER_BIT-1) begin
                    clk_count <= 0;
                    data <= data_reg;
                    done <= 1'b1;
                    receiving <= 1'b0;
                end
                else begin
                    clk_count <= clk_count + 1;
                end
            end
        end
    end
end
endmodule
