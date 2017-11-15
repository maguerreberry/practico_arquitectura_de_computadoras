import serial

ser = serial.Serial('COM6')

print ser.name

while True:
# a = 0b01110000
# sent = ser.write(chr(a))
# print "a =", bin(a)

# b = 0b1
# sent = ser.write(chr(b))
# print "b =", bin(b)

# op = 0b100000
# sent = ser.write(chr(op))
# print "op =", bin(op)

	x = ser.read()         
	print "baja pc =", bin(ord(x))

	x = ser.read()         
	print "alta pc =", bin(ord(x))

	x = ser.read()         
	print "baja acc =", bin(ord(x))

	x = ser.read()         
	print "alta acc =", bin(ord(x))

ser.close()