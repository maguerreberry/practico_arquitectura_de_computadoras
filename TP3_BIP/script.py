import serial

while True:
	raw_input("Presione una tecla para iniciar")

	ser = serial.Serial('COM6')
	
	a = 0b01010101
	sent = ser.write(chr(a))
	
	raw_input("Presione una tecla para iniciar")
	a = 0b00000000
	sent = ser.write(chr(a))


	print "ACK"

	x = ser.read()         
	print "baja pc =", bin(ord(x))

	x = ser.read()         
	print "alta pc =", bin(ord(x))

	x = ser.read()         
	print "baja acc =", bin(ord(x))

	x = ser.read()         
	print "alta acc =", bin(ord(x))

	ser.close()