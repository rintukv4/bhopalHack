#include <ESP8266WiFi.h>
#include <WiFiClient.h> 
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>

const char* ssid = "Tenda";
const char* password = "";

int sensorPin = D4;
int val = 0;


void setup()
{
  WiFi.begin(ssid,password);
  Serial.begin(9600);
  while(WiFi.status()!=WL_CONNECTED)
  {
    Serial.print(".");
    delay(500);
  }
  Serial.print("\n");
  Serial.println("Wifi Connected");
  Serial.println("Access Your Content At:");
  Serial.print(WiFi.localIP());
  
  pinMode(sensorPin, INPUT);
}

/**
 * Main program loop
 */
void loop()
{
  HTTPClient https;
   if (WiFi.status() == WL_CONNECTED)
  {
      String postData, value;
      if(digitalRead(sensorPin) == LOW)
      {
        val = val + 1;
        Serial.println("Button Pressed");             // Output separator
        Serial.println(val);
        String url = ("http://192.168.30.101:8080/hosp/hosp.jsp?");
        
        url.concat("value=");
        url.concat(String(val));
        https.begin(url);
        int httpCode=https.GET();
        Serial.println(httpCode);
        if(httpCode>0)
        https.end();
        delay(2000);
        
      }
  }
}
