
# Save-Drop-App
A smart water management application
<p align="center">
  <img src="app screenshots/2_login_screen.jpg" width="350" height="450" title="hover text">
  <img src="app screenshots/3_home_screen.jpg" width="350" height="450" title= "home screen">
  <img src="app screenshots/4_usage_screen.jpg" width="350" height="450" title="hover text">
</p>

 
## About the project 

 
## Inspiration
I really want to make an IoT App that can make an impact on our lives. I thought what about an app that can track our day-to-day consumption of water in our household and alert if we consume more that day. Through this, we can conserve the use of water effectively without wasting it unnecessarily. 

## What it does
This app will track our day-to-day consumption of water in our household and alert us if we consume more that day. It comes with controlling the motor to pump water into the tank. The app notifies the user when the water level is low and the user can turn on the motor. The motor will shut down automatically when the water gets fully filled in the tank with the help of sensors attached so the user doesn't need to bother about turning off the motor. It shows the real-time water level in the tank and can calculate the water bill according to the consumption if required. Plot visual graph to show the statistics of water consumption on a daily, monthly, and yearly basis.

## How I built it
This app is built using a cross-platform framework for the mobile applications named flutter and backend as a service API named firebase. The language used to run the microcontroller is c++ in Arduino IDE. 

## Challenges I ran into
The first challenge was that I'm building an IoT device for the first time so i struggled with the  esp8266 wifi module microcontroller quite a bit and wasn't sure I can able to set up the circuit connection and program codes for controlling the sensor properly then I get used to it by doing small programs like blinking led then slowly practiced on different sensors. 

The second was with the user interface of the app. I don't know anything about the strategy of designing an app with tutorials I did some sample design apps and get into the dribble website and found out a matching design for our app. 

The third was with the protocol which can be used to connect with the Microcontroller(HTTP or MQTT). so I started with Mqtt protocol and it works fine but the problem is that I don't know about the backend development so my only way is to stick with a backend API service called firebase and it supports only HTTP so I got to go with HTTP. 

The fourth was the development of an algorithm that needs to automatically calculates then the parameters of the household water tank like the height and radius(assuming a cylindrical shaped tank) for calculating the volume of water and water level in the tank and update into the user's app. Then user only needs to enter the volume of the tank when logging into the app for the first time. The algorithm needs to set in two ways:- 1) The sensor needs to work only when the user enters the volume of the tank. 2) Then the sensor needs to be in an idle state when the water level is low. 3) Calculate the water level and volume in real-time from the tank volume taken from the user. 4) Send push notification from microcontroller to the app when the water level is high or low in the tank. 5) Calculate the flow of water through the pipeline in L/s and find the total water consumed. 

## Accomplishments that I'm proud of
The journey from the idea creation to building it is something that can be really proud of and one of my great accomplishment. 

## What I learned
Learned about some UI/UX skills that needed for an app for the better visual experience, get to know more about flutter framework and Google firebase real-time database and Interfacing with Microcontroller esp8266 wifi module and sensors like flow meter, relay switch, Ultrasonic sensor and developed an algorithm for the proper functioning of sensors and interacting the app. 

## What's next for Save-Drops
Need to add a feature that predicts the consumption of water that day, month, and year using a machine learning model.
The user can set the values for how much water needs to be consumed in a day and when achieved the gives a reward notification to the user.
