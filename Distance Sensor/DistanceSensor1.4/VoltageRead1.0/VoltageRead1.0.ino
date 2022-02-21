/*
  ReadAnalogVoltage

  Reads an analog input on pin 0, converts it to voltage, and prints the result to the Serial Monitor.
  Graphical representation is available using Serial Plotter (Tools > Serial Plotter menu).
  Attach the center pin of a potentiometer to pin A0, and the outside pins to +5V and ground.

  This example code is in the public domain.

  https://www.arduino.cc/en/Tutorial/BuiltInExamples/ReadAnalogVoltage
*/

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input on analog pin 3:
  int sensorValue = analogRead(A3);
   int attx = 11;
   float error = 1.01171; 
  // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
  float voltage = error * attx * sensorValue * (5.0 / 1023.0);
  // print out the value you read:
  Serial.print(voltage);
  Serial.print(":");
  Serial.print(sensorValue);
  Serial.println();
}
