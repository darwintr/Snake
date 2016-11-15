vlib work
vlog -timescale 1ns/1ns control.v
vsim control

log {/*}
add wave {/*}

force {clk} 0 0 ns, 1 10 ns -r 20 ns
force {dirControl} 1000 0 ns, 0100 21 ns, 0010 41 ns, 0001 61 ns

run 80ns