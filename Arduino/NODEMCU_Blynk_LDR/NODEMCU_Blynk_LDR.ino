/*
 *  Description
 *    Controlling strip led over wifi using Blynk library and nodemcu (ESP8266)
 *  
 *  Input
 *    LDR
 *      A0: One leg of the LDR is connected to VCC (5V) on the Arduino, and the other to the analog pin 0 on the Arduino. A 100K resistor is also connected to the same leg and grounded.
 *          
 *    BTN
 *      V2 : Virtual Blynk Button
 *  
 *  Output
 *    LED
 *      D7: Voltage HIGH | LOW
 *    
 *    Note: When the button is turned on, it bypasses the LDR sensor. In other words the led strip works continuously
  */
#define BLYNK_PRINT Serial

#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>

//--------------------------------------
// Constants
//--------------------------------------
char auth[] = "auth token";
char ssid[] = "ssid";
char pass[] = "ssid password";
const int digitalPinD7 = 13;

//--------------------------------------
// Objects
//--------------------------------------
BlynkTimer timer;
//WidgetLED led(V3);

//--------------------------------------
// Variables
//--------------------------------------
int buttonVirtualPin;
int ldrSensorData;

BLYNK_WRITE(V2)
{
  buttonVirtualPin = param.asInt();
  //Serial.print("V2 value is: ");
  //Serial.println(buttonVirtualPin);
}
  
void sendSensor()
{

  ldrSensorData = analogRead(A0); //reading the sensor on A0

  if ( isnan(ldrSensorData) ){
    Serial.println("Failed to read from LDR sensor!");
    return;
  } else {
      //Serial.println(ldrSensorData);

      if ( buttonVirtualPin == 1 )
      {
        digitalWrite(13, HIGH);
      } else {
        if ( ldrSensorData < 400 ) {
          digitalWrite(13, HIGH);
        } else {
          digitalWrite(13, LOW);
        }
      }
  }
}

void setup()
{
  // Debug console
  Serial.begin(9600);

  Blynk.begin(auth, ssid, pass);
  WiFi.hostname("Aethelwulf"); // all my devices have Vikings name (I know it's geek)

  timer.setInterval(3000L, sendSensor);
}

void loop()
{
  Blynk.run();
  timer.run();
}
