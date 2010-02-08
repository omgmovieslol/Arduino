/*
Senior Design 
Spring 2010
Automated Adjustable Table
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
//const int ledPin =  13;      // the number of the LED pin


// VARIABLES
int buttonState = 0;         // variable for reading the pushbutton status



void setup() {
  // outputs
  pinMode(leftSensorMotor, OUTPUT);      
  pinMode(rightSensorMotor, OUTPUT);
  
  // inputs
  pinMode(leftSensorPin, INPUT);     
  pinMode(rightSensorPin, INPUT);
}

void loop(){
  
  // sensors are on motors to move
  
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

  // check if the pushbutton is pressed.
  // if it is, the buttonState is HIGH:
  if (buttonState == HIGH) {     
    // turn LED on:    
    digitalWrite(ledPin, HIGH);  
  } 
  else {
    // turn LED off:
    digitalWrite(ledPin, LOW); 
  }
}
