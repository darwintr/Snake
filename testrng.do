#	input clk,
#	input rst,

vlib work
vlog -timescale 1ns/1ns rng.v
vsim -L rng

log {/*}
add wave {/*}


force {clk} 0 0 ns, 1 10 ns -r 20 ns
force {rst} 1 0 ns, 0 1 ns, 1 2 ns



run 100 ns