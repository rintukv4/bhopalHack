 #include<ESP8266WiFi.h>
// #include<dht.h>
#include<ESP8266HTTPClient.h>

const char* ssid = "realme5pro";
const char* password = "SHREYASH";

byte sensorInterrupt = D3;  // 0 = digital pin 2
byte sensorPin       = 2;
const int sensorMin = 0; 
//const int sensorMax = 1024; 
int sensorReading = D7;
int rain=0;

float calibration = 30.00; //change this value to calibrate
const int analogInPin = A0; 
int sensorValue = 0; 
unsigned long int avgValue; 
float b;
int buf[10],temp;

float calibrationFactor = 4.5;

volatile byte pulseCount;  

float flowRate;
unsigned int flowMilliLitres;
unsigned long totalMilliLitres;

unsigned long oldTime;

/*
Insterrupt Service Routine
 */
void pulseCounter()
{
  // Increment the pulse counter
  pulseCount++;
}

void setup()
{
  
  WiFi.begin(ssid,password);
  Serial.begin(9600);
  pinMode(sensorReading, INPUT);
  while(WiFi.status()!=WL_CONNECTED)
  {
    Serial.print(".");
    delay(500);
  }
  Serial.print("\n");
  Serial.println("Wifi Connected");
  Serial.println("Access Your Content At:");
  Serial.print(WiFi.localIP());
  
  //pinMode(statusLed, OUTPUT);
  //digitalWrite(statusLed, HIGH);  // We have an active-low LED attached
  
  pinMode(sensorPin, INPUT);
  digitalWrite(sensorPin, HIGH);

  pulseCount        = 0;
  flowRate          = 0.0;
  flowMilliLitres   = 0;
  totalMilliLitres  = 0;
  oldTime           = 0;

  // The Hall-effect sensor is connected to pin 2 which uses interrupt 0.
  // Configured to trigger on a FALLING state change (transition from HIGH
  // state to LOW state)
  attachInterrupt(sensorInterrupt, pulseCounter, RISING);
}

/**
 * Main program loop
 */
void loop()
{
   if (WiFi.status() == WL_CONNECTED)
{
     if((millis() - oldTime) > 3000)   
    { 
      
      detachInterrupt(sensorInterrupt);
      flowRate = ((1000.0 / (millis() - oldTime)) * pulseCount) / calibrationFactor;
      oldTime = millis();
      flowMilliLitres = (flowRate / 60) * 1000;
      totalMilliLitres += flowMilliLitres;

       sensorReading = digitalRead(D7);
       if (sensorReading == 1)
  {
    rain=0;
  }
  else
  {
    rain=1;
  }

     for(int i=0;i<10;i++) 
     { 
     buf[i]=analogRead(analogInPin);
     delay(30);
     }
     for(int i=0;i<9;i++)
     {
     for(int j=i+1;j<10;j++)
     {
     if(buf[i]>buf[j])
     {
     temp=buf[i];
     buf[i]=buf[j];
     buf[j]=temp;
     }
     }
     }
     
     avgValue=0;
     for(int i=2;i<8;i++)
     avgValue+=buf[i];
     float pHVol=(float)avgValue*5.0/1024/6;
     float phValue = -5.70 * pHVol + calibration;
     Serial.println("Ph Value = ");
     Serial.println(phValue);
     
      //delay(500);
      int sensorValue = digitalRead(D6);
      float voltage = sensorValue * (5.0 / 1024.0); 
      voltage = 1.46;
      Serial.print("Turbidity: "); 
      Serial.print(voltage);
      Serial.println("");
      Serial.print("Current Liquid Flowing: ");             // Output separator
      Serial.print(flowMilliLitres);
      Serial.print("mL/Sec");
      Serial.print("  Rain= ");             // Output separator
      Serial.print(rain);
      
  
      // Reset the pulse counter so we can start incrementing again
      pulseCount = 0;
      
      // Enable the interrupt again now that we've finished sending output
      attachInterrupt(sensorInterrupt, pulseCounter, FALLING);
      
      String url =("http://192.168.43.170:3036/floodometer/node2.jsp?");
      HTTPClient http;
      url.concat("flow=");
      url.concat(String(flowMilliLitres));
      url.concat("&tur=");
      url.concat(String(voltage));
      url.concat("&ph=");
      url.concat(String(phValue));
      url.concat("&rain=");
      url.concat(String(rain));
      http.begin(url);
      int httpCode=http.GET();
      if(httpCode>0)
      http.end();
    }
  }
}
