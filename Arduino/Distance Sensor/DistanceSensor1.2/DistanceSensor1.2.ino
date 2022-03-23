#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd1(0x27, 16, 2); //distance LCD
LiquidCrystal_I2C lcd2(0x3F, 16, 2); //velocity LCD

//HC-SR04 Distance Sensor 
#define echoPin 2         //pin D2 on Arduino 
#define trigPin 3         //pin D3 on Arduino
#define LEDind 7

//Defining Variables 
long duration;            // variable for duration of sound wave from HC-SR04
long tDuration;
int distance_cm = 0;      // variable for Cent. measurement
float distance_inch = 0;  // variable for Cent. measurement
float velocity_cm;
float velocity_m;
float startDistance;
float endDistance;
void setup()
{
// initializing LCD Display 
  lcd1.begin(); 
  lcd1.backlight();
  lcd1.clear();
 // lcd.setCursor(4,0);
  //lcd.print("STANDBY");
  
   lcd2.begin(); 
  lcd2.backlight();
  lcd2.clear();
  //lcd2.setCursor(0,0);
  //lcd2.print("STANDBY");
  
//Seting pins on HC-SR04
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin,INPUT);
  pinMode(LEDind,OUTPUT); 
//Setting the Serial Display 
  Serial.begin(9600);                          // Serial Communication is starting with 9600 of baudrate speed
  Serial.println("Ultrasonic Sensor HC-SR04 Test"); // print some text in Serial Monitor
  Serial.println("with Arduino UNO R3");
  Serial.println("*********************************************************************************************");
}

void loop() 
{
   //Calculating Speed 
  duration = sensorRead(); //calls sensorRead Function. Gets Distance in cm 
          //  delay(500); //time gap of .5 sec for next reading
          // endTime= sensorRead();

   //calculating the distance
    distance_cm = (duration) * (0.034 / 2); //speed of sound wave 340m/s  // divided by 2 (go and back)
    distance_inch = (duration) * (0.0133 / 2); 

      Serial.print("Distance_cm: ");
      Serial.print(distance_cm);
      Serial.print("\t");
      Serial.print("Distance_inch: ");
      Serial.print(distance_inch);
      Serial.println("\t");
    
    lcd1.setCursor(0,0);
    lcd1.print("Dist cm: ");
    lcd1.print(distance_cm);
   // lcd2.setCursor(8,1);
  //  lcd1.print(distance_inch); 
  
/*
  velocity_cm = (startDistance - endDistance)/(.5); //time gap is .5//in cm 
  velocity_m = velocity_cm/100; 
  //displaying Speed 
  Serial.print("velocity: ");
  Serial.print(velocity_m);
  Serial.print(" m/s");
  Serial.println("\t");
*/ 
lcd2.setCursor(0,0);
lcd2.print("SPEED: ");
lcd2.print(velocity_cm);
}

float sensorRead()
{
    digitalWrite(LEDind,HIGH);
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

 /*
  //calculating the distance
    distance_cm = (duration) * (0.034/2); //speed of sound wave 340m/s  // divided by 2 (go and back)
    distance_inch = duration * 0.0133 / 2; 
  
  //Displaying on LCD
  //lcd.clear() ;
    lcd1.setCursor(0,0);
    lcd1.print("Dist: ");
    lcd1.print(distance_cm);
    lcd1.println(" cm");
    
    lcd1.setCursor(0,1);
    lcd1.print("Dist: ");
    lcd1.print(distance_inch);
    lcd1.println(" in");
    
    Serial.print("Distance cm: ");
    Serial.print(distance_cm);
    Serial.print("\t");
    Serial.print("Distance inch: ");
    Serial.print(distance_inch);
    Serial.println("\t");
  return distance_cm;

  */
