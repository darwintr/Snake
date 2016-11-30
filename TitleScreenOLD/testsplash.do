vlib work
vlog -timescale 1ns/1ns splash.v
vsim splash

log {/*}
add wave {/*}

force {clk} 0 0 ns, 1 1 ns -r 2 ns
force {rst} 1 0 ns, 0 1 ns, 1 2 ns
force {start} 1 0 ns, 0 210 ns, 1 212 ns
force {isDead} 0 0 ns, 1 500 ns, 0 502 ns
force {tick} 1 0 ns, 0 750 ns, 1 752 ns, 0 1500 ns, 1 1502 ns


run 2000 ns

