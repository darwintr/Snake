vlib work
vlog -timescale 1ns/1ns control.v
vsim control

log {/*}
add wave {/*}

force {clk} 0 0 ns, 1 10 ns -r 20 ns
force {dirControl} 0111 0 ns, 1011 21 ns, 1101 41 ns, 1110 61 ns

run 80ns