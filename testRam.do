#input [3:0] dirControl;
#input clk;
#input reset_n;
vlib work
vlog -timescale 1ns/1ns ramInterface.v
vsim -L altera_mf_ver ramInterface

log {/*}
add wave -r {/*}


force {clk} 1 0 ns, 0 5 ns -r 10 ns
force {reset_n} 0 0 ns, 1 6 ns
force {dirControl} 1111 0ns, 1110 3ns

run 10000 ns