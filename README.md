
# Save-Drop-App
A smart water management application
<p align="center">
  <img src="app screenshots/2_login_screen.jpg" height="450em" title="hover text">
  <img src="app screenshots/3_home_screen.jpg" height="450em" title= "home screen">
  <img src="app screenshots/4_usage_screen.jpg" height="450em" title="hover text">
</p>

 
## About the project 

 
## Inspiration
I really want to make an IoT App that can make an impact on our lives. I thought what about an app that can track our day-to-day consumption of water in our household and alert if we consume more that day. Through this, we can conserve the use of water effectively without wasting it unnecessarily. 

## What it does
This app will track our day-to-day consumption of water in our household and alert us if we consume more that day. It comes with controlling the motor to pump water into the tank. The app notifies the user when the water level is low and the user can turn on the motor. The motor will shut down automatically when the water gets fully filled in the tank with the help of sensors attached so the user doesn't need to bother about turning off the motor. It shows the real-time water level in the tank and can calculate the water bill according to the consumption if required. Plot visual graph to show the statistics of water consumption on a daily, monthly, and yearly basis.

## How I built it
This app is built using a cross-platform framework for the mobile applications named Flutter and backend as a service API named Firebase. The language used to run the microcontroller is C++ in Arduino IDE. 

## Challenges I ran into
The first challenge was that I'm building an IoT device for the first time so i struggled with the esp8266 wifi module microcontroller quite a bit and wasn't sure I can able to set up the circuit connection and program codes for controlling the sensor properly then I get used to it by doing small programs like blinking led then slowly practiced on different sensors. 

The second was with the user interface of the app. I don't know anything about the strategy of designing an app with tutorials I did some sample design apps and get into the dribble website and found out a matching design for our app. 

The third was with the protocol which can be used to connect with the Microcontroller(HTTP or MQTT). so I started with Mqtt protocol and it works fine but the problem is that I don't know about the backend development so my only way is to stick with a backend API service called firebase and it supports only HTTP so I got to go with HTTP. 

The fourth was the development of an algorithm that needs to automatically calculates then the parameters of the household water tank like the height and radius(assuming a cylindrical shaped tank) for calculating the volume of water and water level in the tank and update into the user's app. Then user only needs to enter the volume of the tank when logging into the app for the first time. The algorithm needs to set in two ways:- 1) The sensor needs to work only when the user enters the volume of the tank. 2) Then the sensor needs to be in an idle state when the water level is low. 3) Calculate the water level and volume in real-time from the tank volume taken from the user. 4) Send push notification from microcontroller to the app when the water level is high or low in the tank. 5) Calculate the flow of water through the pipeline in L/s and find the total water consumed. 

## Accomplishments that I'm proud of
The journey from the idea creation to building it is something that can be really proud of and one of my great accomplishment. 

## What I learned
Proficient in UI/UX design for enhancing the visual experience of mobile applications, skilled in Flutter framework and Google Firebase real-time database integration, and experienced in interfacing with Microcontroller ESP8266 WiFi module and various sensors including flow meter, relay switch, and Ultrasonic sensor. Successfully developed an algorithm to ensure proper functioning of sensors and seamless interaction with the mobile application.

## What's next for Save-Drops
Refactor state management of the code base from ScopedModel to Bloc pattern.
Implemented a machine learning-based feature that accurately predicts daily, monthly, and yearly water consumption in a mobile application. Users can set their desired daily water intake, and the app sends a reward notification upon achieving the goal.
