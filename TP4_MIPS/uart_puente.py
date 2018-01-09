import serial

if __name__ == '__main__':
	ser = serial.Serial('COM14', baudrate = 9600)

	# while True:
	if True:
		# user_data = raw_input('enviar: ')
		user_data = ''
		if user_data == 'exit':
			ser.close()
			exit()
		print user_data
		ser.write( chr(0b00000010))

		print 'respuesta: ',  ord(ser.read())