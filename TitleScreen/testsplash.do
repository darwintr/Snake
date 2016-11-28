vlib work
vlog -timescale 1ns/1ns DrawScreen.v
vsim -L altera_mf_ver DrawBlack

log {/*}
add wave {/*}

force {clk} 0 0 ns, 1 1 ns -r 2 ns
force {rst} 1 0 ns, 0 1 ns, 1 2 ns
force {showTitle} 1 0ns

run 40000 ns

