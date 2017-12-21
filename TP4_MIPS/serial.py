import serial

# flags
b = True
d = True
h = True

nro_registros = 32
posiciones_memoria = 16

file = "practico_arquitectura_de_computadoras/TP4_MIPS/program.hex"

def concat_bin(byte_4, byte_3, byte_2, byte_1):
	
	return (ord(byte_4) << 24) + (ord(byte_3) << 16) + (ord(byte_2) << 8) + ord(byte_1)

def read_32():
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

print """
 ____                                    _              __  __ ___ ____  ____ 
|  _ \ _ __ ___   ___ ___  ___  __ _  __| | ___  _ __  |  \/  |_ _|  _ \/ ___| 
| |_) | '__/ _ \ / __/ _ \/ __|/ _` |/ _` |/ _ \| '__| | |\/| || || |_) \___ \ 
|  __/| | | (_) | (_|  __/\__ \ (_| | (_| | (_) | |    | |  | || ||  __/ ___) |
|_|   |_|  \___/ \___\___||___/\__,_|\__,_|\___/|_|    |_|  |_|___|_|   |____/ 
"""

print "\nIngenieria en Computacion 2017\nAutores:\n	Matthew Aguerreberry\n	Facundo Maero\n"

raw_input("Presione una tecla para iniciar la carga del programa ensamblador por UART")

com = 0

for i in xrange(1,10):
	try:
		puerto = 'COM' + str(i)
		ser = serial.Serial(puerto)
		com = i
		break
	except Exception as e:
		if i == 9:
			print "No puedo encontrar la FPGA"
			quit()

print "FPGA encontrada en puerto COM" + com

################################################################################
# envio palabra inicio de programacion
################################################################################

print "Abriendo el archivo " + file

try:
	f = open(file, 'r')
except Exception as e:
	print "ERROR: Archivo no encontrado"
	quit()

while True:
    line = f.readline()[:8] 	# trunco el \n, leyendo solo los 8 hexas del opcode
    if not line: break
    print line
    sent = ser.write(line)

print "Envio del programa ensamblador finalizado"

print """
Seleccione el modo de debug\n
Continuo: 1
Paso a paso : 2
""",

modo = int(raw_input())

if modo == 1:
	# modo continuo

	print "Contador de Programa"
	pc = read_32()
	print_registro_32("PC: ", pc)	

	print "Ciclos de clock empleados"
	ciclos = read_32()
	print_registro_32("Ciclos: ", ciclos)

	print "Registros del procesador"
	for i in xrange(0,nro_registros):

		registro = read_32()
		print_registro_32("Registro " + str(i) + ": ", registro)


	print "Posiciones de memoria"
	for i in xrange(0,posiciones_memoria):

		memoria = read_32()
		print_registro_32("Posicion " + str(i) + ": ", memoria)

elif modo == 2:
	# modo paso a paso
	pass
	# TO DO

else:
	# entrada incorrecta
	print "ERROR, entrada incorrecta"



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
