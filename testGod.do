#	input clk,
#	input rst,
#	input [2:0] colour_in,
#	input [10:0] length, 
#	input go,

vlib work
vlog -timescale 1ns/1ns snakeBackend.v
vsim -L altera_mf_ver snakeInterface

log {/*}
add wave {/*}

force {clk} 0 0 ns, 1 10 ns -r 20 ns
force {reset_n} 1 0 ns, 0 1 ns, 1 2 ns
force {dirInControl} 1101 0 ns, 1111 2000 ns, 1110 4000 ns 
force {colour_in} 111

run 20000 ns