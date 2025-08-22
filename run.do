vlog -work work -vopt -sv -stats=none C:/Users/apb_sv_sv/top.svh
vsim -voptargs=+acc -l output.log work.apb_tb_top -l log.txt
add wave -position insertpoint sim:/apb_tb_top/intf/*

run -all
