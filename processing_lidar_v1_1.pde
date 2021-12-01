import processing.serial.*;
Serial myPort;  // The serial port
int lf = 10;    // Linefeed in ASCII
String myString = null;
float x1, y1, angle1; //x-coord, y-coord of sensor 1's datapoint, plus the angle of the sensor for that
float x2, y2; //x-coord, y-ccord of sensor 2's datapoint
float num1;
float num2;
float num3;
int i = 0;

void setup() {
  printArray(Serial.list()); // List all the available serial ports
  myPort = new Serial(this, Serial.list()[1], 115200);   // Open the port you are using at the rate you want, for instance Port 1 is selected here, at a baud rate of 115200

  noSmooth();
  background(0);
  fullScreen();
  translate(960, 540); //This is for a screen resolution of 1920:1080, you may need to edit this if yours is different
  stroke(255);
  strokeWeight(3);  // Default
  fill(0); //This is the code to fill shapes with black
  circle(0, 0, 1000); //Draws a circle to represent the maximum range limited by the Arduino program
  circle(0, 0, 30); //Draws a circle to represent the diameter of the sensor itself
}

void draw() {

  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(10);
    if (myString != null) {
      String[] q = splitTokens(myString, ","); //This tells the program to split the incoming string each time a comma is used

      num1 = float(q[0]); // Converts and prints float
      num2 = float(q[1]); // Converts and prints float
      num3 = float(q[2]); // Converts and prints float

      angle1 = num1 * 0.0174533; //Passes from polar to cartesians coordinates and centralises on screen (of 1920:1080 resolution)
      x1 = (sin(angle1)*num2 + 960);
      y1 = (cos(angle1)*num2 + 540);

      x2 = (-1 * sin(angle1)*num3 + 960); //The same for the second sensor's data, but inverted so it is 180 degrees opposed
      y2 = (-1 * cos(angle1)*num3 + 540);
    }
    point(x1, y1); //Draws the first point
    point(x2, y2); //Draws the second point
  }
  myPort.clear(); //Clears the serial port
}
