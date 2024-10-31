onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /SOC_tb/reset
add wave -noupdate /SOC_tb/clk
add wave -noupdate /SOC_tb/dut/CPU/state
add wave -noupdate /SOC_tb/dut/CPU/PC
add wave -noupdate /SOC_tb/dut/CPU/mem_rbusy
add wave -noupdate /SOC_tb/dut/CPU/mem_wbusy
add wave -noupdate -radix unsigned /SOC_tb/CPU_cycles
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {767286 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2002082 ps}
