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
const int rightTableMotor = 9;   // move table to the right


const int ledPin = 13;           // testing pin

// user defined
const int sampleRate = 200;      // sampling rate in ms. original idea was 200 ms
const int sensorMotorLength = 50;  // how long the motor should be activated when moving sensor motors
const int tableMotorLength = 50; // how long the table motor should be activated to move it
const int delayRate = 100;       // how long between movements. think immediate running is causing a glitch or something


// VARIABLES
int leftStatus = 0;              // status of the left sensor
int rightStatus = 0;             // status of the right sensor
int setupDone = 0;               // status of the setup
int setupCount = 0;              // number of times the sensors failed. 5 requires a resetup.



// testing ctrl-c ctrl-v's
// digitalWrite(ledPin, HIGH);
// digitalWrite(ledPin, LOW);

void setup() {
  // outputs
  pinMode(leftSensorMotor, OUTPUT);      
  pinMode(rightSensorMotor, OUTPUT);
  
  pinMode(leftTableMotor, OUTPUT);
  pinMode(rightTableMotor, OUTPUT);
  
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
    delay(sensorMotorLength);
    digitalWrite(leftSensorMotor, LOW);
    delay(delayRate);
  }
  
  // setup right sensor placement
  while(digitalRead(rightSensorPin) == HIGH) {
    digitalWrite(rightSensorMotor, HIGH); 
    delay(sensorMotorLength);
    digitalWrite(rightSensorMotor, LOW); 
    delay(delayRate);
  }
  
  setupDone = 1;
  setupCount = 0;
  
  // sensors are in correct positions
}


// table movement functions
// probably should use PWM
void moveLeft() {
  leftStatus = digitalRead(leftSensorPin);
  //rightStatus = digitalRead(rightSensorPin); // i 
  // moves until is the sen  sor stops sensing an object
  while(leftStatus == HIGH) {
    digitalWrite(leftTableMotor, HIGH);
    delay(tableMotorLength);
    digitalWrite(leftTableMotor, LOW);
    delay(delayRate);
    leftStatus = digitalRead(leftSensorPin);
  }
}
void moveRight() {
  //leftStatus = digitalRead(leftSensorPin);
  rightStatus = digitalRead(rightSensorPin);
  while(rightStatus == HIGH) {
    digitalWrite(rightTableMotor, HIGH);
    delay(tableMotorLength);
    digitalWrite(rightTableMotor, LOW);
    delay(delayRate);
    rightStatus = digitalRead(rightSensorPin);
  }
}

// main()
void loop(){
  
  // setup the motor placement
  if(!setupDone || setupCount >= 5) {
    motorSetup();
  }
  
  // move table if sensors detect object
  leftStatus = digitalRead(leftSensorPin);
  rightStatus = digitalRead(rightSensorPin);
  
  // if both sensors are activated, something is wrong.
  // it might be fixed with time. if not resetup the sensors
  if(leftStatus == HIGH && rightStatus == HIGH) {
    setupCount++;
  }
  else if(leftStatus == HIGH) {
    moveLeft();
  }
  else if(rightStatus == HIGH) {
    moveRight();
  }
  
  // not really sample rate due to time doing above calculations
  // but close enough
  delay(sampleRate);

}
