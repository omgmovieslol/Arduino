/*
Senior Design 
Spring 2010
Automated Adjustable Table

Rev. 1
 */


// inputs
const int leftSensorPin = 2;     // left sensor input
const int rightSensorPin = 5;    // right sensor input

// output to motors
const int leftSensorMotor = 3;   // left sensor motor
const int rightSensorMotor = 6;  // right sensor motor

//
//const int ledPin =  13;      // the number of the LED pin

// variables will change:
int buttonState = 0;         // variable for reading the pushbutton status

void setup() {
  // outputs
  pinMode(ledPin, OUTPUT);      
  
  // inputs
  pinMode(leftSensorPin, INPUT);     
  pinMode(rightSensorPin, INPUT);
}

void loop(){
  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);

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
