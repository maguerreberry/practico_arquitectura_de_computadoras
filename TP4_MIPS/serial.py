# Control: limpiar etapas 1, 2 y 3 si branch taken (miss)
# halt: pc = pc (nuevo opcode)
# script leer:
# 			32 Registros
# 			pc
# 			memoria de datos usada (16 registros?)
# 			latches intermedios (solo para modo debug?)


import serial

# flags
b = True
d = True
h = True

nro_registros = 32
posiciones_memoria = 16

def concat_bin(byte_4, byte_3, byte_2, byte_1):
	return (ord(byte_4) << 24) + (ord(byte_3) << 16) + (ord(byte_2) << 8) + ord(byte_1)

def read_32()
	# leo primero el byte menos significativo
	reg_1 = ser.read() 
	reg_2 = ser.read()
	reg_3 = ser.read()
	reg_4 = ser.read()

	result = concat_bin(reg_4, reg_3, reg_2, reg_1)
	return result

def print_registro_32(mensaje, registro):
	print mensaje,

	if b:
		print bin(registro),
	if d:
		print int(registro),
	if h:
		print hex(registro),

	print # para el newline


ser = serial.Serial('COM4')

print "Registros del procesador"
for i in xrange(0,nro_registros):

	registro = read_32()
	print_registro_32("Registro " + str(i) + ": ", registro)

print "Contador de Programa"
	pc = read_32()
	print_registro_32("PC: ", registro)	

print "Posiciones de memoria"
for i in xrange(0,posiciones_memoria):

	memoria = read_32()
	print_registro_32("Posicion " + str(i) + ": ", memoria)




ser.close()



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
