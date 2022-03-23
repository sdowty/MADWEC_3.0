
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
LiquidCrystal_I2C lcd2(0x3F, 16, 2);//distance LCD

//HC-SR04 Distance Sensor 
#define echoPin 13         //pin D13 on Arduino 
#define trigPin 12         //pin D13 on Arduino


//Defining Variables 
long duration;            // variable for duration of sound wave from HC-SR04
long distance_cm = 0;     // distance read in cm. 

void setup()
{
  // put your setup code here, to run once:
  
  // initializing LCD Display 
  lcd2.begin(); 
  lcd2.backlight();
  lcd2.clear();
  
  //Seting pins on HC-SR04
  Serial.begin(9600);        // Serial Communication is starting with 9600 of baudrate speed

  // Setting Pins on HC-SR04 Sensor 
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin,INPUT);
  
}

void loop() 
{
  // put your main code here, to run repeatedly:
  // finding duration of sound wave 
  duration = sensorRead(); //calls sensorRead Function
  
  //calculating the distance
  distance_cm = (duration) * (0.0340 / 2); //speed of sound wave 340m/s  // divided by 2 (go and back)
  if(distance_cm > 300)
  {
    distance_cm = 300;
  }
  
  //sending to Serial Monitor 
  // MATLAB reads from Serial Monitor 
  Serial.write(distance_cm);

  // disp on LCD
  lcd2.setCursor(0,0);
  lcd2.print("Dist cm: ");
  lcd2.print(distance_cm);
  delay(50); 
}

long sensorRead()
{
    
  //clear trig pin 
    digitalWrite(trigPin,LOW);
    delayMicroseconds(2);
  
  //sets the TrigPin HiGh (active) for 10 microseconds 
    digitalWrite(trigPin,HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin,LOW);
  
  //Reads the echopin
  //***Returns the Soundwave travel time in miscroseconds***
    duration = pulseIn(echoPin,HIGH);

    return duration; 
}
