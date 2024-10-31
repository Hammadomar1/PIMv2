vlib work
vmap altera_mf "C:/intelFPGA_lite/22.1std/questa_fse/intel/verilog/altera_mf"

vlog -sv "../rtl/*.v"
vlog -sv "../rtl/*.sv"
vlog -sv "../ip/RAM1_IP.v"

vlog -sv SOC_tb.sv
vsim -voptargs=+acc -L altera_mf work.SOC_tb
do wave.do
run -all