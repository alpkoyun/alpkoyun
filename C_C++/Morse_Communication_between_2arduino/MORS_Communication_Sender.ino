
const int oPin=A0;
int p1=0;
int p2=0;
int p3=0;
int p4=0;
long t1=0;
char thisChar;
boolean wrt=false;
long tbreak;


void setup() {
  // put your setup code here, to run once:
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
  if(p1==1&&p2==2&&p3==0&&p4==0){
  Serial.print("A");
  }
  if(p1==2&&p2==1&&p3==1&&p4==1){
  Serial.print("B");
  }
  if(p1==2&&p2==1&&p3==2&&p4==1){
  Serial.print("C");
  }
  if(p1==2&&p2==1&&p3==1&&p4==0){
  Serial.print("D");
  }
  if(p1==1&&p2==0&&p3==0&&p4==0){
  Serial.print("E");
  }
  if(p1==1&&p2==1&&p3==2&&p4==1){
  Serial.print("F");
  }
  if(p1==2&&p2==2&&p3==1&&p4==0){
  Serial.print("G");
  }
  if(p1==1&&p2==1&&p3==1&&p4==1){
  Serial.print("H");
  }
  if(p1==1&&p2==1&&p3==0&&p4==0){
  Serial.print("I");
  }
  if(p1==1&&p2==2&&p3==2&&p4==2){
  Serial.print("J");
  }
  if(p1==2&&p2==1&&p3==2&&p4==0){
  Serial.print("K");
  }
  if(p1==1&&p2==2&&p3==1&&p4==1){
  Serial.print("L");
  }
  if(p1==2&&p2==2&&p3==0&&p4==0){
  Serial.print("M");
  }
  if(p1==2&&p2==1&&p3==0&&p4==0){
  Serial.print("N");
  }
  if(p1==2&&p2==2&&p3==2&&p4==0){
  Serial.print("O");
  }
  if(p1==1&&p2==2&&p3==2&&p4==1){
  Serial.print("P");
  }
  if(p1==2&&p2==2&&p3==1&&p4==2){
  Serial.print("Q");
  }
  if(p1==1&&p2==2&&p3==1&&p4==0){
  Serial.print("R");
  }
  if(p1==1&&p2==1&&p3==1&&p4==0){
  Serial.print("S");
  }
  if(p1==2&&p2==0&&p3==0&&p4==0){
  Serial.print("T");
  }
  if(p1==1&&p2==1&&p3==2&&p4==0){
  Serial.print("U");
  }
  if(p1==1&&p2==1&&p3==1&&p4==2){
  Serial.print("V");
  }
  if(p1==1&&p2==2&&p3==2&&p4==0){
  Serial.print("W");
  }
  if(p1==2&&p2==1&&p3==1&&p4==2){
  Serial.print("X");
  }
  if(p1==2&&p2==1&&p3==2&&p4==2){
  Serial.print("Y");
  }
  if(p1==2&&p2==2&&p3==1&&p4==1){
  Serial.print("Z");
  }
  
  
  
  
  }
