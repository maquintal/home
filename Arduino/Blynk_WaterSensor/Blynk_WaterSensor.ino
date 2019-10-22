#define BLYNK_PRINT Serial


#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>

// You should get Auth Token in the Blynk App.
// Go to the Project Settings (nut icon).
char auth[] = "71f5d84360634b6b9484753bb3ed4eab";

// Your WiFi credentials.
// Set password to "" for open networks.
char ssid[] = "VIDEOTRON3218";
char pass[] = "TU43CNTJCFETX";

BlynkTimer timer;

void sendMail()
{
  // *** WARNING: You are limited to send ONLY ONE E-MAIL PER 15 SECONDS! ***

  // Let's send an e-mail when you press the button
  // connected to digital pin 2 on your Arduino

  //int isButtonPressed = !digitalRead(2); // Invert state, since button is "Active LOW"

  //if (isButtonPressed) // You can write any condition to trigger e-mail sending
  if ( analogRead(A0) > 250 ) {
    Serial.println("Important Alert water is detected"); // This can be seen in the Serial Monitor
    Blynk.email("vanaquin@hotmail.com", "[IMPORTANT] SumpPump Water Sensor", "Very important alert, water has been detected into sumppump pit");

    // Or, if you want to use the email specified in the App (like for App Export):
    //Blynk.email("Subject: Button Logger", "You just pushed the button...");
  }
}

void monitoring(){
  Blynk.email("maquintal16@gmail.com", "[MONITORING] SumpPump Water Sensor", "Water sensor daily check");
}

// This function sends Arduino's up time every second to Virtual Pin (5).
// In the app, Widget's reading frequency should be set to PUSH. This means
// that you define how often to send data to Blynk App.
void pullAndWriteData()
{
  // You can send any value at any time.
  // Please don't send more that 10 values per second.
  Blynk.virtualWrite(V5, analogRead(A0) );
}

void setup()
{
  // Debug console
  Serial.begin(9600);

  Blynk.begin(auth, ssid, pass);
  // You can also specify server:
  //Blynk.begin(auth, ssid, pass, "blynk-cloud.com", 80);
  //Blynk.begin(auth, ssid, pass, IPAddress(192,168,1,100), 8080);

  // Setup a function to be called every second
  timer.setInterval(300000L, pullAndWriteData);
}

void loop()
{
  Blynk.run();
  timer.run(); // Initiates BlynkTimer
  timer.setInterval(900000L, sendMail);
  //timer.setInterval(60000L, sendMail); using for test (every minutes)
  timer.setInterval(86400000L, monitoring);
}
