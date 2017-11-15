import serial

while True:

	raw_input("Presione cualquier tecla para reiniciar...")

	ser = serial.Serial('COM6')

	a = 0b01010101
	sent = ser.write(chr(a))
	print "Señal de inicio enviada"

	x = ser.read()         
	print "baja pc =", bin(ord(x))

	x = ser.read()         
	print "alta pc =", bin(ord(x))

	x = ser.read()         
	print "baja acc =", bin(ord(x))

	x = ser.read()         
	print "alta acc =", bin(ord(x))

	ser.close()