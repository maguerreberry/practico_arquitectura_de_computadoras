import serial

def concat_bin(msb,lsb):
	return msb * pow(2,8) + lsb

# con switch

ser = serial.Serial('COM6')

pc_1 = ser.read()
pc_2 = ser.read()
acc_1 = ser.read()
acc_2 = ser.read()

ser.close()

pc = concat_bin(pow_2, pow_1)
acc = concat_bin(acc_2, acc_1)

print "Ciclos de clock empleados: ", bin(ord(pc))
print "Valor del acumulador: ", bin(ord(acc))


# con teclado
# while True:
# 	raw_input("Presione una tecla para iniciar")

# 	ser = serial.Serial('COM6')
	
# 	a = 0b01010101
# 	sent = ser.write(chr(a))
	
# 	raw_input("Presione una tecla para iniciar")
# 	a = 0b00000000
# 	sent = ser.write(chr(a))

# 	print "ACK"

# 	x = ser.read()         
# 	print "baja pc =", bin(ord(x))

# 	x = ser.read()         
# 	print "alta pc =", bin(ord(x))

# 	x = ser.read()         
# 	print "baja acc =", bin(ord(x))

# 	x = ser.read()         
# 	print "alta acc =", bin(ord(x))

# 	ser.close()
