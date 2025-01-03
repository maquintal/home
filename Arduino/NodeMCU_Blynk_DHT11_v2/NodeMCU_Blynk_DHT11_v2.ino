#include <BearSSLHelpers.h>
#include <CertStoreBearSSL.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiAP.h>
#include <ESP8266WiFiGeneric.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266WiFiSTA.h>
#include <ESP8266WiFiScan.h>
#include <ESP8266WiFiType.h>
#include <WiFiClient.h>
#include <WiFiClientSecure.h>
#include <WiFiClientSecureAxTLS.h>
#include <WiFiClientSecureBearSSL.h>
#include <WiFiServer.h>
#include <WiFiServerSecure.h>
#include <WiFiServerSecureAxTLS.h>
#include <WiFiServerSecureBearSSL.h>
#include <WiFiUdp.h>

/**********************************************************************************************
 *  Description
 *    This sketch shows how value can be pushed from NodeMCU to the Blynk App.
 *    
 *  Input
 *    D2 :  NODEMCU/ESP8266 Digital Pin 4
 *  
 *  Output
 *    V0 : Blynk Virtual Pin 0 : Value Display widget attached to V0
 *    V1 : Blynk Virtual Pin 1 : Value Display widget attached to V1
 *  
 **********************************************************************************************/
#define BLYNK_PRINT Serial                        // not sure if should be on top !?

//--------------------------------------
// Import Libraries
//--------------------------------------
#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>
#include "DHT.h"                                  // including the library of DHT11 temperature and humidity sensor

//--------------------------------------
// Constants
//--------------------------------------

// Uncomment whatever type you're using!
//#define DHTTYPE DHT11                           // DHT 11
//#define DHTTYPE DHT22                           // DHT 22, AM2302, AM2321
//#define DHTTYPE DHT21                           // DHT 21, AM2301

#define DHTTYPE DHT11                             // DHT 11

#define DHTPIN 4                                  // NodeMcu Digital Pin 4 D2 Arduino Crossover

char auth[] = "5WQGNSvVFn61J8i3ZjWykcOAAup0CIBz"; // Blynk Auth Token
char ssid[] = "BELL684";                          // Your WiFi credentials (SSID)
char pass[] = "POUDLARD7438";                     // Your WiFi credentials (PASSWORD)

//--------------------------------------
// Objects
//--------------------------------------
DHT dht(DHTPIN, DHTTYPE);                         // Set DHT Object with Digital Pin and Senor Type
BlynkTimer timer;

//--------------------------------------
// Functions
//--------------------------------------
void sendSensor() {
  // This function sends Arduino's up time every 5 seconds to Virtual Pin (5).
  // In the app, Widget's reading frequency should be set to PUSH. This means
  // that you define how often to send data to Blynk App.

  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();                // or dht.readTemperature(true) for Fahrenheit

  if (isnan(humidity) || isnan(temperature)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }
  // You can send any value at any time.
  // Please don't send more that 10 values per second.
  
  Blynk.virtualWrite(V0, humidity);
  Blynk.virtualWrite(V1, temperature);

  // Make sure that your sensor iw working properly before put into production
  // Serial.print("Humidity is: ");
  // Serial.println(humidity);
  // Serial.print("Temperature is: ");
  // Serial.println(temperature);
}

//--------------------------------------
// Main
//--------------------------------------
void setup() {
  // Debug console
  Serial.begin(9600);

  Blynk.begin(auth, ssid, pass);
  WiFi.hostname("Ragnar"); // all my devices have Vikings name (I know it's geek)
  
  dht.begin();

  // Setup a function to be called every 2 seconds
  timer.setInterval(2000L, sendSensor);
}

void loop()
{
  Blynk.run();
  timer.run();
}
