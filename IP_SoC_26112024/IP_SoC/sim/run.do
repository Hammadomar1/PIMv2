vlib work
vmap altera_mf "C:/intelFPGA_lite/22.1std/questa_fse/intel/verilog/altera_mf"

vlog -sv "../rtl/*.v"
vlog -sv "../rtl/*.sv"
vlog -sv "../ip/RAM1_IP.v"
vlog -sv "../ip/RAM2_IP.v"


vsim -voptargs=+acc -L altera_mf -suppress "vsim-3839" work.SoC_tb +seed=27478




#do wave.do
add wave *
add wave -position insertpoint  \
sim:/SoC_tb/uut/RAM1_Control/RAM1_CTRL/state \
sim:/SoC_tb/uut/RAM1_Control/RAM1_CTRL/riscv_rbusy \
sim:/SoC_tb/uut/RAM1_Control/RAM1_CTRL/riscv_wbusy \
sim:/SoC_tb/uut/RAM1_Control/RAM1_CTRL/ram_wen \
sim:/SoC_tb/uut/RAM1_Control/RAM1_CTRL/ram_rden \
sim:/SoC_tb/uut/RAM1_Control/RAM1_CTRL/riscv_rstrb
run -all