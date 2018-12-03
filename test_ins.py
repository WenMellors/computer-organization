from random import randint, choice
# how many line to print
n = 100
# instruction set
ins_set = [
	('addu {0}, {1}, {2}', 'reg', 'reg', 'reg'),
	('subu {0}, {1}, {2}', 'reg', 'reg', 'reg'),
	('sll {0}, {1}, {2}', 'reg', 'reg', 'shamt'),
	('jr {0}', 'reg'),
	('ori {0}, {1}, {2}', 'reg', 'reg', 'imm'),
	('lui {0}, {1}', 'reg', 'imm'),
	('lw {0}, {1}($0)', 'reg', 'imm_w'),
	('sw {0}, {1}($0)', 'reg', 'imm_w'),
	('beq {0}, {1}, {2}', 'reg', 'reg', 'lable'),
	('jal {0}', 'lable'),
	('j {0}', 'lable')
]
# reg set
reg_set = ['$%d' %i for i in range(31)]
# lable_set
lable_set = ['N%d' %i for i in range(n)] + ['N%d' %n]
# random
rand_funct = {
	'reg' : lambda : choice(reg_set),
	'shamt' : lambda : randint(0, 2**5 - 1),
	'imm' :  lambda : randint(0, 2**16-1),
	'imm_w': lambda : randint(0, 2**10 - 1)*4,
	'lable': lambda : choice(lable_set) 
}
#main
for i in range(n):
	j = choice(ins_set)
	ins, arg = j[0], j[1:]
	ins = ins.format(*map(lambda x: rand_funct[x](), arg))
	print('%s: %s' %(lable_set[i], ins))
print('N%d: nop' %n)
