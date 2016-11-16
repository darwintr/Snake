#input [3:0] dirControl;
#input clk;
#input reset_n;
vlib work
vlog -timescale 1ns/1ns ramWrapper.v
vsim -L altera_mf_ver ramWrapper

log {/*}
add wave {/*}



force {clk} 1 0 ns, 0 5 ns -r 10 ns
force {reset_n} 0 0 ns, 1 6 ns
force {dirControl} 0000

run 10000 ns