# Base code :
	# riscvtest.s
	# Sarah.Harris@unlv.edu
	# David_Harris@hmc.edu
	# 27 Oct 2020

main:
addi x2, x0, 5			# x2 = 5
addi x3, x0, 12			# x3 = 12
addi x7, x3, -9			# x7 = 12 - 9 = 3
or   x4, x7, x2 		# x4 = (3 or 5) = 7
and  x5, x3, x4			# x5 = (12 AND 7) = 4
add x5, x5, x4			# x5 = 4 + 7 = 11
beq x5, x7, end 		# shouldn't be taken
slt x4, x3, x4 			# x4 = (12 < 7) = 0
beq x4, x0, around 	# should be taken
addi x5, x0,0 			# shouldn't execute
around:
slt x4, x7, x2 			# x4 = (3 < 5) = 1
add x7, x4, x5 			# x7 = (1 + 11) = 12
sub x7, x7, x2 			# x7 = (12 - 5) = 7
sw x7, 184(x3) 			# [184] = 7
lw x2, 196(x0) 			# x2 = [184] = 7
add x9, x2, x5 			# x9 = (7 + 11) = 18
jal x3, end 				# jump to end, x3 = 0x44
addi x2, x0,1 			# shouldn't execute
end:
add x2, x2, x9 			# x2 = (7 + 18) = 25
sw x2, 0x40(x3) 		# [132] = 25
done:
beq x2, x2, ext     # jump addi
addi x2, x0,1 			# shouldn't execute
ext:
xori x2, x2, 0xF0   # x2 = x2 XOR 0xF0 = 0x10 = 16
slli x2, x2, 2      # x2 = x2 << 2 = 64
srli x2, x2, 1      # x2 = x2 >> 1 = 32
jal ra, funct       # jump to funct
jal x0, main 		    # infinite loop
funct:
addi x2, x2, 8      # x2 = x2 + 8 = 40
jalr x0, ra, 0      # return
