module apb_slave(PCLK,PRESETn,PSEL,PENABLE,PWRITE,PADDR,PWDATA,PRDATA,PREADY,PSLVERR);
    input PCLK;
    input PRESETn;
    input PSEL;
    input PENABLE;
    input PWRITE;
    input [7:0] PADDR;
    input [7:0] PWDATA;
    output reg [7:0] PRDATA;
    output reg PREADY;
    output reg PSLVERR;
reg [7:0] mem[0:255];
integer i;
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
    begin
        PRDATA  <= 0;
        PREADY  <= 0;
        PSLVERR <= 0;
        for(i=0;i<256;i=i+1)
            mem[i] <= 0;
    end
    else
    begin
        PREADY  <= 0;
        PSLVERR <= 0;
        if(PSEL && PENABLE)
        begin
            PREADY <= 1;

            if(PWRITE)
            begin
                mem[PADDR] <= PWDATA;
				$display("Write Address=%d Data=%d",PADDR,PWDATA);
            end
            else
            begin
                PRDATA <= mem[PADDR];
				 $display("READ Address=%d Data=%d",PADDR,mem[PADDR]);
            end
        end
    end
end
endmodule
