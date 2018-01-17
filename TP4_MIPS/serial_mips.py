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
reset = "reset.hex"

helpMessage =  """
Comandos disponibles:
Modo continuo: c
Modo paso a paso : s
Reprogramar FPGA: r
Desconectar FPGA: x
Mostrar comandos disponibles: h
"""

########################## funciones ##########################

def complemento_a_2(num, bits=32):
	if(num >= 1 << bits-1):
		return num - ( 1 << bits)
	else:
		return num

def read32():
	# leo primero el byte menos significativo
	reg_1 = ser.read()
	reg_2 = ser.read()
	reg_3 = ser.read()
	reg_4 = ser.read()

	result = concat_bin(reg_4, reg_3, reg_2, reg_1)
	return result

def concat_bin(byte_4, byte_3, byte_2, byte_1):

	return (ord(byte_4) << 24) + (ord(byte_3) << 16) + (ord(byte_2) << 8) + ord(byte_1)

def print_registro_32(mensaje, registro, msb = 31, lsb = 0):
	
	bitInicial = 31 - msb
	nroBits = (31 - lsb) + 1

	reg =  bin(registro).replace('0b','').zfill(32)[bitInicial:nroBits]

	binario = str(bin(int(reg,2)))
	decimal = str(complemento_a_2(int(reg,2)))
	hexa = str(hex(int(reg,2)))
	print mensaje.ljust(22) + binario.rjust(36) + decimal.rjust(14) + hexa.rjust(12)

def serialConnect(lim):

	port = '/dev/ttyUSB2'
	# port = 'COM14'
	ser = serial.Serial(port, baudrate = 9600)
	print "FPGA encontrada en puerto " + port
	return ser

def openFile(ser, file):
	try:
		f = open(file, 'r')
	except Exception as e:
		print "ERROR: Archivo no encontrado"
		ser.close()
		quit()

	lines = f.readlines()
	f.close()

	for line in lines:
		sendInstruction(line)

	return len(lines)

def sendInstruction(instruction):
	instruction = instruction.strip()	# quito whitespace
	instruction = (8-len(instruction)) * "0" + instruction #agrego ceros al principio si hacen falta
	instruction = instruction[::-1]

	for x in xrange(0, len(instruction), 2):
		ser.write(chr(int(instruction[x:x+2][::-1], 16)))

def showAllRegisters():
	print "---Contador de Programa---"
	pc = read32()
	print_registro_32("PC: ", pc)	
	print

	print "---Latches Intermedios IF/ID---"
	branch_1_2 = read32()
	instruccion = read32()

	print_registro_32("Instruccion: ", instruccion)
	print_registro_32("Branch target: ", branch_1_2)
	print

	print "---Latches Intermedios ID/EX---"

	branch_2_3 = read32()
	sign_extend_2_3 = read32()
	bus1_2_3 = read32()
	bus2_2_3 = read32()

	print_registro_32("Sign extend: ", sign_extend_2_3)
	print_registro_32("Branch target: ", branch_2_3)
	
	print_registro_32("Shamt: ", bus1_2_3, msb=4, lsb=0)
	print_registro_32("Rt: ", bus1_2_3, msb=9, lsb=5)
	print_registro_32("Rs: ", bus1_2_3, msb=14, lsb=10)
	print_registro_32("Rd: ", bus1_2_3, msb=19, lsb=15)
	print

		# print_registro_32("Rd: ", bus1_2_3)

	print "Buses de control"
	print_registro_32("Execute bus: ", bus2_2_3, msb=21, lsb=11)
	print_registro_32("Memory bus: ", bus2_2_3, msb=10, lsb=2)
	print_registro_32("Writeback bus: ", bus2_2_3, msb=1, lsb=0)
	print

	# print_registro_32("Execute bus: ", bus2_2_3)

	print "---Latches Intermedios EX/MEM---"

	reg2_3_4 = read32()
	branch_3_4 = read32()
	alu_out = read32()
	bus1_3_4 = read32()

	print_registro_32("ALU out: ", alu_out)
	print_registro_32("Branch target: ", branch_3_4)
	print_registro_32("Registro 2: ", reg2_3_4)

	print_registro_32("Zero flag: ", bus1_3_4, msb=0, lsb=0)
	print_registro_32("Write register: ", bus1_3_4, msb=5, lsb=1)
	print
	
	print "Buses de control"
	print_registro_32("Memory bus: ", bus1_3_4, msb=16, lsb=8)
	print_registro_32("Writeback bus: ", bus1_3_4, msb=7, lsb=6)
	print

	# print_registro_32("Writeback bus: ", bus1_3_4)

	print "---Latches Intermedios MEM/WB---"

	read_data = read32()
	alu_out_4_5 = read32()
	bus1_4_5 = read32()

	print_registro_32("Read data: ", read_data)
	print_registro_32("ALU out: ", alu_out_4_5)

	print_registro_32("Write register: ", bus1_4_5, msb=6, lsb=2)
	print

	print "Buses de control"
	print_registro_32("Writeback bus: ", bus1_4_5, msb=1, lsb=0)
	print

	print_registro_32("Halt Flag: ", bus1_4_5, msb=7, lsb=7)
	print

	# print_registro_32("Writeback bus: ", bus1_4_5)

	print "---Ciclos de clock empleados---"
	ciclos = read32()
	print_registro_32("Ciclos: ", ciclos)
	print

	print "---Registros del procesador---"
	for i in xrange(0,nro_registros):

		registro = read32()
		print_registro_32("Registro " + str(i) + ": ", registro)
	print


	print "---Posiciones de memoria---"
	for i in xrange(0,posiciones_memoria):

		memoria = read32()
		print_registro_32("Posicion " + str(i) + ": ", memoria)
	print

	return bus1_4_5 & (1 << 7)

