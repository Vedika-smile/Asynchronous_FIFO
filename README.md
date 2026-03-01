##Asynchronous FIFO (Dual Clock FIFO)
#Overview

This project implements a parameterized Asynchronous FIFO in Verilog. The design allows safe data transfer between two different clock domains using Gray-coded pointers and two-stage synchronizers to prevent metastability issues.
The FIFO supports independent write and read clocks and generates full and empty status flags.

#Design Description

The Asynchronous FIFO consists of the following modules:
Async_FIFO.v – Top-level module integrating all submodules
FIFO_MEM.v – Dual-port memory for data storage
WRITE_PTR.v – Write pointer logic and full detection
READ_PTR.v – Read pointer logic and empty detection
twostage_sync.v – Two-flip-flop synchronizer for clock domain 

#Parameters

The design is parameterized to support configurable data width and depth.
DATA_WIDTH defines the width of the input and output data.
FIFO_DEPTH defines the total number of entries in the FIFO.
PTR_WIDTH is automatically calculated based on FIFO depth.

#Functional Description

Write Operation
Data is written on the rising edge of wr_clk.
When wr_en is high and the FIFO is not full, input data is stored in memory.
The write pointer increments after each successful write.
The write pointer is converted to Gray code before being synchronized to the read clock domain.

Read Operation
Data is read on the rising edge of rd_clk.
When rd_en is high and the FIFO is not empty, data is read from memory.
The read pointer increments after each successful read.
The read pointer is converted to Gray code before being synchronized to the write clock domain.

Clock Domain Crossing Method
To safely transfer pointer values between clock domains:
Binary pointers are converted to Gray code.
Gray-coded pointers are passed through a two-flip-flop synchronizer.
Full and empty conditions are determined using synchronized Gray pointers.
This approach ensures reliable operation across asynchronous clock domains.

#Simulation

The design can be simulated using Icarus Verilog.

#Applications

UART buffering
Network packet buffering
Streaming data systems
General clock domain crossing applications

#Author

Vedika Malpani
B.Tech – Electronics and Communication Engineering
MNIT Jaipur
