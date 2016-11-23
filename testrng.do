#	input clk,
#	input rst,

vlib work
vlog -timescale 1ns/1ns rng.v
vsim rng

log {/*}
add wave {/*}


force {clk} 0 0 ns, 1 10 ns -r 20 ns
force {rst} 1 0 ns, 0 1 ns, 1 2 ns
force {seed} 10#22112


run 1000 ns