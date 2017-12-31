import serial

# flags
b = True
d = True
h = True

nro_registros = 32
posiciones_memoria = 16

# codigos a enviar por UART
StartSignal        = 0b00000001
ContinuosSignal    = 0b00000010
StepByStepSignal   = 0b00000011
ReProgramSignal    = 0b00000101
StepSignal         = 0b00000110

# file = "practico_arquitectura_de_computadoras/TP4_MIPS/program.hex"
file = "program.hex"

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

def sendInstruction(instruction):
	for x in xrange(0,8,2):
		print instruction[x:x+2]
		# sent = ser.write(instruction[x:x+2])

print """
 ____                                    _              __  __ ___ ____  ____ 
|  _ \ _ __ ___   ___ ___  ___  __ _  __| | ___  _ __  |  \/  |_ _|  _ \/ ___| 
| |_) | '__/ _ \ / __/ _ \/ __|/ _` |/ _` |/ _ \| '__| | |\/| || || |_) \___ \ 
|  __/| | | (_) | (_|  __/\__ \ (_| | (_| | (_) | |    | |  | || ||  __/ ___) |
|_|   |_|  \___/ \___\___||___/\__,_|\__,_|\___/|_|    |_|  |_|___|_|   |____/ 
"""

print "\nIngenieria en Computacion 2017\nAutores:\n	Matthew Aguerreberry\n	Facundo Maero\n"

raw_input("Presione una tecla para iniciar la carga del programa ensamblador por UART")

# com = 0

# for i in xrange(1,10):
# 	try:
# 		puerto = 'COM' + str(i)
# 		ser = serial.Serial(puerto)
# 		com = i
# 		break
# 	except Exception as e:
# 		pass
# 		if i == 9:
# 			print "No puedo encontrar la FPGA"
# 			quit()

# print "FPGA encontrada en puerto COM" + com

# ret = ser.write(StartSignal)

print "Abriendo el archivo " + file

try:
	f = open(file, 'r')
except Exception as e:
	print "ERROR: Archivo no encontrado"
	quit()

while True:
    line = f.readline()[:8] 	# trunco el \n, leyendo solo los 8 hexas del opcode
    if not line: break
    sendInstruction(line)

print "Envio del programa ensamblador finalizado"

print """
Seleccione el modo de debug\n
Continuo: 1
Paso a paso : 2
""",

while True:

	try:
		modo = int(raw_input())
	except Exception as e:
		print "ERROR, entrada incorrecta"
		continue

	if modo == 1:
		# modo continuo

		print "Contador de Programa"
		pc = read_32()
		print_registro_32("PC: ", pc)	

		print "Latches Intermedios IF/ID"
		branch_1_2 = read32()
		pc_out_1_2 = read32()

		print_registro_32("PC siguiente: ", pc_out_1_2)
		print_registro_32("Branch target: ", branch_1_2)

		print "Latches Intermedios ID/EX"

		branch_2_3 = read32()
		sign_extend_2_3 = read32()
		bus1_2_3 = read32()
		bus2_2_3 = read32()

		print_registro_32("Sign extend: ", sign_extend_2_3)
		print_registro_32("Branch target: ", branch_2_3)
		
		print_registro_32("Shamt: ", bus1_2_3[27:])
		print_registro_32("Rt: ", bus1_2_3[22:27])
		print_registro_32("Rs: ", bus1_2_3[17:22])
		print_registro_32("Rd: ", bus1_2_3[12:17])

		print "Buses de control"
		print_registro_32("Execute bus: ", bus2_2_3[10:21])
		print_registro_32("Memory bus: ", bus2_2_3[21:30])
		print_registro_32("Writeback bus: ", bus2_2_3[30:])

		print "Latches Intermedios EX/MEM"

		reg2_3_4 = read32()
		branch_3_4 = read32()
		alu_out = read32()
		bus1_3_4 = read32()

		print_registro_32("ALU out: ", alu_out)
		print_registro_32("Branch target: ", branch_3_4)
		print_registro_32("Registro 2: ", reg2_3_4)

		print_registro_32("Zero flag: ", bus1_3_4[31])
		print_registro_32("Write register: ", bus1_3_4[26:31])
		
		print "Buses de control"
		print_registro_32("Memory bus: ", bus1_3_4[15:24])
		print_registro_32("Writeback bus: ", bus1_3_4[24:26])

		print "Latches Intermedios MEM/WB"

		read_data = read32()
		alu_out_4_5 = read32()
		bus1_4_5 = read32()

		print_registro_32("Read data: ", read_data)
		print_registro_32("ALU out: ", alu_out_4_5)

		print_registro_32("Write register: ", bus1_4_5[25:30])

		print "Buses de control"
		print_registro_32("Writeback bus: ", bus1_4_5[30:])

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


ser.close()