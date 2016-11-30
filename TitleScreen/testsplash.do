vlib work
vlog -timescale 1ns/1ns splash.v
vsim splash

log {/*}
add wave {/*}

force {clk} 0 0 ns, 1 1 ns -r 2 ns
force {rst} 1 0 ns, 0 1 ns, 1 2 ns
force {start} 1 0 ns, 0 210 ns, 1 212 ns, 0 1700 ns, 1 1800 ns
force {isDead} 0 0 ns, 1 500 ns, 0 502 ns
force {tick} 0 0 ns, 1 750 ns, 0 752 ns, 1 1500 ns, 0 1502 ns


run 2500 ns

