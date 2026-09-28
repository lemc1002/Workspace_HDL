transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+C:/altera_ws/05_AluDisplay {C:/altera_ws/05_AluDisplay/m_fadder.v}
vlog  -work work +incdir+C:/altera_ws/05_AluDisplay {C:/altera_ws/05_AluDisplay/m_7SegDisp.v}
vlog  -work work +incdir+C:/altera_ws/05_AluDisplay {C:/altera_ws/05_AluDisplay/top_alu.v}
vlog  -work work +incdir+C:/altera_ws/05_AluDisplay {C:/altera_ws/05_AluDisplay/mux2to1.v}
vlog  -work work +incdir+C:/altera_ws/05_AluDisplay {C:/altera_ws/05_AluDisplay/mp_fadder.v}
vlog  -work work +incdir+C:/altera_ws/05_AluDisplay {C:/altera_ws/05_AluDisplay/mALUlogic.v}
vlog  -work work +incdir+C:/altera_ws/05_AluDisplay {C:/altera_ws/05_AluDisplay/m_mux16to1.v}
vlog  -work work +incdir+C:/altera_ws/05_AluDisplay {C:/altera_ws/05_AluDisplay/bin2bcd.v}

vlog  -work work +incdir+C:/altera_ws/05_AluDisplay {C:/altera_ws/05_AluDisplay/tb_bin2bcd.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_bin2bcd

add wave *
view structure
view signals
run -all
