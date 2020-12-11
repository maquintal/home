/* Comment this out to disable prints and save space */
#define BLYNK_PRINT Serial


#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>
#include <Wire.h> // Library for I2C communication
#include <LiquidCrystal_I2C.h> // Library for LCD

// Wiring: SDA pin is connected to A4 and SCL pin to A5.
// Connect to LCD via I2C, default address 0x27 (A0-A2 not jumpered)
LiquidCrystal_I2C lcd = LiquidCrystal_I2C(0x27, 20, 4); // Change to (0x27,16,2) for 16x2 LCD.

// You should get Auth Token in the Blynk App.
// Go to the Project Settings (nut icon).
char auth[] = "U-zQXrRDuQ6taLOWfWVOZrgJTCLa3Zde";

// Your WiFi credentials.
// Set password to "" for open networks.
char ssid[] = "BELL950";
char pass[] = "POUDLARD7438";

// This function will be called every time Slider Widget
// in Blynk app writes values to the Virtual Pin V1
BLYNK_WRITE(V5)
{
  int pinValue = param.asInt(); // assigning incoming value from pin V1 to a variable

  // process received value
  Serial.println(pinValue);
  
  lcd.setCursor(0, 0); // Set the cursor on the first column and first row.
  lcd.print("pin value");
  lcd.setCursor(10, 0);
  lcd.print(pinValue); // Print the string "Hello World!"
  lcd.setCursor(2, 1); //Set the cursor on the third column and the second row (counting starts at 0!).
  lcd.print("LCD tutorial");

  
  // set the display to automatically scroll:
  //lcd.autoscroll();
  //while (pinValue = 1) {
  //  for (int thisChar = 0; thisChar < 16; thisChar++) {
  //    lcd.scrollDisplayLeft();  
  //    delay(500);
  //  }
  //}
}

void setup() {
  // put your setup code here, to run once:
  // Debug console
  Serial.begin(9600);

  Blynk.begin(auth, ssid, pass);

  //Wire.begin(D2, D1);
  //lcd.begin();
  //lcd.home();
  //lcd.print("Hello, NodeMCU");
    // Initiate the LCD:
  lcd.init();
  lcd.backlight();

        // Print 'Hello World!' on the first line of the LCD:
  lcd.setCursor(0, 0); // Set the cursor on the first column and first row.
  lcd.print("any thing"); // Print the string "Hello World!"
  lcd.setCursor(2, 1); //Set the cursor on the third column and the second row (counting starts at 0!).
  lcd.print("LCD tutorial");

}

void loop() {
  // put your main code here, to run repeatedly:
  Blynk.run();  
}
