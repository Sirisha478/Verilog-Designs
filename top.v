module top(PCLK,PRESETn,start,wr_rd,addr,wdata,rdata,PSLVERR);
input PCLK;
input PRESETn;
input start;
input wr_rd;
input [7:0] addr;
input [7:0] wdata;
output [7:0] rdata;
output PSLVERR;
wire [7:0] PADDR;
wire [7:0] PWDATA;
wire [7:0] PRDATA;
wire PWRITE;
wire PSEL;
wire PENABLE;
wire PREADY;
apb_master M1(
.PCLK(PCLK),
.PRESETn(PRESETn),
.start(start),
.wr_rd(wr_rd),
.addr(addr),
.wdata(wdata),
.PRDATA(PRDATA),
.PREADY(PREADY),
.PSLVERR(PSLVERR),
.PADDR(PADDR),
.PWDATA(PWDATA),
.PWRITE(PWRITE),
.PSEL(PSEL),
.PENABLE(PENABLE),
.rdata(rdata)
);
apb_slave S1(
.PCLK(PCLK),
.PRESETn(PRESETn),
.PSEL(PSEL),
.PENABLE(PENABLE),
.PWRITE(PWRITE),
.PADDR(PADDR),
.PWDATA(PWDATA),
.PRDATA(PRDATA),
.PREADY(PREADY),
.PSLVERR(PSLVERR)
);
endmodule
