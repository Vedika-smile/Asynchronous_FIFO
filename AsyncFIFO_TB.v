module AsyncFIFO_Test ;

 localparam DATA_WIDTH = 8;
 localparam FIFO_Depth = 16;
 localparam ptr_size = $clog2(FIFO_Depth);

 reg wr_enb, rd_enb;
 reg wr_clk, rd_clk;
 reg wr_rst, rd_rst;
 reg [DATA_WIDTH-1:0] d_in;
 
 wire [DATA_WIDTH-1:0] data_out;
 wire [ptr_size : 0] b_wr_ptr;
  wire [ptr_size : 0] b_rd_ptr;
 wire full, empty;

 
 Async_FIFO #(
  .width(DATA_WIDTH),
 .depth(FIFO_Depth),
 .ptr_size(ptr_size)
 ) dut (
  wr_enb,
  wr_clk,
  wr_rst,
 d_in,
 b_wr_ptr,
 rd_enb,
 rd_clk,
 rd_rst,
 data_out,
  b_rd_ptr,
  full,
  empty    
 );

//clock
 always #20 rd_clk <= ~rd_clk; // 25 MHz
 always #5  wr_clk <= ~wr_clk; // 100 MHz

 integer i;

 initial begin
     rd_clk = 0;
     wr_clk = 0;
     rd_rst  = 1;
     wr_rst  = 1;
     wr_enb  = 0;
     rd_enb  = 0;
     d_in = 0;

     #40;
     rd_rst = 0;
     wr_rst = 0;

   // --------- TEST SEQUENCE ---------

   // Burst write 5 values
      wr_enb = 1;
      for (i = 0; i < 5; i = i + 1) begin
          d_in = i;
          #(10); // wait 2 wr_clk cycles
        end
        wr_enb = 0;

    // Wait a bit, then read 3 values
        #80; // 2 rd_clk cycles
        rd_enb = 1;
        #(40*3); // read 3 items
        rd_enb = 0;

        // Burst write 8 more values
        #20;
        wr_enb = 1;
        for (i = 5; i < 13; i = i + 1) begin
            d_in = i;
            #(10);
        end
        wr_enb = 0;

        // Read everything until empty
        #80;
        rd_enb = 1;
        while (!empty) begin
            #(40);
        end
        rd_enb = 0;

        // Fill FIFO fully
        wr_enb = 1;
        for (i = 100; i < 100 + FIFO_Depth; i = i + 1) begin
            d_in = i;
            #(10);
        end
        wr_enb = 0;

        // Read half FIFO
        #60;
        rd_enb = 1;
        #(40*(FIFO_Depth/2));
        rd_enb = 0;

        // Write more while reading (overlap)
        #20;
        wr_enb = 1;
        for (i = 200; i < 204; i = i + 1) begin
            d_in = i;
            #(10);
        end
        wr_enb = 0;

        rd_enb = 1;
        #(40*(FIFO_Depth/2 + 4)); // read remaining + new
        rd_enb = 0;

        // Done
        #100;
        $finish;
    end

 initial begin 
    $dumpfile("async_FIFO.vcd");
    $dumpvars(0, AsyncFIFO_Test);

 end 

endmodule
  














