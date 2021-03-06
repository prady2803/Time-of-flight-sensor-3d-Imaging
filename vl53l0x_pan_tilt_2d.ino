#include <Wire.h>
#include "Adafruit_VL53L0X.h"
#include <Servo.h>
Adafruit_VL53L0X vl = Adafruit_VL53L0X();
Servo myservo1;
Servo myservo2;
float pos_x = 0, pos_y = 0;
const float Pi = 3.14159; 
void setup() {
   myservo1.attach(9); 
  myservo2.attach(8);
  Serial.begin(115200);
  while (!Serial) {
    delay(1);
  }
  
 if (! vl.begin()) {   
    while (1);
  } 
}

void loop() { 
for (pos_x = 35; pos_x >= 0; pos_x -= 0.3) 
{
  myservo2.write(pos_x);
  for (pos_y = 0; pos_y <= 120; pos_y += 0.3) 
  {  
     
      myservo1.write(pos_y);
             uint8_t range_x = vl.readRange();
             if  (range_x >800 and range_x <80){
              range_x =0;
             }
     float azimuth = pos_y *Pi/180;
     float elev =(180- 110 + pos_x)*Pi/180;
     double x =  range_x * sin(elev) * cos(azimuth);
     double y = range_x * sin(elev) * sin(azimuth);
     double z = range_x * cos(elev);
    // Serial.println(String(range_x,5)+" "+String(pos_y*Pi/180)+" "+String(pos_y) +" "+ String((180 - 120+ pos_x)*Pi/180)+" "+String(pos_x));
      Serial.println(String(-x, 5) +" "+ String(y, 5) +" " + String(-z, 5));
         delay(5);
  }

  myservo1.write(0);
}
myservo2.write(35);
  delay(10);
}
