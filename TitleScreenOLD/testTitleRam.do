#	input clk,
#	input rst,
#	input [2:0] colour_in,
#	input [10:0] length, 
#	input go,

vlib work
vlog -timescale 1ns/1ns ram_title.v
vsim -L altera_mf_ver ram_title

log {/*}
add wave {/*}

force {clock} 0 0 ns, 1 1 ns -r 2 ns
force {wren} 0
force {address} 011101100001001

run 10000 ns