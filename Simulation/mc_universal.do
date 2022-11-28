onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gray60 /heirv32_mc_tb/clk
add wave -noupdate -color Gray60 /heirv32_mc_tb/rst
add wave -noupdate -color Gray80 /heirv32_mc_tb/U_0/testInfo
add wave -noupdate -color Gold -radix binary /heirv32_mc_tb/btns
add wave -noupdate -expand -group PC /heirv32_mc_tb/U_1/PC
add wave -noupdate -expand -group PC /heirv32_mc_tb/U_1/PCNext
add wave -noupdate -expand -group PC /heirv32_mc_tb/U_1/adr
add wave -noupdate -expand -group Instr/Data /heirv32_mc_tb/U_1/instruction
add wave -noupdate -expand -group ALU /heirv32_mc_tb/U_1/srcA
add wave -noupdate -expand -group ALU /heirv32_mc_tb/U_1/srcB
add wave -noupdate -expand -group ALU /heirv32_mc_tb/U_1/resultSrc
add wave -noupdate -expand -group ALU /heirv32_mc_tb/U_1/result
add wave -noupdate -expand -group Registers -label registers /heirv32_mc_tb/U_1/U_registerFile/larr_registers
add wave -noupdate -expand -group Registers -label btns_reg /heirv32_mc_tb/U_1/U_registerFile/larr_registers(31)
add wave -noupdate -expand -group Registers -label leds_reg /heirv32_mc_tb/U_1/U_registerFile/larr_registers(30)
add wave -noupdate -label RD1 /heirv32_mc_tb/U_1/RD1
add wave -noupdate -label RD2 /heirv32_mc_tb/U_1/writeData
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {66554 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {463160 ps}
