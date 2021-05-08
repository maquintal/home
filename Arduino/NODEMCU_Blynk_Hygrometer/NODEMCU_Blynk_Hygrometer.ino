/*
 *  Description
 *    The module can give us a digital signal when the soil need watering and this output can be adjusted by the potentiometer.
 *    Or it can give us an analog signal of current soil moisture!
 *    
 *    Will use the analog signal output of this module and we will change it in percentage value.
 *    Finally we will use Blynk library to print the current percentage value of soil moisture into gauge
 *    
 *  Pin-out
 *    The FC-28 soil moisture sensor has four pins:
 *      VCC: Power
 *      A0: Analog Output | D0: Digital Output
 *      GND: Ground
 *  
 *  Input
 *    The Probe
 *      The sensor contains a fork-shaped probe with two exposed conductors that goes into the soil or anywhere else where the water content is to be measured.
 *      
 *    The Module
 *      The sensor also contains an electronic module that connects the probe to the nodemcu.
 *      The module produces an output voltage according to the resistance of the probe and is made available at an Analog Output (AO) pin.
 *  
 *  Output
 *    V0  : Blynk Virtual Pin 0
 *
  */
#define BLYNK_PRINT Serial

#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>

//--------------------------------------
// Constants
//--------------------------------------
char auth[] = "auth";
char ssid[] = "ssid";
char pass[] = "ssidPassword";

const int analogPinA0 = A0;

//--------------------------------------
// Objects
//--------------------------------------
BlynkTimer timer;

//--------------------------------------
// Variables
//--------------------------------------
int sensorData;
int output;

void sendSensor()
{

  sensorData = analogRead(A0); //reading the sensor on A0

  if ( isnan(sensorData) ){
    // Serial.println("Failed to read from Hygrometer Soil Moisture sensor!");
    return;
  } else {
    // Serial.println(sensorData);
    // When the plant is watered well the sensor will read a value 380~400, I will keep the 400 
    // value but if you want you can change it below. 
  
    sensorData = constrain(sensorData,400,1023);  //Keep the ranges!
    output = map(sensorData,400,1023,100,0);  //Map value : 400 will be 100 and 1023 will be 0
    // Serial.println(output);

    Blynk.virtualWrite(V0, output);
  
  }
}

void setup()
{
  // Debug console
  Serial.begin(9600);

  Blynk.begin(auth, ssid, pass);
  WiFi.hostname("Siggy"); // all my devices have Vikings name (I know it's geek)
  
  timer.setInterval(3000L, sendSensor);
}

void loop()
{
  Blynk.run();
  timer.run();
}