def read_all():
	bus1_4_5 = 0

	for ii in range(0,15+posiciones_memoria+nro_registros):
		if ii == 13:
			bus1_4_5 = read32()
		else:
			read32()

	return bus1_4_5 & (1 << 7)



########################## main ##########################

if __name__ == '__main__':
	print """
	 ____                                    _              __  __ ___ ____  ____ 
	|  _ \ _ __ ___   ___ ___  ___  __ _  __| | ___  _ __  |  \/  |_ _|  _ \/ ___| 
	| |_) | '__/ _ \ / __/ _ \/ __|/ _` |/ _` |/ _ \| '__| | |\/| || || |_) \___ \ 
	|  __/| | | (_) | (_|  __/\__ \ (_| | (_| | (_) | |    | |  | || ||  __/ ___) |
	|_|   |_|  \___/ \___\___||___/\__,_|\__,_|\___/|_|    |_|  |_|___|_|   |____/ 
	"""

	print "\nIngenieria en Computacion 2017\nAutores:\n	Matthew Aguerreberry\n	Facundo Maero\n"

	raw_input("Presione una tecla para iniciar la carga del programa ensamblador por UART")

	ser = serialConnect(10)

	ret = ser.write(chr(StartSignal))

	print "Abriendo el archivo " + file

	instrucciones = openFile(ser, file)

	print "Envio del programa ensamblador finalizado"

	print helpMessage

	while True:

		try:
			modo = raw_input("Ingrese un comando...")
		except Exception as e:
			print "ERROR, entrada incorrecta"
			continue

		if modo == "c":
			print "Modo continuo seleccionado\nEl valor final en los registros y posiciones de memoria es:\n\n"
			ret = ser.write(chr(ContinuosSignal))
			showAllRegisters()

		elif modo == "s":
			print "Modo paso a paso seleccionado"
			print "Para ejecutar un ciclo de clock y ver el estado de los registros, ingrese s"
			print "Para salir del modo paso a paso, ingrese x"

			ret = ser.write(chr(StepByStepSignal))

			while True:
				command = raw_input('Step? (\'x\' para cancelar)')

				if command == "x":
					ret = ser.write(chr(StepSignal))
					while (not read_all()):
						ret = ser.write(chr(StepSignal))
					break
				else:
					ret = ser.write(chr(StepSignal))
					if(showAllRegisters()):
						print 'Ejecucion finalizada'
						break

		elif modo == "r":
			print "Reprogramando FPGA..."
			tecla = raw_input("Presione r para resetear registros y memoria de datos, \n o cualquier tecla para iniciar la carga del programa ensamblador por UART: ")
			ret = ser.write(chr(ReProgramSignal))
			ret = ser.write(chr(StartSignal))

			if(tecla == 'r'):
				print "Abriendo el archivo " + reset
				instrucciones = openFile(ser, reset)
				print "Envio del programa ensamblador finalizado"
			else:
				print "Abriendo el archivo " + file
				instrucciones = openFile(ser, file)
				print "Envio del programa ensamblador finalizado"

		elif modo == "x":
			print "Desconectando puerto serie y finalizando script..."
			ret = ser.write(chr(ReProgramSignal))
			break

		elif modo == "h":
			print helpMessage

		else:
			print "Comando no reconocido, intente nuevamente..."

	ser.close()
