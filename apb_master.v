module apb_master(PCLK,PRESETn,start,wr_rd,addr,wdata,PRDATA,PREADY,PSLVERR,PADDR,PWDATA,PWRITE,PSEL,PENABLE,rdata);
    input PCLK;
    input PRESETn;
    input start;
    input wr_rd;
    input [7:0] addr;
    input [7:0] wdata;
    input [7:0] PRDATA;
    input PREADY;
    input PSLVERR;
    output reg [7:0] PADDR;
    output reg [7:0] PWDATA;
    output reg PWRITE;
    output reg PSEL;
    output reg PENABLE;
    output reg [7:0] rdata;
parameter IDLE=2'd0,
          SETUP=2'd1,
          ACCESS=2'd2;
reg [1:0] state;
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
        state <= IDLE;
    else
    begin
        case(state)
        IDLE:
            if(start)
                state <= SETUP;
        SETUP:
            state <= ACCESS;
        ACCESS:
            if(PREADY)
                state <= IDLE;
        default:
            state <= IDLE;
        endcase
    end
end
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
    begin
        PSEL    <= 0;
        PENABLE <= 0;
        PWRITE  <= 0;
        PADDR   <= 0;
        PWDATA  <= 0;
        rdata   <= 0;
    end
    else
    begin
        case(state)
        IDLE:
        begin
            PSEL    <= 0;
            PENABLE <= 0;
        end

        SETUP:
        begin
            PSEL    <= 1;
            PENABLE <= 0;
            PADDR   <= addr;
            PWRITE  <= wr_rd;
            PWDATA  <= wdata;
        end
        ACCESS:
        begin
            PSEL    <= 1;
            PENABLE <= 1;
            if(PREADY)
            begin
                if(PWRITE)
				begin
                    rdata <= PWDATA;
			        $display("MASTER READ=%0d",PWDATA);
            end
                if(PSLVERR)
                    $display("PSLVERR DETECTED");
            end
        end
        endcase
    end
end
endmodule
