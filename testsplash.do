<<<<<<< HEAD
vlib work
vlog -timescale 1ns/1ns splash.v
vsim splash

log {/*}
add wave {/*}

force {clk} 0 0 ns, 1 1 ns -r 2 ns
force {rst} 1 0 ns, 0 1 ns, 1 2 ns
force {isDead} 0 0ns, 1 100ns
force {start} 1 0ns, 0 55ns

run 200 ns
=======
vlib work
vlog -timescale 1ns/1ns splash.v
vsim splash

log {/*}
add wave {/*}

force {clk} 0 0 ns, 1 1 ns -r 2 ns
force {rst} 1 0 ns, 0 1 ns, 1 2 ns
force {start} 1 0ns, 0 55ns, 1 60ns
force {isDead} 0 0ns, 1 1000ns

run 2000 ns
>>>>>>> aee6c5a38950ff4b2c65a849f7c0a2f1cb5588c0
