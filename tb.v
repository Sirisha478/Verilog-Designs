module tb;
reg PCLK;
reg PRESETn;
reg start;
reg wr_rd;
reg [7:0] addr;
reg [7:0] wdata;
wire [7:0] rdata;
wire PSLVERR;
top dut(.*);
always #5 PCLK = ~PCLK;
initial
begin
PCLK = 0;
PRESETn = 0;
start = 0;
wr_rd = 0;
addr = 0;
wdata = 0;
#20;
PRESETn = 1;
@(posedge PCLK);
start = 1;
wr_rd = 1;
addr = 8'd10;
wdata = 8'd55;
@(posedge PCLK);
start = 0;
repeat(2)
@(posedge PCLK);
$display("WRITE COMPLETED");
@(posedge PCLK);
start = 1;
wr_rd = 0;
addr = 8'd10;
@(posedge PCLK);
start = 0;
repeat(2)
@(posedge PCLK);
$display("READ DATA = %d",rdata);
@(posedge PCLK);
start = 1;
wr_rd = 0;
addr = 8'hFF;
@(posedge PCLK);
start = 0;
repeat(2)
@(posedge PCLK);
if(PSLVERR)
$display("SLAVE ERROR GENERATED");
else
$display("NO ERROR");
#20;
$finish;
end
endmodule
