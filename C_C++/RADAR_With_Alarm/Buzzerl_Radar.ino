/*
 Controlling a servo position using a potentiometer (variable resistor)
 by Michal Rinott <http://people.interaction-ivrea.it/m.rinott>

 modified on 8 Nov 2013
 by Scott Fitzgerald
 http://www.arduino.cc/en/Tutorial/Knob
*/


#include <Servo.h>

Servo myservo;
long duration;
int distance;
int trigp=5;
int echop=7;// create servo object to control a servo

int val=0;
int i=10;// variable to read the value from the analog pin
long t;
void setup() {
  pinMode(trigp,OUTPUT);
  pinMode(echop,INPUT);
  pinMode(9,OUTPUT);
  
  digitalWrite(trigp,LOW);
 
  Serial.begin(9600);
 
  myservo.attach(9);  
}

void loop() {
 t=millis();
  
  val = val+i;
  myservo.write(val);                  
  dist();
  Serial.println(distance*3);
  Serial.println(val);  
                                                                                                                                                                              
  if(val==180)i=-10;
  if(val==0)i=10 ;
  // waits for the servo to get there
  duration=duration/1000;
  if(distance<20){analogWrite(11,100);}
  else{analogWrite(11,0);}  
  delay(200-duration);
  
 
}                                                                           

void dist(){
  digitalWrite(trigp,LOW);
  delayMicroseconds(2);
  digitalWrite(trigp,HIGH);
  delayMicroseconds(10);
  digitalWrite(trigp,LOW);
  duration=pulseIn(echop,HIGH);
  distance=duration*0.034;
  
  
  
  
}
