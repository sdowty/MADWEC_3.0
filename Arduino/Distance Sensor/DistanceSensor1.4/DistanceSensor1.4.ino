// This uses Serial Monitor to display Range Finder distance readings

// Include NewPing Library
#include <Wire.h>
#include <NewPing.h>

#define echoPin 10 //change pin to the number you want
#define trigPin 9 // change pin to the number you want
const int buttonPin = 2;  //D2 for Push botton 
const int LEDred =  4;
const int LEDgreen = 5; 
// Maximum distance we want to ping for (in centimeters).
#define MAX_DISTANCE 400  

// NewPing setup of pins and maximum distance.
NewPing sonar(trigPin, echoPin, MAX_DISTANCE);

// creating variables 
long duration;
long distance;
int voltRead; 
float voltage; 
float attx; 
float converge;
//float distConv;
int buttonState = 0; // trigger for push button 

void setup() 
{
  Serial.begin(115200);
  pinMode(buttonPin, INPUT); 
  pinMode(LEDred, OUTPUT);
  pinMode(LEDgreen,OUTPUT);
}

void loop() 
{
  // Send ping, get distance in cm
  int iterations = 5; 
  duration = sonar.ping_median(iterations);

  distance = (duration/2) *(0.0343); 
 // float distConv = (float)distance;
  //Send the distance in 1 byte (actually sends for example 156, not '1' '5' and '6')
  Serial.write(distance);
  /*
  Serial.print(":");
      voltRead = analogRead(A3);      // read the input on analog pin 3:
      
      // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
      converge = voltRead * (5.0/1023.0);
      attx = 11;
      voltage = voltRead;
      Serial.print(voltage);
      Serial.print(":"); 
      */
/*
  //Serial.println(voltage);
  // check button states 
  buttonState = digitalRead(buttonPin);
  
  if(buttonState == HIGH)
  {
   // Serial.write(distance); 
    Serial.write(distance);
    Serial.println("999"); 
    digitalWrite(LEDred,LOW);
    digitalWrite(LEDgreen,HIGH); 
  }
  else
  {
    Serial.write(distance); //  send last value recorded 
    digitalWrite(LEDred,HIGH);
    digitalWrite(LEDgreen,LOW); 
    
  }
  */
  delay(50);

  
}
