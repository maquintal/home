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

#include <PubSubClient.h>

// GLOBAL VARIABLES //
char auth[] = "U-zQXrRDuQ6taLOWfWVOZrgJTCLa3Zde";
char ssid[] = "BELL950";
char pass[] = "POUDLARD7438";
const char *ID = "Example_Switch";  // Name of our device, must be unique
const char *TOPIC = "room/light";  // Topic to subcribe to 

// VARIABLES //
int virtualBtnState = 0;

// BLYNK OBJECTS //
WidgetLED ledV3(V3);

// MQTT OBJECTS //
IPAddress broker(192,168,2,12); // IP address of your MQTT broker eg. 192.168.1.50
WiFiClient wclient;
PubSubClient client(wclient); // Setup MQTT client 

// FUNCTIONS //

// This function will be called every time Button Widget
// in Blynk app writes values to the Virtual Pin V2
BLYNK_WRITE(V2) {
  int virtualBtnState = param.asInt(); // assigning incoming value from pin V2 to a variable

  Serial.println(virtualBtnState);
  //if (virtualBtnState == 1) {
  //  Serial.println("on");
  //  Blynk.virtualWrite(V3, 0);
  //} else {
  //  Serial.println("off");
  //  Blynk.virtualWrite(V3, 1023);
  //}

  // If state has changed...
  if (virtualBtnState == 1) {
    ledV3.on();
    client.publish(TOPIC, "on");
    Serial.println("TOPIC"   " => on");
  } else {
    ledV3.off();
    Serial.println("TOPIC"   " => off");
    client.publish(TOPIC, "off");
  }
  
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect(ID)) {
      Serial.println("connected");
      Serial.print("Publishing to: ");
      Serial.println(TOPIC);
      Serial.println('\n');

    } else {
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

// STRUCTURE SKETCH SETUP //
void setup() {
  // Debug console
  Serial.begin(9600);

  Blynk.begin(auth, ssid, pass);

  client.setServer(broker, 1883);
}

// STRUCTURE SKETCH LOOP //
void loop() {
  Blynk.run();

  if (!client.connected())  // Reconnect if connection is lost
  {
    reconnect();
  }
  client.loop();

}
