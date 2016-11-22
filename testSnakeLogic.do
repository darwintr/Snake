#	input clk,
#	input rst,
#	input [2:0] colour_in,
#	input [10:0] length, 
#	input go,

vlib work
vlog -timescale 1ns/1ns snakeLogic.v
vsim -L altera_mf_ver snakeLogic

log {/*}
add wave {/*}

force {dirIn} 000
force {clk} 0 0 ns, 1 10 ns -r 20 ns
force {rst} 1 0 ns, 0 1 ns, 1 2 ns
force {colour_in} 111
force {length} 111
force {go} 0 0 ns, 1 2100 ns, 0 2111 ns


run 10000 ns