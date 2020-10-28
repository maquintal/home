/*
 *  Description
 *  
 *  Input
 *    V2 :  Blynk Virtual Pin 2  : Virtual Button
 *  
 *  Output
 *    V3  : Blynk Virtual Pin 3  : Virtual LED
 *  
 *  
 */

// LIBRARIES //
#define BLYNK_PRINT Serial

#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>

// GLOBAL VARIABLES //
char auth[] = "U-zQXrRDuQ6taLOWfWVOZrgJTCLa3Zde";
char ssid[] = "BELL950";
char pass[] = "POUDLARD7438";

// VARIABLES //
// We make these values volatile, as they are used in interrupt context
// volatile 
bool pinChanged = false;
//volatile
int virtualBtnValue = 0;

// BLYNK OBJECTS //
WidgetLED led1(V3);

// FUNCTIONS //

// This function will be called every time Button Widget
// in Blynk app writes values to the Virtual Pin V2
BLYNK_WRITE(V2) {
  int virtualBtnValue = param.asInt(); // assigning incoming value from pin V2 to a variable

  Serial.println(virtualBtnValue);

  if (virtualBtnValue = 1) {
    led1.on();
  } else {
    led1.off();
  }
  
  //if (virtualBtnValue = 0) {
  //  pinChanged = false;
  //} else if (virtualBtnValue = 1) {
  //  pinChanged = true;
  //}
}

// STRUCTURE SKETCH SETUP //
void setup() {
  // Debug console
  Serial.begin(9600);

  Blynk.begin(auth, ssid, pass);

  // Make pin 2 HIGH by default
  pinMode(2, INPUT_PULLUP);
  
  // Attach INT to our handler
//  attachInterrupt(digitalPinToInterrupt(2), checkPin, CHANGE);
}

// STRUCTURE SKETCH LOOP //
void loop() {
  Blynk.run();

  //Serial.println(pinChanged);
  // process received value
    
  // Mark pin value changed
  //if (pinChanged = true) {
  //  led1.on();
  //} else {
  //  led1.off();
  //}
}
