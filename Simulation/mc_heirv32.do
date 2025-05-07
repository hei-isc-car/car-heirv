onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gray60 -label rst /heirv32_mc_tb/U_tester/rst
add wave -noupdate -color Gray60 -label clk /heirv32_mc_tb/U_tester/clk
add wave -noupdate -color Gray70 -label info /heirv32_mc_tb/U_tester/testInfo
add wave -noupdate -color {Violet Red} -label {Program loop} /heirv32_mc_tb/U_tester/loopCounter
add wave -noupdate -expand -group PC -color Green -label PC /heirv32_mc_tb/U_heirv32/PC
add wave -noupdate -expand -group PC -color Green -label PCNext /heirv32_mc_tb/U_heirv32/PCNext
add wave -noupdate -expand -group Instr/Data -color Gold -label ramContent /heirv32_mc_tb/U_heirv32/U_instrDataManager/U_instrDataMemory/U_bram/ramContent
add wave -noupdate -expand -group Instr/Data -label addressIn /heirv32_mc_tb/U_heirv32/U_instrDataManager/U_instrDataMemory/U_bram/addressIn
add wave -noupdate -expand -group Instr/Data -color Green -label readData /heirv32_mc_tb/U_heirv32/U_instrDataManager/U_instrDataMemory/readData
add wave -noupdate -expand -group Instr/Data -color Green -label instruction /heirv32_mc_tb/U_heirv32/U_instrDataManager/U_instrForward/instruction
add wave -noupdate -expand -group {Control Unit} -label state /heirv32_mc_tb/U_heirv32/U_controlUnit/U_mainFSM/current_state
add wave -noupdate -expand -group {Control Unit} -color Green -label funct3 /heirv32_mc_tb/U_heirv32/U_controlUnit/funct3
add wave -noupdate -expand -group {Control Unit} -color Green -label funct7 /heirv32_mc_tb/U_heirv32/U_controlUnit/funct7
add wave -noupdate -expand -group {Control Unit} -color Green -label op /heirv32_mc_tb/U_heirv32/U_controlUnit/op
add wave -noupdate -expand -group {Control Unit} -color Green -label zero /heirv32_mc_tb/U_heirv32/U_controlUnit/zero
add wave -noupdate -expand -group {Control Unit} -label ALUControl /heirv32_mc_tb/U_heirv32/U_controlUnit/ALUControl
add wave -noupdate -expand -group {Control Unit} -label ALUSrcA /heirv32_mc_tb/U_heirv32/U_controlUnit/ALUSrcA
add wave -noupdate -expand -group {Control Unit} -label ALUSrcB /heirv32_mc_tb/U_heirv32/U_controlUnit/ALUSrcB
add wave -noupdate -expand -group {Control Unit} -label IRWrite /heirv32_mc_tb/U_heirv32/U_controlUnit/IRWrite
add wave -noupdate -expand -group {Control Unit} -label PCWrite /heirv32_mc_tb/U_heirv32/U_controlUnit/PCWrite
add wave -noupdate -expand -group {Control Unit} -label adrSrc /heirv32_mc_tb/U_heirv32/U_controlUnit/adrSrc
add wave -noupdate -expand -group {Control Unit} -label immSrc /heirv32_mc_tb/U_heirv32/U_controlUnit/immSrc
add wave -noupdate -expand -group {Control Unit} -label memWrite /heirv32_mc_tb/U_heirv32/U_controlUnit/memWrite
add wave -noupdate -expand -group {Control Unit} -label regWrite /heirv32_mc_tb/U_heirv32/U_controlUnit/regwrite
add wave -noupdate -expand -group {Control Unit} -label resultSrc /heirv32_mc_tb/U_heirv32/U_controlUnit/resultSrc
add wave -noupdate -expand -group ALU -color Green -label ctrl /heirv32_mc_tb/U_heirv32/U_alu/ctrl
add wave -noupdate -expand -group ALU -color Green -label srcA /heirv32_mc_tb/U_heirv32/U_alu/srcA
add wave -noupdate -expand -group ALU -color Green -label srcB /heirv32_mc_tb/U_heirv32/U_alu/srcB
add wave -noupdate -expand -group ALU -label res /heirv32_mc_tb/U_heirv32/U_alu/res
add wave -noupdate -expand -group ALU -label resWB /heirv32_mc_tb/U_heirv32/ALUOut
add wave -noupdate -expand -group Registers -label RD1 /heirv32_mc_tb/U_heirv32/U_registerFile/RD1
add wave -noupdate -expand -group Registers -label RD2 /heirv32_mc_tb/U_heirv32/U_registerFile/RD2
add wave -noupdate -label immExt /heirv32_mc_tb/U_heirv32/immExt
add wave -noupdate -label instruction /heirv32_mc_tb/U_heirv32/instruction
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1472399 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {4894171 ps}
run 3400 ns
