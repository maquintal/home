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

//--------------------------------------
// Import Libraries
//--------------------------------------
#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>
#include "DHT.h"                                  // including the library of DHT11 temperature and humidity sensor

//--------------------------------------
// Constants
//--------------------------------------
#define BLYNK_PRINT Serial                        // not sure if should be on top !?
#define DHTTYPE DHT11                             // DHT 11
#define DHTPIN 4                                  // NodeMcu Digital Pin 4 D2 Arduino Crossover
char auth[] = "5WQGNSvVFn61J8i3ZjWykcOAAup0CIBz"; // Blynk Auth Token
char ssid[] = "BELL950";                          // Your WiFi credentials (SSID)
char pass[] = "POUDLARD7438";                     // Your WiFi credentials (PASSWORD)

//--------------------------------------
// Objects
//--------------------------------------
DHT dht(DHTPIN, DHTTYPE);                         // Set DHT Object with Digital Pin and Senor Type

// Uncomment whatever type you're using!
//#define DHTTYPE DHT11                           // DHT 11
//#define DHTTYPE DHT22                           // DHT 22, AM2302, AM2321
//#define DHTTYPE DHT21                           // DHT 21, AM2301

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
}

void setup() {
  // Debug console
  Serial.begin(9600);

  Blynk.begin(auth, ssid, pass);
  
  dht.begin();

  // Setup a function to be called every 60 seconds
  timer.setInterval(60000L, sendSensor);
}

void loop()
{
  Blynk.run();
  timer.run();
}
