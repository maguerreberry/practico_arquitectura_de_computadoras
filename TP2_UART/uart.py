import serial

ser = serial.Serial('COM4')

print ser.name

a = 0b10000000
sent = ser.write(chr(a))
print "a =", bin(a)

b = 0b1
sent = ser.write(chr(b))
print "b =", bin(b)

op = 0b11
sent = ser.write(chr(op))
print "op =", bin(op)

x = ser.read()         

print "result =", bin(ord(x))

ser.close()