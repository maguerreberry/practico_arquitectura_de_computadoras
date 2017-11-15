import serial

while True:
	ser = serial.Serial('COM6')
	
	x = ser.read()         
	print "baja pc =", bin(ord(x))

	x = ser.read()         
	print "alta pc =", bin(ord(x))

	x = ser.read()         
	print "baja acc =", bin(ord(x))

	x = ser.read()         
	print "alta acc =", bin(ord(x))

	ser.close()