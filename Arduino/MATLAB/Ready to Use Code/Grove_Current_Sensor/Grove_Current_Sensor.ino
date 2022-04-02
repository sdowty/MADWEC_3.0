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
const int averageValue = 150;
  long convFLcurrent;
  float convLFcurrent;
long int sensorValue = 0;
float sensitivity = 1000.0 / 264.0; //1000mA per 264mV 
 
 
float Vref = 317.38;   //Vref is zero drift value, you need to change this value to the value you actually measured before using it.
void setup() 
{
  Serial.begin(9600);
}
 
void loop() 
{

 /*//////////////////////////////////////////////////////////////////////////////
  // VREF CALIBRATION 
   // Set Reading pins as open and run code to measure voltage from analog pin that 
   // the arduino is reading from the current sensor
   // Read the value 10 times:
  for (int i = 0; i < averageValue; i++)
  {
    sensorValue += analogRead(A2);
 
    // wait 2 milliseconds before the next loop
    delay(2);
 
  }
 
    sensorValue = sensorValue / averageValue;
    // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V) to mV:
    float voltage = sensorValue * (5.0 / 1024.0)*1000;
    Serial.print("Voltage:\n");
  Serial.print(voltage);
  Serial.print("\n");
 delay(250); 
 
 //////////////////////////////////////////////////////////*/  

  
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
  convFLcurrent = current;
  convLFcurrent = convFLcurrent;
 //Serial.print(current);
// SERIAL.write(CURRENT);
  SERIAL.write((long int)current);
  //Serial.write(CURRENT);
 // SERIAL.print("mA F: ");
 // SERIAL.print(convFLcurrent);
//  SERIAL.println("mA FL"); 
 //CURRENT = current;
  // Print display voltage (mV)
  // This voltage is the pin voltage corresponding to the current
  /*
  voltage = unitValue * sensorValue-Vref;
  SERIAL.print(voltage);
  SERIAL.println("mV");
  */
  //current = CURRENT;
  //Serial.print(CURRENT);
  //Serial.write(CURRENT);
  //Serial.print(current);
  // Print display current (mA)
 // SERIAL.print(current);
 // SERIAL.println("mA");
  //SERIAL.println("");
 // SERIAL.println("mA");
  //SERIAL.print("\n");
  // Reset the sensorValue for the next reading
  //sensorValue = 0;
  // Read it once per second
  //delay(250); 
  
}
