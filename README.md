
# Save-Drop-App
A smart water management application
<p align="center">
  <img src="app screenshots/2_login_screen.jpg" width="350" title="hover text">
  <img src="app screenshots/3_home_screen.jpg" width="350" title= "home screen">
  <img src="app screenshots/4_usage_screen.jpg" width="350" title="hover text">
</p>

 
## About the project 


## Inspiration
I really want to make an IoT App that can make an impact on our lives. I thought what about an app that can track our day to day consumption of water in our household and alert if we consume more that day. Through this we can conserve the use of water effectively without wasting it unnecessarily. 

## What it does
This app will track our day to day consumption of water in our household and alert if we consume more that day. It comes with controlling the motor to pump water into the tank. The app notify the user when the water level is low and the user can turn on the motor. The motor will shut down automatically when the water gets fully filled in the tank with the help of sensors attached so the user don't need to bother about turning off the motor. It shows real-time water level in tank and can calculate the water bill according to the consumption if required. Plot visual graph to show the statistics of water consuming per daily, monthly and yearly basis. 

## How I built it
This app is built using a cross platform framework for mobile application named flutter and backend as a service api named firebase. The language that used to run the microcontroller is c++ in arduino ide. 

## Challenges I ran into
The first challenge was that I'm building an IoT device for the first time so i struggled with the  esp8266 wifi module microcontroller quite a bit and wasn't sure I can able to setup the circuit connection and program codes for controlling sensor properly then I get used to the it by doing small programs like blinking led then slowly practised on different sensors. 

The second was with the user interface of the app. I don't know anything about the strategy of designing an app with tutorials I did some sample design apps and get into dribble website and found out a matching design for our app. 

The third was with the protocol which can be use to connect with the Microcontroller(http or Mqtt). so i started with Mqtt protocol and it works fine but the problem is that I don't know about the backend development so my only way is to stick with a backend api service called firebase and it supports only http so I got to go with http. 

Then fourth was the development of an algorithm that need to automatically calculates then the parameters of household water tank like the height and radius(assuming a cylinderical shaped tank) for calculating the volume of water and water level in tank and update into the user's app. Then user only need to enter the volume of the tank when logging into the app for the first time. The algorithm needs to set in two ways:- 1) The sensor need to work only when the user enter the volume of tank. 2) Then sensor need to be in idle state when the water level is low. 3) Calculate the water level and volume in real-time from the tank volume taken from the user. 4) Send push notification from microcontroller to the app when water level is high or low in tank. 5) Calculate the flow of water through pipeline in L/s and find the total water consumed. 

## Accomplishments that I'm proud of
The journey from the idea creation to building it is something that can be really proud of and one of my great accomplishment. 

## What I learned
Learned about some ui/ux skills that needed for an app for better visual experience, get to know more about flutter framework and Google firebase real-time database and Interfacing with Microcontroller esp8266 wifi module and sensors like flow meter, relay switch, Ultrasonic sensor and developed an algorithm for the proper functioning of sensors and interacting the app. 

## What's next for Save-Drops
Need to add a feature that predicts the consumption of water that day, month and year using a machine learning model.
The user can set the values for how much water need to be consumed in a day and when achieved the gives a reward notification to the user. Sign up page
A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
 
