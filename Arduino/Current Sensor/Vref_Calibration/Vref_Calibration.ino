#include <Wire.h>

#ifdef ARDUINO_SAMD_VARIANT_COMPLIANCE
  #define RefVal 3.3
  #define SERIAL SerialUSB
#else
  #define RefVal 5.0
  #define SERIAL Serial
#endif
//An OLED Display is required here
//use pin A1
#define Pin A1



int  averageValue = 150;
long sensorValue = 0;

void setup() {
  // put your setup code here, to run once:
 Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:


// VREF CALIBRATION 
   // Set Reading pins as open and run code to measure voltage from analog pin that 
   // the arduino is reading from the current sensor
   // Read the value 10 times:
   
  for (int i = 0; i < averageValue; i++)
  {
     sensorValue += analogRead(Pin);
 
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
}
