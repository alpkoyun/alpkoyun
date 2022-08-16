 #include <Wire.h>


const int oPin=A0;
int p1=0;
int p2=0;
int p3=0;
int p4=0;
long t1=0;
char thisChar;
long tbreak;


void setup() {
  // put your setup code here, to run once:
  Wire.begin();
  Serial.begin(9600);
  
                                                                                                                                                                                         
}

void loop() {
  // put your main code here, to run repeatedly:
  p1=0;p2=0;p3=0;p4=0;
  
if(digitalRead(oPin)>0){
 mors();
 Harf_kontrol();
}
  }




  

void mors(){
  t1=millis();
  while(digitalRead(oPin)>0){
    }
  if((millis()-t1)>500){
    p1=2;
    
    }else{p1=1;}
     delay(5);
  tbreak=millis();
  while(digitalRead(oPin)<1){
   if((millis()-tbreak)>1000){
    return;
  }
   }
  


 delay(5);

  t1=millis();
   while(digitalRead(oPin)>0){
    
    }
  if((millis()-t1)>500){
    p2=2;
    
    } else{p2=1;}
 delay(5);
   tbreak=millis();
  while(digitalRead(oPin)<1){
    if((millis()-tbreak)>1000){
    return;
  }
   }
 


 delay(5);
t1=millis();
   while(digitalRead(oPin)>0){
    
    }
  if((millis()-t1)>500){
    p3=2;
    
    } else{p3=1;}
 delay(5);
   tbreak=millis();
  while(digitalRead(oPin)<1){

    if((millis()-tbreak)>1000){
    return;
  }
   }
  



 delay(5);
  t1=millis();
   while(digitalRead(oPin)>0){
    
    }
  if((millis()-t1)>500){
    p4=2;
    
    } else{p4=1;}
 delay(5);
   tbreak=millis();
  while(digitalRead(oPin)<1){
    if((millis()-tbreak)>1000){
    return;
  }
   }
  
  
  

  
}


void Harf_kontrol(){
Wire.beginTransmission(8);
  if(p1==1&&p2==2&&p3==0&&p4==0){
  Wire.write("A");
  }
  if(p1==2&&p2==1&&p3==1&&p4==1){
  Wire.write("B");
  }
  if(p1==2&&p2==1&&p3==2&&p4==1){
  Wire.write("C");
  }
  if(p1==2&&p2==1&&p3==1&&p4==0){
  Wire.write("D");
  }
  if(p1==1&&p2==0&&p3==0&&p4==0){
  Wire.write("E");
  Serial.write("burda");
  }
  if(p1==1&&p2==1&&p3==2&&p4==1){
  Wire.write("F");
  }
  if(p1==2&&p2==2&&p3==1&&p4==0){
  Wire.write("G");
  }
  if(p1==1&&p2==1&&p3==1&&p4==1){
  Wire.write("H");
  }
  if(p1==1&&p2==1&&p3==0&&p4==0){
  Wire.write("I");
  }
  if(p1==1&&p2==2&&p3==2&&p4==2){
  Wire.write("J");
  }
  if(p1==2&&p2==1&&p3==2&&p4==0){
  Wire.write("K");
  }
  if(p1==1&&p2==2&&p3==1&&p4==1){
  Wire.write("L");
  }
  if(p1==2&&p2==2&&p3==0&&p4==0){
  Wire.write("M");
  }
  if(p1==2&&p2==1&&p3==0&&p4==0){
  Wire.write("N");
  }
  if(p1==2&&p2==2&&p3==2&&p4==0){
  Wire.write("O");
  }
  if(p1==1&&p2==2&&p3==2&&p4==1){
  Wire.write("P");
  }
  if(p1==2&&p2==2&&p3==1&&p4==2){
  Wire.write("Q");
  }
  if(p1==1&&p2==2&&p3==1&&p4==0){
  Wire.write("R");
  }
  if(p1==1&&p2==1&&p3==1&&p4==0){
  Wire.write("S");
  }
  if(p1==2&&p2==0&&p3==0&&p4==0){
  Wire.write("T");
  }
  if(p1==1&&p2==1&&p3==2&&p4==0){
  Wire.write("U");
  }
  if(p1==1&&p2==1&&p3==1&&p4==2){
  Wire.write("V");
  }
  if(p1==1&&p2==2&&p3==2&&p4==0){
  Wire.write("W");
  }
  if(p1==2&&p2==1&&p3==1&&p4==2){
  Wire.write("X");
  }
  if(p1==2&&p2==1&&p3==2&&p4==2){
  Wire.write("Y");
  }
  if(p1==2&&p2==2&&p3==1&&p4==1){
  Wire.write("Z");
  }
  
  Wire.endTransmission();
}
