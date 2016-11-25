vlib work
vlog -timescale 1ns/1ns DecimalCounter.v
vsim decimalTimer

log {/*}
add wave {/*}
force {clk} 0 0 ns, 1 1 ns -r 2 ns
force {rst} 1 0 ns, 0 1 ns, 1 2 ns

run 1000 ns