// LIBRARIES //

#define BLYNK_PRINT Serial
#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>

// GLOBAL VARIABLES //
char auth[] = "71f5d84360634b6b9484753bb3ed4eab";
char ssid[] = "BELL950";
char pass[] = "*";
const sensorPin = analogRead(A0);
const sensorTreshold = 350;

// TOOLS //
BlynkTimer timer;

// FUNCTIONS //
void sendMail() {
  // *** WARNING: You are limited to send ONLY ONE E-MAIL PER 15 SECONDS! ***
  Serial.println("Important Alert water is detected");
  Blynk.email("vanaquin@hotmail.com", "[IMPORTANT] SumpPump Water Sensor", "Very important alert, water has been detected into sumppump pit");
}

void monitoring() {
  Blynk.email("maquintal16@gmail.com", "[MONITORING] SumpPump Water Sensor", "Water sensor daily check");
}

void printOutput() {
  Serial.println("Water Sensor value: " + String(sensorPin));
}

// This function sends Arduino's up time every second to Virtual Pin (5).
// In the app, Widget's reading frequency should be set to PUSH. This means
// that you define how often to send data to Blynk App.
void pullAndWriteData() {
  // You can send any value at any time.
  // Please don't send more that 10 values per second.
  Blynk.virtualWrite(V5, sensorPin);
  printOutput;
  if ( sensorPin > sensorTreshold ) {
    //sendMail;
    Serial.println("value is over than " + sensorTreshold);
  }
}

// SETUP //
void setup() {
  Serial.begin(9600);
  Blynk.begin(auth, ssid, pass);
}

// MAIN //
void loop(){
  Blynk.run();
  timer.run(); // Initiates BlynkTimer
  timer.setInterval(15000L, pullAndWriteData);
  timer.setInterval(86400000L, monitoring);
}
