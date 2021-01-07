/**********************************************************************************************
 *  Description
 *    HOW IT WORKS?
 *    Hmm, well actually we have to figure out the distance because the sensor itself simply holds it's "ECHO" pin HIGH 
 *    for a duration of time corresponding to the time it took to receive the reflection (echo) from a wave it sent.
 *    
 *    The module sends out a burst of sound waves, at the same time it applies voltage to the echo pin.
 *    The module receives the reflection back from the sound waves and removes voltage from the echo pin.
 *    On the base of the distance a pulse is generated in the ultrasonic sensor to send the data to NodeMCU or any other micro-controller.
 *    
 *    The starting pulse is about 10us and the PWM signal will be 150 us-25us on the base of the distance. 
 *    If no obstacle is there, then a 38us pulse is generated for NodeMCU to confirm that there are not objects detected.
 *    
 *    Before getting the reading of the HC-SR04 know about the calculation.
 *    FORMULA
 *    D = 1/2 × T × C
 *    where D is the distance, T is the time between the Emission and Reception, and C is the sonic speed.
 *    (The value is multiplied by 1/2 because T is the time for go-and-return distance.)
 *    
 *  Once we have distance data, result will be virtual write to blynk cloud server 
 *    
 *  Circuit Connection
 *    The circuit connections are made as follows:
 *      The HC-SR04 sensor attach to the Breadboard
 *      The sensor Vcc is connected to the NodeMCU +3.3v
 *      The sensor GND is connected to the NodeMCU GND
 *      The sensor Trigger Pin is connected to the NodeMCU Digital I/O D4
 *      The sensor Echo Pin is connected to the NodeMCU Digital I/O D3
 *    
 *  Input
 *    Trig  : D4  :   NODEMCU/ESP8266 Digital Pin 2
 *    Echo  : D3  :   NODEMCU/ESP8266 Digital Pin 0
 *  
 *  Output
 *    V0 : Blynk Virtual Pin 0 : Value Display widget attached to V0
 *  
 **********************************************************************************************/
 #define BLYNK_PRINT Serial
//--------------------------------------
// Import Libraries
//--------------------------------------
#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>

//--------------------------------------
// Constants
//--------------------------------------
char auth[] = "DtS2L59r2YcuwGRq796i1C_Boei6I0TD"; // Blynk Auth Token
char ssid[] = "BELL950";                          // Your WiFi credentials (SSID)
char pass[] = "POUDLARD7438";                     // Your WiFi credentials (PASSWORD)
#define TRIGGERPIN 2  // NodeMcu Digital Pin 2 D4 Arduino Crossover
#define ECHOPIN 0     // NodeMcu Digital Pin 0 D3 Arduino Crossover

//--------------------------------------
// Variables
//--------------------------------------
long duration;
int distance;

//--------------------------------------
// Objects
//--------------------------------------
BlynkTimer timer;

//--------------------------------------
// Functions
//--------------------------------------

void sendSensor()
{
  digitalWrite(TRIGGERPIN, LOW);
  delayMicroseconds(3);

  digitalWrite(TRIGGERPIN, HIGH);
  delayMicroseconds(12);

  digitalWrite(TRIGGERPIN, LOW);
  duration = pulseIn(ECHOPIN, HIGH);
  distance = (duration/2) / 29.1;

  if ( isnan(distance) ){
    Serial.println("Failed to read from HC-SR04 sensor!");
    return;
  } else {
    // Serial.print(distance);
    // Serial.println("Cm");
  }
  
  // You can send any value at any time.
  // Please don't send more that 10 values per second.
  
  Blynk.virtualWrite(V0, distance);

}
//--------------------------------------
// Main
//--------------------------------------
void setup() {
  // Debug console
  Serial.begin(9600);

  // Establish network connexion
  Blynk.begin(auth, ssid, pass);

  pinMode(TRIGGERPIN, OUTPUT);
  pinMode(ECHOPIN, INPUT);

  // Setup a function to be called every 2 seconds
  timer.setInterval(3500L, sendSensor);
}

void loop()
{
  Blynk.run();
  timer.run();
}
