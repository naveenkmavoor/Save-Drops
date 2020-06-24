#include "FirebaseESP8266.h"
#include <ESP8266WiFi.h>
#include<ESPDateTime.h>

#define FIREBASE_HOST "YOUR FIREBASE DATABASE LINK"
#define FIREBASE_AUTH "YOUR DATABASE SECREAT ID CODE"
#define WIFI_SSID "SSID"
#define WIFI_PASSWORD "PASSWORD"

#define FIREBASE_FCM_SERVER_KEY "FCM_SERVER_KEY"
#define FIREBASE_FCM_DEVICE_TOKEN_1 "FCM_DEVICE_TOKEN"

#define PULSE_PIN D6
#define RELAY_PIN D1
#define triggerpin D3
#define echopin D2

//Define FirebaseESP8266 data object
FirebaseData firebaseData1;
FirebaseData firebaseData2; 
FirebaseData firebaseData3;
 
FirebaseJson json;

int counter = 0 ;
boolean usensorActivate = true;
String path = "/users/OzOG7RmBSOfgebX6iLkAGi4RCy62";
float tankVolume, flowrate;
float tankLitres;
String motorstatus; 
int tankheight;
float radius;
float waterVolume;
float waterPercentage;

//flow sensor parameter
volatile long pulseCount=0;
float calibrationFactor = 4.5;
float flowRate;    
unsigned long oldTime;
int sendnotificationOnce = 0;

//ultrasonic parameter 
long duration;
int distance;
int waterlevel;
 
