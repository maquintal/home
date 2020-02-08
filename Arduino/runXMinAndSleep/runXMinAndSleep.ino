// BLYNK LIBRARIES //
#define BLYNK_PRINT Serial
#include <BlynkSimpleEsp8266.h>

// GLOBAL VARIABLES //
char auth[] = "YOUR AUTH";
char ssid[] = "YOUR SSID";
char pass[] = "YOUR PASSWORD";

const int D7 = 13;

// TOOLS //
BlynkTimer timer;

void goToSleep() {
  Serial.print("Good Bye !");
  ESP.deepSleep(0);
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Blynk.begin(auth, ssid, pass);
  digitalWrite(D7, HIGH);
  timer.setInterval(1200000L, goToSleep);
}

void loop() {
  // put your main code here, to run repeatedly:
  Blynk.run();
  timer.run();
}
