// This uses Serial Monitor to display Range Finder distance readings

// Include NewPing Library
#include <Wire.h>
#include <NewPing.h>

#define echoPin 13 //change pin to the number you want
#define trigPin 12 // change pin to the number you want
#define stopPin 2  //D2 for Push botton 
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

int stopFlag = 0; // trigger for push button 

void setup() 
{
  Serial.begin(115200);
  pinMode(stopPin, INPUT); 
}

void loop() 
{
  // Send ping, get distance in cm
  int iterations = 5; 
  duration = sonar.ping_median(iterations);

  distance = (duration/2) *(0.0343); 
  
  //Send the distance in 1 byte (actually sends for example 156, not '1' '5' and '6')
  //Serial.write(distance);
  
      voltRead = analogRead(A3);      // read the input on analog pin 3:
      
      // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
      attx = 11 * (5.0/1023.0);
      voltage = voltRead * attx; 


  //Serial.println(voltage);
  // check button (stopPin) condition 
  stopFlag = digitalRead(stopPin);
  if(stopFlag == LOW)
  {
    Serial.write(distance); 
  }
  else
  {
   Serial.write(distance); //  send last value recorded 
    Serial.println("999"); 
  }
  delay(50);

  
}
