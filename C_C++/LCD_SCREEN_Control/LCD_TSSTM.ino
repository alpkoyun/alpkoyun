#define RST 12
#define CE 11
#define DC 10
#define DIN 9 
#define CLK 8
void setup() {
  
  Serial.begin(9600);
 pinMode(RST,OUTPUT);
  pinMode(CE,OUTPUT);
  pinMode(DC,OUTPUT);
  pinMode(DIN,OUTPUT);
  pinMode(CLK,OUTPUT);
  digitalWrite(RST,LOW);
  digitalWrite(RST,HIGH);
  LcdWriteCmd(0x21);
  LcdWriteCmd(0xAD);
  LcdWriteCmd(0x04);
  LcdWriteCmd(0x14);
  LcdWriteCmd(0x20);
  LcdWriteCmd(0x0C);                           
  
   cerceve();
  LcdWriteCmd(0x40);
  LcdWriteCmd(0x83);
  
  LcdWriteData(0xf0);
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0);   
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteCmd(0x41);
  LcdWriteCmd(0x88);
  LcdWriteData(0xff);
  LcdWriteData(0xff);
  LcdWriteData(0xff);
  LcdWriteData(0xff);
  LcdWriteData(0xff);

  
  LcdWriteCmd(0x40);
  LcdWriteCmd(0x95);
  LcdWriteData(0xf0);
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0x30);
  LcdWriteData(0x30);
  LcdWriteData(0x30);
  LcdWriteData(0x30);
  LcdWriteData(0x30);
  LcdWriteData(0x30);
  LcdWriteData(0x30);
  LcdWriteData(0x30);
  LcdWriteCmd(0x41);
  LcdWriteCmd(0x95);
  LcdWriteData(0xC7);
  LcdWriteData(0xC7);
  LcdWriteData(0xC7);
  LcdWriteData(0xC6);
  LcdWriteData(0xC6);
  LcdWriteData(0xC6);
  LcdWriteData(0xC6);
  LcdWriteData(0xC6);
  LcdWriteData(0xfe);
  LcdWriteData(0xfe);
  LcdWriteData(0xfe);

   LcdWriteCmd(0x40);
  LcdWriteCmd(0xA3);
  LcdWriteData(0xf0);
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0x30);
  LcdWriteData(0x30);
  LcdWriteData(0x30);
  LcdWriteData(0x30);
  LcdWriteData(0x30);
  LcdWriteData(0x30);
  LcdWriteData(0x30);
  LcdWriteData(0x30);
  LcdWriteCmd(0x41);
  LcdWriteCmd(0xA3);
  LcdWriteData(0xC7);
  LcdWriteData(0xC7);
  LcdWriteData(0xC7);
  LcdWriteData(0xC6);
  LcdWriteData(0xC6);
  LcdWriteData(0xC6);
  LcdWriteData(0xC6);
  LcdWriteData(0xC6);
  LcdWriteData(0xfe);
  LcdWriteData(0xfe);
  LcdWriteData(0xfe);
  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  LcdWriteCmd(0x40);
  LcdWriteCmd(0xB1);
  LcdWriteData(0xf0);
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0);   
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteData(0xf0); 
  LcdWriteCmd(0x41);
  LcdWriteCmd(0xB6);
  LcdWriteData(0xff);
  LcdWriteData(0xff);
  LcdWriteData(0xff);
  LcdWriteData(0xff);
  LcdWriteData(0xff);

 
LcdWriteCmd(0x40);
  LcdWriteCmd(0xc1);
  LcdWriteData(0xf0);
  LcdWriteData(0xf0);
  LcdWriteData(0xf0);
  
  LcdWriteData(0x60);
  LcdWriteData(0x60);
  LcdWriteData(0x80);
  LcdWriteData(0x80);
   LcdWriteData(0x00);
    LcdWriteData(0x00);
  LcdWriteData(0x80);
  LcdWriteData(0x80);
  
  LcdWriteData(0x60);
  LcdWriteData(0x60);

  LcdWriteData(0xf0);
  LcdWriteData(0xf0);
  LcdWriteData(0xf0);



  LcdWriteCmd(0x41);
  LcdWriteCmd(0xc1);
  LcdWriteData(0xff);
  LcdWriteData(0xff);
  LcdWriteData(0xff);
  LcdWriteData(0x00);
  LcdWriteData(0x00);
  LcdWriteData(0x01);
  LcdWriteData(0x01);
  LcdWriteData(0x06);
  LcdWriteData(0x06);

 LcdWriteData(0x01);
  LcdWriteData(0x01);
  LcdWriteData(0x00);
  LcdWriteData(0x00);
  LcdWriteData(0xff);
  LcdWriteData(0xff);
  LcdWriteData(0xff);
  
}

void loop() {
  
      
   
}


void LcdWriteCmd(byte cmd){
  digitalWrite(DC,LOW);
  digitalWrite(CE,LOW);
  shiftOut(DIN,CLK,MSBFIRST,cmd);
  digitalWrite(CE,HIGH);
  
  }
  void LcdWriteData(byte bilg){
  digitalWrite(DC,HIGH);
  digitalWrite(CE,LOW);
  shiftOut(DIN,CLK,MSBFIRST, bilg);
  digitalWrite(CE,HIGH);
  
  
  }

  void cerceve(){                                                            
    LcdWriteCmd(0x80);
    LcdWriteCmd(0x40);
    for(int i=0;i<504;i++){
    if((i%84)==0||(i%84)==83)LcdWriteData(0xff);
    else if(i<84)LcdWriteData(0x01);
    else if(i>420)LcdWriteData(0x80);
    else{LcdWriteData(0x00);}
   } 
  
  
    
  }
  
