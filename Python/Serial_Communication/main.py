from time import sleep
import serial
import ctypes,time
import sounddevice as sd
import wave
import numpy

serialPort = serial.Serial(port = "COM3", baudrate=9600,bytesize=8, timeout=2, stopbits=serial.STOPBITS_ONE)
user32 = ctypes.windll.user32
st1=''

while(1):   
# Wait until there is data waiting in the serial buffer
    if(serialPort.in_waiting > 0):
       
        # Read data out of the buffer untl a carraige return / new line is found
        st = int(serialPort.readline().decode('ascii'))
        if(185>st>145):
            print(st)
            user32.keybd_event(0x12, 0, 0, 0) #Alt
            sleep(0.1)
            user32.keybd_event(0x09, 0, 0, 0) #Tab
            sleep(0.1)
            user32.keybd_event(0x09, 0, 2, 0) #~Tab
            sleep(0.1)
            user32.keybd_event(0x12, 0, 2, 0) #~Alt
            
            ifile = wave.open("Kayıt.wav")
            samples = ifile.getnframes()
            audio = ifile.readframes(samples)

            # Convert buffer to float32 using NumPy                                                                                 
            audio_as_np_int16 = numpy.frombuffer(audio, dtype=numpy.int16)
            audio_as_np_float32 = audio_as_np_int16.astype(numpy.float32)

            # Normalise float32 array so that values are between -1.0 and +1.0                                                      
            max_int16 = 2**15
            audio_normalised = audio_as_np_float32 / max_int16
            sd.default.device = 'Hoparlör (Realtek(R) Audio), MME'
            sd.play(audio_normalised,48000)
            sd.wait()
            break






# See PyCharm help at https://www.jetbrains.com/help/pycharm/

