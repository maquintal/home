/*Skip to content
 
Search…
All gists
GitHub
Sign up for a GitHub account Sign in
Create a gist now
Instantly share code, notes, and snippets.
 Star 0  Fork 0 @structure7structure7/blynkDS18B20.ico
Last active 18 days ago
Embed  
<script src="https://gist.github.com/structure7/13c9cf278843a74e688c0252067ed806.js"></script>
  Download ZIP
 Code  Revisions 7
Simple sketch for using the DS18B20 temp sensor on an ESP8266 with Blynk
Raw
 blynkDS18B20.ico */
//#include <SimpleTimer.h>           // Allows us to call functions without putting them in loop()

//--------------------------------------
// Import Blynk Libraries
//--------------------------------------
#define BLYNK_PRINT Serial         // Comment this out to disable prints and save space
#include <BlynkSimpleEsp8266.h> 

#include <OneWire.h>
#include <DallasTemperature.h> 
#define ONE_WIRE_BUS 2          // Your ESP8266 pin (ESP8266 GPIO 2 = WeMos D1 Mini pin D4)
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

//--------------------------------------
// Global Variables
//--------------------------------------
char auth[] = "71f5d84360634b6b9484753bb3ed4eab";
char ssid[] = "VIDEOTRON3218";
char pass[] = "TU43CNTJCFETX";
int roomTemperatureF;            // Room temperature in F
int roomTemperatureC;            // Room temperature in C

//--------------------------------------
// 
//--------------------------------------
//SimpleTimer timer;
BlynkTimer timer;

void setup()
{
  Serial.begin(9600);
  Blynk.begin(auth, ssid, pass);

  while (Blynk.connect() == false) {
    // Wait until connected
  }

  sensors.begin();                        // Starts the DS18B20 sensor(s).
  sensors.setResolution(10);              // More on resolution: http://www.homautomation.org/2015/11/17/ds18b20-how-to-change-resolution-9101112-bits/

  timer.setInterval(2000L, sendTemps);    // Temperature sensor read interval. 2000 (ms) = 2 seconds.
}

// Notice how there is very little in the loop()? Blynk works best that way.
void loop()
{
  Blynk.run();
  timer.run();
}

// Notice how there are no delays in the function below? Blynk works best that way.

void sendTemps()
{
  sensors.requestTemperatures();                  // Polls the sensors.
  roomTemperatureF = sensors.getTempFByIndex(0);   // Stores temperature. Change to getTempCByIndex(0) for celcius.
  roomTemperatureC = sensors.getTempCByIndex(0);   // Stores temperature. 
  
  Serial.print("Temperature: ");
  Serial.println(roomTemperatureF);
  Serial.println(roomTemperatureC);
  Blynk.virtualWrite(1, roomTemperatureF);         // Send temperature to Blynk app virtual pin 1.
  Blynk.virtualWrite(2, roomTemperatureC);         // Send temperature to Blynk app virtual pin 2.
}
