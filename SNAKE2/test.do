#input [3:0] dirControl;
#input clk;
#input reset_n;
vlib work
vlog -timescale 1ns/1ns ramInterface.v
vsim ramInterface

log {/*}
add wave {/*}


force {clk} 1 0 ns, 0 10 ns -r 20 ns
force {reset_n} 0 0 ns, 1 11 ns
force {dirControl} 1111 0ns, 1110 3ns

run 3000 ns