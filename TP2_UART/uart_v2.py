def getOperando():

    while True:
        # python 3
        a = input("Ingrese el operando: ")
        # python 2
        # a = raw_input("Ingrese el operando: ")

        try:
            if int(a) > 127 or int(a) < -128:
                print("Error, \"{}\" es un valor fuera de rango".format(a))
                
            else:
                # print("Operando: {}".format(bin(int(a))))
                return bin(int(a))

        except:
            print ("Error, \"{}\" no es un valor válido".format(a))

def getOperador():

    codigos = {
        '+' : 0b100000,
        '-' : 0b100010,
        '&' : 0b100100,
        '|' : 0b100101,
        '^' : 0b100110,
        '}' : 0b000011,
        ']' : 0b000010,
        '~' : 0b100111
    }
    
    
    while True:
        # python 3
        a = input("Ingrese el operador: ")
        # python 2
        # a = raw_input("Ingrese el operador: ")

        if(a in codigos):
            # print(bin(codigos[a]))
            return bin(codigos[a])
        else:
            print("Operando incorrecto, los valores posibles son:")
            print(" ADD : + \n "
                  " SUB : - \n "
                  " AND : & \n "
                  " OR  : | \n "
                  " XOR : ^ \n "
                  " SRA : } \n "
                  " SRL : ] \n "
                  " NOR : ~"
            )



import serial

ser = serial.Serial('COM4')

print (ser.name)

a = getOperando()
b = getOperando()
op = getOperador()

print(" a = {} \n b = {} \n op = {}".format(a,b,op))

sent = ser.write(chr(a))
sent = ser.write(chr(b))
sent = ser.write(chr(op))

x = ser.read()         

print ("Resultado = ", bin(ord(x)))

ser.close()