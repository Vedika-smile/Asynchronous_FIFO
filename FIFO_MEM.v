module fifo_mem #(
 parameter width = 8,
 parameter ptr_size = 4,
 parameter depth = 16
 )(
 input [width-1 : 0] d_in,
 input [ptr_size :0] wr_ptr,
 input [ptr_size :0] rd_ptr,
 input wr_clk,
 input rd_clk,
 input full, 
 input empty,
 input wr_en,
 input rd_en,
 output reg [width-1 : 0] d_out );
 
 reg [width-1 : 0] mem [depth -1 : 0];

 //write 
 
 always @(posedge wr_clk) begin
  if (wr_en && !full) begin
    mem [wr_ptr] <= d_in;
  end
 end

//read
 always @(posedge rd_clk) begin
  if(rd_en && !empty) begin
    d_out <= mem[rd_ptr];
  end
 end 

endmodule  
 
//rd_rst and wr_rst dekhna 