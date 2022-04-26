#include <Wire.h>

#ifdef ARDUINO_SAMD_VARIANT_COMPLIANCE
  #define RefVal 3.3
  #define SERIAL SerialUSB
  
#else
  #define RefVal 5.0
  #define SERIAL Serial
#endif
//An OLED Display is required here
//use pin A0
#define Pin A1
 
// Take the average of 500 times
int averageValue = 150;
long convFLcurrent;
float convLFcurrent;
long  sensorValue = 0;
float sensitivity = 1000.0 / 264.0; //1000mA per 264mV 

//Vref is zero drift value, you need to change this value to the value you actually measured before using it.
float Vref = 322.27; //mV   // 322.27  //319.825  //317.38 



void setup() 
{
  Serial.begin(9600);
}
 
void loop() 
{
  
  // Read the value 10 times:
  for (int i = 0; i < averageValue; i++)
  {
    sensorValue += analogRead(Pin);
 
    // wait 1 milliseconds before the next loop
    delay(1);
 
  }
 
  sensorValue = sensorValue / averageValue;
 
  // The on-board ADC is 10-bits 
  // Different power supply will lead to different reference sources
  // example: 2^10 = 1024 -> 5V / 1024 ~= 4.88mV
  //          unitValue= 5.0 / 1024.0*1000 ;
  
  float unitValue= RefVal / 1024.0*1000 ;
  float voltage = unitValue * sensorValue; 
 
  //When no load,Vref=initialValue
 // SERIAL.print("initialValue: ");
 // SERIAL.print(voltage);
 // SERIAL.println("mV"); 
 
  // Calculate the corresponding current
  float current = (voltage - Vref) * sensitivity;


  
 Serial.println(current);
 Serial.print(":");
 Serial.print(voltage);
 


 
  
 //delay(50)
  
}
