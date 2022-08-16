 #include <Wire.h>


const int oPin=A0;


char thisChar;
int slave;
long tbreak;


void setup() {
  // put your setup code here, to run once:
  Wire.begin();
  Serial.begin(9600);
  Serial.println("Hangi Slave'i kullanmak istersiniz?(lütfen 7 yada 8 yazın)");
                                                                                                                                                                                         
}

void loop() {
  
  while(Serial.available()>0){
     
    slave=Serial.parseInt();
    
    Serial.print("mesaj yaz");
    while(Serial.available()==0){}
   while(Serial.available()>0){
    
   thisChar=Serial.read();
   
   if(slave==7){
    
   Wire.beginTransmission(7);
   Wire.write(thisChar);
   Wire.endTransmission(7);
   }
   if(slave==8){
    
   Wire.beginTransmission(8);
   Wire.write(thisChar);
   Wire.endTransmission(8);
   }
   
    }
    slave=Serial.read();
    slave=Serial.read();
   Serial.println("Hangi Slave'i kullanmak istersiniz?(lütfen 7 yada 8 yazın)");
  }
}



 
