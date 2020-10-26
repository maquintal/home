/*
 *  Description
 *  
 *  Input
 *    V3 : Blynk Virtual Pin 3
 *  
 *  Output
 *  
 *  
 */

// LIBRARIES //
#define BLYNK_PRINT Serial

#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>

// GLOBAL VARIABLES //
char auth[] = "71f5d84360634b6b9484753bb3ed4eab";
char ssid[] = "BELL950";
char pass[] = "POUDLARD7438";
//const int DigitalPinD0 = 16;
//const int DigitalPinD1 = 5;

// VARIABLES //
// We make these values volatile, as they are used in interrupt context
//volatile bool pinChanged = false;
volatile int pinValue = 1;

// BLYNK OBJECTS //
WidgetLED led1(V3);

// FUNCTIONS //
//void checkPin()
//{
  // Invert state, since button is "Active LOW"
//  pinValue = !digitalRead(2);

  // Mark pin value changed
//  pinChanged = true;
//}

// STRUCTURE SKETCH SETUP //
void setup()
{
  // Debug console
  Serial.begin(9600);

  Blynk.begin(auth, ssid, pass);
  // You can also specify server:
  //Blynk.begin(auth, ssid, pass, "blynk-cloud.com", 80);
  //Blynk.begin(auth, ssid, pass, IPAddress(192,168,1,100), 8080);

  // Make pin 2 HIGH by default
  pinMode(2, INPUT_PULLUP);
  
  // Attach INT to our handler
//  attachInterrupt(digitalPinToInterrupt(2), checkPin, CHANGE);
}

// STRUCTURE SKETCH LOOP //
void loop()
{
  Blynk.run();
  //if (pinChanged) {

    // Process the value
    if (pinValue) {
      led1.on();
    } else {
      led1.off();
    }

    // Clear the mark, as we have processed the value
    //pinChanged = false;
  //}
}
