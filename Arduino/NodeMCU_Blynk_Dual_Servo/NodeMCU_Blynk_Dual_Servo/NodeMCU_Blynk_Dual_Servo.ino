/*
 *  Description
 *    Controlling 2 servos over wifi using Blynk library and nodemcu (ESP8266)
 *  
 *  Input
 *    V0 : Blynk Virtual Pin 0 (I used vertical slider)
 *    V1 : Blynk Virtual Pin 1 (I used horizontal slider)
 *  
 *  Output
 *    V0 desired value as object (servoVertical) new angle
 *    V1 desired value as object (servoHorizontal) new angle
 *    
 *  Important 
 *    Timer has been added to detach servo, this way servo motor will not force
 *    note that when slider(s) are touch(ed) servo(s) re-attach to set new angle 
 *
 *  There are two common types of servo:
 *  White - Red - Black wired servo
 *  Orange - Red - Brown wired servo
 * 
 *  If your servo has White - Red - Black wires, then connect it as follows
 * 
 *  White wire connects to Digital pin D4
 *  Black wire connects to GND pin
 *  Red wire connects to 3V3 pin
 * 
 *  If your servo has Orange - Red - Brown wires, then connect it as follows
 * 
 *  Orange wire connects to Digital pin D4.
 *  Brown wire connects to GND pin
 *  Red wire connects to 3V3 pin
 *  
 */
 
// LIBRARIES //
#define BLYNK_PRINT Serial
#include <BlynkSimpleEsp8266.h>
#include <Servo.h>

// TOOLS //
BlynkTimer timer;

// GLOBAL VARIABLES //
char auth[] = "71f5d84360634b6b9484753bb3ed4eab";
char ssid[] = "BELL950";
char pass[] = "POUDLARD7438";
const int DigitalPinD0 = 16;
const int DigitalPinD1 = 5;

// OBJECTS //
Servo servoVertical;
Servo servoHorizontal;

BLYNK_WRITE(V0) {
  servoVertical.attach(DigitalPinD0);
  servoVertical.write(param.asInt());
}

BLYNK_WRITE(V1) {
  servoHorizontal.attach(DigitalPinD1);
  servoHorizontal.write(param.asInt());
}

// CUSTOM FUNCTION //
void goDetach() {
  servoVertical.detach();
  servoHorizontal.detach();
}

// MAIN //
void setup() {
  Serial.begin(9600);
  Blynk.begin(auth, ssid, pass);
  servoVertical.attach(DigitalPinD0);
  servoHorizontal.attach(DigitalPinD1);
  digitalWrite(LED_BUILTIN, HIGH);
  timer.setInterval(10000L, goDetach);
}

void loop() {
  Blynk.run();
  timer.run();
}
