/*
Senior Design 
Spring 2010
Automated Adjustable Table

James Wilson
 */


// CONSTANTS

// inputs
const int leftSensorPin = 2;     // left sensor input
const int rightSensorPin = 5;    // right sensor input

// output to motors
const int leftSensorMotor = 3;   // left sensor motor
const int rightSensorMotor = 6;  // right sensor motor

const int leftTableMotor = 8;    // move table to the left
const int tableRightMotor = 9;   // move table to the right

//
//const int ledPin =  13;        // the number of the LED pin


// VARIABLES
int leftStatus = 0;              // status of the left sensor
int rightStatus = 0;             // status of the right sensor
int setupDone = 0;               // status of the setup



void setup() {
  // outputs
  pinMode(leftSensorMotor, OUTPUT);      
  pinMode(rightSensorMotor, OUTPUT);
  
  // inputs
  pinMode(leftSensorPin, INPUT);     
  pinMode(rightSensorPin, INPUT);
}

void motorSetup() {
  // sensors are on motors to move into correct position
  // they move out until they stop sensing 
  // the sensors then measure if the person moves in front of the sensors
  
  // setup left sensor placement
  while(digitalRead(leftSensorPin) == HIGH) {
    digitalWrite(leftSensorMotor, HIGH);
    delay(50);
    digitalWrite(leftSensorMotor, LOW);
  }
  
  // setup right sensor placement
  while(digitalRead(rightSensorPin) == HIGH) {
    digitalWrite(rightSensorMotor, HIGH);
    delay(50);
    digitalWrite(rightSensorMotor, LOW);
  }
  
  // sensors are in correct positions
}

void loop(){
  
  // setup the motor placement
  if(!setupDone) {
    motorSetup();
  }
  // move table if sensors detect object
  
  
 
    
}
