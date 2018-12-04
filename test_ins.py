from random import randint, choice
# how many line to print
n = 100
# instruction set
ins_set = [
	('0', 'addu {0}, {1}, {2}', 'reg', 'reg', 'reg'),
	('0', 'addu {0}, {1}, {2}', 'reg', 'reg', 'reg'),
	('0', 'addu {0}, {1}, {2}', 'reg', 'reg', 'reg'),
	('0', 'addu {0}, {1}, {2}', 'reg', 'reg', 'reg'),
	('0', 'subu {0}, {1}, {2}', 'reg', 'reg', 'reg'),
	('0', 'subu {0}, {1}, {2}', 'reg', 'reg', 'reg'),
	('0', 'subu {0}, {1}, {2}', 'reg', 'reg', 'reg'),
	('0', 'subu {0}, {1}, {2}', 'reg', 'reg', 'reg'),
	('0', 'sll {0}, {1}, {2}', 'reg', 'reg', 'shamt'),
	('0', 'sll {0}, {1}, {2}', 'reg', 'reg', 'shamt'),
	('1', 'jr {0}', 'reg_jump'),
	('0', 'ori {0}, {1}, {2}', 'reg', 'reg', 'imm'),
	('0', 'ori {0}, {1}, {2}', 'reg', 'reg', 'imm'),
	('0', 'ori {0}, {1}, {2}', 'reg', 'reg', 'imm'),
	('0', 'ori {0}, {1}, {2}', 'reg', 'reg', 'imm'),
	('0', 'ori {0}, {1}, {2}', 'reg', 'reg', 'imm'),
	('0', 'lui {0}, {1}', 'reg', 'imm'),
	('0', 'lui {0}, {1}', 'reg', 'imm'),
	('0', 'lui {0}, {1}', 'reg', 'imm'),
	('0', 'lui {0}, {1}', 'reg', 'imm'),
	('0', 'lw {0}, {1}($0)', 'reg', 'imm_w'),
	('0', 'lw {0}, {1}($0)', 'reg', 'imm_w'),
	('0', 'sw {0}, {1}($0)', 'reg', 'imm_w'),
	('0', 'sw {0}, {1}($0)', 'reg', 'imm_w'),
	('1', 'beq {0}, {1}, {2}', 'reg', 'reg', 'lable'),
	('1', 'jal {0}', 'lable'),
	('1', 'j {0}', 'lable')
]
# reg set
reg_set = ['$%d' %i for i in range(26)]
# lable_set
lable_set = ['N%d' %i for i in range(n)] + ['N%d' %n]
# random
rand_funct = {
	'reg' : lambda : choice(reg_set),
	'reg_jump': lambda: '$ra',
	'shamt' : lambda : randint(0, 2**5 - 1),
	'imm' :  lambda : randint(0, 2**16-1),
	'imm_w': lambda : randint(0, 2**10 - 1)*4,
	'lable': lambda : choice(lable_set) 
}
#main
k = 0 # whether the previous instruction is jump or branch
l = 0 # whether the jal has appeared
for i in range(n):
	j = choice(ins_set)
	while (k == 1 and j[0] == '1') or (l == 0 and j[1] == 'jr'): # after a jump or branch, shouldn't be a j or branch
		j = choice(ins_set) 	
	ins, arg = j[1], j[2:]
	ins = ins.format(*map(lambda x: rand_funct[x](), arg))
	print('%s: %s' %(lable_set[i], ins))
	if j[0] == '1':
		k = 1
	else:
		k = 0
print('N%d: nop' %n)
