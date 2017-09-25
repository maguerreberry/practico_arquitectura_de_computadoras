import serial

ser = serial.Serial('COM4')

print ser.name
sent = ser.write('8')
print bin(ord('8'))
print sent

sent = ser.write('9')
print bin(ord('9'))
print sent

sent = ser.write('$')
print bin(ord('$'))
print sent

x = ser.read()          # read one byte

print bin(ord(x))

ser.close()