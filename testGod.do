#	input clk,
#	input rst,
#	input [2:0] colour_in,
#	input [10:0] length, 
#	input go,

vlib work
vlog -timescale 1ns/1ns Backend.v
vsim -L altera_mf_ver snakeInterface

log {/*}
add wave {/*}
add wave {/snakeInterface/dp/*}
force {clk} 0 0 ns, 1 1 ns -r 2 ns
force {rst} 1 0 ns, 0 1 ns, 1 2 ns
force {dirInControl} 0111 0 ns, 1111 10 ns, 1101 200 ns, 1111 210 ns

force {colour_in} 111

run 1000 ns