String newDateTime;  
  
  void setWifi(){
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    Serial.print("Connecting to Wi-Fi");
    while (WiFi.status() != WL_CONNECTED)
    {
      Serial.print(".");
      delay(300);
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();
  
  }
  
  void setDateTime(){
    DateTime.setTimeZone(5);
    DateTime.begin();
    if(!DateTime.isTimeValid()){
      Serial.println("Failed to get time from server");
      delay(300);
    }
  }
  
  void setFirebase(){
    Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
    Firebase.reconnectWiFi(true);
    firebaseData1.setBSSLBufferSize(1024, 1024);
  
   //Set the size of HTTP response buffers in the case where we want to work with large data.
    firebaseData1.setResponseSize(1024);
  
  
    //Set the size of WiFi rx/tx buffers in the case where we want to work with large data.
    firebaseData2.setBSSLBufferSize(1024, 1024);
  
    firebaseData2.setResponseSize(1024);
  }
  
  void setFCM(){
    firebaseData2.fcm.begin(FIREBASE_FCM_SERVER_KEY);
    firebaseData2.fcm.addDeviceToken(FIREBASE_FCM_DEVICE_TOKEN_1);
    firebaseData2.fcm.setPriority("high");
    firebaseData2.fcm.setTimeToLive(1000);
  }
  
  void streamCallback(StreamData data)
  {
  
    Serial.println("Stream Data1 available...");
    Serial.println("STREAM PATH: " + data.streamPath());
    Serial.println("EVENT PATH: " + data.dataPath());
    Serial.println("DATA TYPE: " + data.dataType());
    Serial.println("EVENT TYPE: " + data.eventType());
    Serial.print("VALUE: " + data.stringData());
    
     if(data.stringData() == "ON"){
      digitalWrite(RELAY_PIN, HIGH);
      usensorActivate = true;
     }else{
      digitalWrite(RELAY_PIN, LOW);
     }
  }
  
  void streamTimeoutCallback(bool timeout)
  {
    if (timeout)
    {
      Serial.println();
      Serial.println("Stream timeout, resume streaming...");
      Serial.println();
    }
  }
  
  void setVolumeofTank(){
     
      Serial.print("Fetching WaterTank Volume");
      while(!(Firebase.getFloat(firebaseData1, path + "/waterTankCapacity")) || firebaseData1.floatData() == 0){
        Serial.print(".");
        delay(1000);
      }
      Serial.println();
      Serial.print("WaterTank Volume Fetched : ");
      Serial.println(firebaseData1.floatData());
      tankLitres = firebaseData1.floatData();
      
     
  }
  
  
  void setTankHeight(){ 
       
      digitalWrite(triggerpin, HIGH);
      delay(1000);
      digitalWrite(triggerpin, LOW);
      duration = pulseIn(echopin, HIGH); 
      tankheight = duration * 0.034/2 ;
      if(Firebase.setInt(firebaseData1, path + "/tankHeight", tankheight)){
        Serial.println("Tank height set successfully");
      }else{
       Serial.println("Failed setting tank height");
      }
      
  }
void ICACHE_RAM_ATTR pulseCounter()
{
  pulseCount++;
}
 

void setup()
{
  pulseCount        = 0;
  flowRate          = 0.00; 
  oldTime           = 0;  

  Serial.begin(115200);
  pinMode(PULSE_PIN, INPUT); 
  pinMode(RELAY_PIN, OUTPUT);
  pinMode(triggerpin, OUTPUT);
  pinMode(echopin, INPUT);
  digitalWrite(RELAY_PIN, LOW);
  
    
  setWifi();
  setDateTime();
  setFirebase(); 
  setFCM();
  setVolumeofTank();
  setTankHeight();

  radius =sqrt((tankLitres * 1000)/(3.14 * tankheight));
   
   //streamCallback setup

  if (!Firebase.beginStream(firebaseData3,path + "/motorStatus"))
  {
    Serial.println("------------------------------------");
    Serial.println("Can't begin stream connection...");
    Serial.println("REASON: " + firebaseData3.errorReason());
    Serial.println("------------------------------------");
    Serial.println();
  }

  Firebase.setStreamCallback(firebaseData3, streamCallback, streamTimeoutCallback);
  attachInterrupt(PULSE_PIN, pulseCounter, FALLING);
}
 
 
void loop()
{ 
 
    if(!DateTime.isTimeValid()){
    Serial.println("Failed to fetch time from server ");
    DateTime.begin();
   }else{

    if((millis() - oldTime) > 1000){
      detachInterrupt(PULSE_PIN);
      flowRate = ((1000.0/(millis() - oldTime)) * pulseCount)/(calibrationFactor * 60); //L/Sec
      oldTime = millis();
      Serial.print( flowRate );
      Serial.println(" L/Sec"); 
      pulseCount = 0;
      attachInterrupt(PULSE_PIN, pulseCounter, FALLING);
      
    }

   

   if( flowRate != 0){  
      time_t t = DateTime.now();
      float thatdayflow = flowRate; 
      newDateTime =   DateFormatter::format("%Y-%m-%d", t);
//      Serial.println( DateFormatter::format("%Y-%m-%d %H:%M:%S", t));
      if(Firebase.getFloat(firebaseData2, path + "/flowSensorValue/" + newDateTime)){
       thatdayflow = flowRate + firebaseData2.floatData();
   } 
     Firebase.setFloat(firebaseData2, path + "/flowSensorValue/" + newDateTime, thatdayflow);
     if(sendnotificationOnce == 0){
      if(thatdayflow > 165){
        firebaseData2.fcm.setNotifyMessage("Save Drop", "Your Water Consumption is above the limit. Please control it. You can check usage statistics here.","firebase-logo.png","http://www.google.com");
        firebaseData2.fcm.setDataMessage("{\"myData\":\"myValue\"}");
        if(Firebase.sendMessage(firebaseData2, 0)){
        sendnotificationOnce = 1;
        Serial.println("PASSED");
        Serial.println(firebaseData2.fcm.getSendResult());
        Serial.println("------------------------------------");
        Serial.println();
        
      }else{
        Serial.println("FAILED");
        Serial.println("REASON: " + firebaseData1.errorReason());
        Serial.println("------------------------------------");
        Serial.println();
      }      
       } else{sendnotificationOnce = 0;}
   }
   }
    if(usensorActivate){
    
    digitalWrite(triggerpin, HIGH);
    delay(1000);
    digitalWrite(triggerpin, LOW);
    duration = pulseIn(echopin, HIGH);
    distance = duration * 0.034/2;
    Serial.print("Distance : ");
    Serial.println(distance);
    waterlevel = tankheight - distance;
    Serial.print("water level : ");
    Serial.println(waterlevel);
    
    if(waterlevel > 0 ){
    
     if(waterlevel < (tankheight*0.1)){ // PUSH NOTIFICATION WHEN WATERLEVEL IS BELOW 10%
      if(counter ==0){
        
     firebaseData2.fcm.setNotifyMessage("Save Drop", "Your Tank is running out of water, you can turn on the motor in here!","firebase-logo.png","http://www.google.com");
     firebaseData2.fcm.setDataMessage("{\"myData\":\"myValue\"}");
     if(Firebase.sendMessage(firebaseData2, 0)){
        
        Serial.println("PASSED");
        Serial.println(firebaseData2.fcm.getSendResult());
        Serial.println("------------------------------------");
        Serial.println();
        usensorActivate = false;
        counter++;
      }else{
        Serial.println("FAILED");
        Serial.println("REASON: " + firebaseData1.errorReason());
        Serial.println("------------------------------------");
        Serial.println();
      }
     }
     
  }else  if(waterlevel >= (tankheight*0.8)){// PULL NOTIFICATION WHEN WATER LEVEL IS ABOVE 90%  
     
      if(counter ==0){
        
      digitalWrite(RELAY_PIN, LOW);   
      Firebase.setString(firebaseData2, path + "/motorStatus", "OFF");  
      firebaseData2.fcm.setNotifyMessage("SeD", "Your tank is full, automatic motor shutdown completed!","firebase-logo.png", "http://www.google.com");
      firebaseData2.fcm.setDataMessage("{\"myData\":\"myValue\"}");
      if(Firebase.sendMessage(firebaseData2, 0)){
        
        Serial.println("PASSED");
        Serial.println(firebaseData1.fcm.getSendResult());
        Serial.println("------------------------------------");
        Serial.println();
        counter++;
        
      }else{
        Serial.println("FAILED");
        Serial.println("REASON: " + firebaseData1.errorReason());
        Serial.println("------------------------------------");
        Serial.println();
      }
     }
  }else{
    counter = 0;
    }
                                                
    if(Firebase.setInt(firebaseData2, path + "/waterLevel", waterlevel)){
      Serial.println("set WaterLevel success ");
    }else{
      Serial.println("Failed WaterLevel");
    }
    
    
    waterVolume = (3.14*radius*radius*waterlevel)/1000;    //applicable only for cylinder tanks , converting cm3 to Litre;
    waterPercentage =  (waterVolume/tankLitres) * 100 ;
    json.clear().add("waterinTank", waterVolume).add("WaterlevelPercentage", waterPercentage);  //amount of water in Litres
    if(Firebase.setJSON(firebaseData2, path + "/waterQuantity", json)){
      Serial.println(" set waterQuantity success ");
    }else{
      Serial.println("Failed");
    }
   } 

   }else{
      delay(1000);
   }
 
   
  }
}
