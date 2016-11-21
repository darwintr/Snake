#	input clk,
#	input rst,
#	input [2:0] colour_in,
#	input [10:0] length, 
#	input go,

vlib work
vlog -timescale 1ns/1ns snakeLogic.v
vsim snakeLogic

log {/*}
add wave {/*}

force {clk} 0 0 ns, 1 10 ns -r 20 ns
force {rst} 1 0 ns, 0 1 ns, 1 2 ns
force {colour_in} 111
force {length} 11
force {go} 0 0 ns, 1 400 ns, 0 411 ns

run 2000 ns