/*
 Controlling a servo position using a potentiometer (variable resistor)
 by Michal Rinott <http://people.interaction-ivrea.it/m.rinott>

 modified on 8 Nov 2013
 by Scott Fitzgerald
 http://www.arduino.cc/en/Tutorial/Knob
*/

#include <Servo.h>

Servo myservo;  // create servo object to control a servo


long val;    // variable to read the value from the analog pin

void setup() {
  pinMode(9,OUTPUT);
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object
  Serial.begin(9600);
}

void loop() {
  while(Serial.available()>0){
  val=Serial.parseInt();;
  
  // reads the value of the potentiometer (value between 0 and 1023)
  myservo.write(val);                  // sets the servo position according to the scaled value
                           // waits for the servo to get there
}} 
