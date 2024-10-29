vlib work
vlog -reportprogress 300 -work work E:/Thesis/FInal/ram_controller.sv
vlog -reportprogress 300 -work work E:/Thesis/FInal/ram_controller_tb.sv
vlog -reportprogress 300 -work work E:/Thesis/FInal/pim_controller.sv
vsim -voptargs=+acc work.ram_controller_tb
add wave -position insertpoint  \
sim:/ram_controller_tb/clk \
sim:/ram_controller_tb/reset_n \
sim:/ram_controller_tb/riscv_addr \
sim:/ram_controller_tb/riscv_wdata \
sim:/ram_controller_tb/riscv_wmask \
sim:/ram_controller_tb/riscv_rstrb \
sim:/ram_controller_tb/riscv_rdata \
sim:/ram_controller_tb/riscv_rbusy \
sim:/ram_controller_tb/riscv_wbusy \
sim:/ram_controller_tb/ram_addr \
sim:/ram_controller_tb/ram_wdata \
sim:/ram_controller_tb/ram_wen \
sim:/ram_controller_tb/ram_rden \
sim:/ram_controller_tb/ram_byteena \
sim:/ram_controller_tb/ram_rdata\
sim:/ram_controller_tb/dut/state \
sim:/ram_controller_tb/dut/next_state \
sim:/ram_controller_tb/dut/is_io_access
run -all