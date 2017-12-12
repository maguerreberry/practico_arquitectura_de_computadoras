op_code = 0b100011 #6bits
rs = 0b00001
rt = 0b00101
rd = 0b10001
shamt = 0b00011
funct = 0b100110
inmediato = 0b0000000000000100 # CCC
direccion = 0b10000110000100001000000000 # AAA

# instruction = (op_code << 26) + (rs << 21) + (rt << 16) + (rd << 11) + (shamt << 6) + funct
instruction = (op_code << 26) + (rs << 21) + (rt << 16) + inmediato
# instruction = (op_code << 26) + direccion


# print bin(instruction)
# print bin(op_code)

print "bin: " + "{0:032b}".format(instruction)
print "hex: " + format(instruction, '08x')