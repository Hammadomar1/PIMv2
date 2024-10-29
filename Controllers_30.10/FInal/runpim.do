vlib work
vlog -reportprogress 300 -work work E:/Thesis/FInal/ram_controller.sv
vlog -reportprogress 300 -work work E:/Thesis/FInal/ram_controller_tb.sv
vlog -reportprogress 300 -work work E:/Thesis/FInal/pim_controller.sv
vsim -voptargs=+acc work.pim_controller
add wave -position insertpoint  \
sim:/pim_controller/clk \
sim:/pim_controller/rst \
sim:/pim_controller/riscv_addr \
sim:/pim_controller/riscv_wdata \
sim:/pim_controller/riscv_wmask \
sim:/pim_controller/riscv_rstrb \
sim:/pim_controller/riscv_rdata \
sim:/pim_controller/riscv_rbusy \
sim:/pim_controller/riscv_wbusy \
sim:/pim_controller/pim_addr \
sim:/pim_controller/pim_wdata \
sim:/pim_controller/pim_wmask \
sim:/pim_controller/pim_rstrb \
sim:/pim_controller/pim_rdata \
sim:/pim_controller/pim_rbusy \
sim:/pim_controller/pim_wbusy \
sim:/pim_controller/ram_addr \
sim:/pim_controller/ram_wdata \
sim:/pim_controller/ram_wen \
sim:/pim_controller/ram_rden \
sim:/pim_controller/ram_byteena \
sim:/pim_controller/ram_rdata \
sim:/pim_controller/pim_sel
force -freeze sim:/pim_controller/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/pim_controller/rst 1'h0 0
force -freeze sim:/pim_controller/rst 1'h1 0
noforce sim:/pim_controller/rst
force -freeze sim:/pim_controller/rst 1'h0 0
force -freeze sim:/pim_controller/rst 1'h1 100
force -freeze sim:/pim_controller/riscv_addr 32'h11111111 0
force -freeze sim:/pim_controller/riscv_wdata 32'h11111111 0
force -freeze sim:/pim_controller/riscv_wmask 4'hf 0
force -freeze sim:/pim_controller/riscv_rstrb 1'h0 0
force -freeze sim:/pim_controller/pim_addr 32'h22222222 0
force -freeze sim:/pim_controller/pim_wdata 32'h2222222 0
force -freeze sim:/pim_controller/pim_wmask 4'hf 0
force -freeze sim:/pim_controller/pim_rstrb 1'h0 0
force -freeze sim:/pim_controller/ram_rdata 32'h12345678 0
force -freeze sim:/pim_controller/pim_sel 1'h0 0
force -freeze sim:/pim_controller/pim_sel 1'h1 1000