/*
Senior Design 
Spring 2010
Automated Adjustable Table

James Wilson
*/

/*
TODO:
Front and back movement
Reset table and sensor at end

*/

// CONSTANTS

// inputs
const int leftSensorPin = 12;     // left sensor input
const int rightSensorPin = 5;    // right sensor input

const int resetSensor = 11;      // table left/right reset sensor

const int analogSensor = 0;      // front/back sensor. Uses analog measurement

// output to motors
const int leftSensorMotor = 3;   // left sensor motor
const int leftSensorReset = 4;   // left sensor motor reverse direction
const int rightSensorMotor = 6;  // right sensor motor
const int rightSensorReset = 7;  // right sensor motor reverse direction

const int leftTableMotor = 8;    // move table to the left
const int rightTableMotor = 9;   // move table to the right

const int frontTableMotor = 10;  // move table to the front
const int backTableMotor = 13;   // move table to the back



const int ledPin = 13;           // testing pin

// user defined
const int sampleRate = 200;      // sampling rate in ms. original idea was 200 ms
const int sensorMotorLength = 250;// how long the motor should be activated when moving sensor motors
const int tableMotorLength = 200;// how long the table motor should be activated to move it
const int delayRate = 0;         // how long between movements.
                                 // 0 for a no-op, I guess


const int resetThreshold = 200;  // reset sensor threshold. analog value allowing it to detect the table

// VARIABLES
int leftStatus = 0;              // status of the left sensor
int rightStatus = 0;             // status of the right sensor
int setupDone = 0;               // status of the setup
int setupCount = 0;              // number of times the sensors failed. 5 requires a resetup.
int analogValue = 0;             // starting value of the analog sensor
int analogCurrent = 0;           // current analog value. compared to analogValue
int leftSensorMoves = 0;         // number of times the left sensors have moved. to reset to original position.
int rightSensorMoves = 0;        // number of times right sensor moved.
int resetStatus = 0;
boolean onReset = true;



// testing ctrl-c ctrl-v's
// digitalWrite(ledPin, HIGH);
// digitalWrite(ledPin, LOW);

void setup() {
  // outputs
  pinMode(leftSensorMotor, OUTPUT);      
  pinMode(rightSensorMotor, OUTPUT);
  
  pinMode(leftTableMotor, OUTPUT);
  pinMode(rightTableMotor, OUTPUT);
  
  // front and back motor pins weren't setup
  // could be causing the problem with front back movement
  pinMode(frontTableMotor, OUTPUT);
  pinMode(backTableMotor, OUTPUT);
  
  pinMode(leftSensorReset, OUTPUT);
  pinMode(rightSensorReset, OUTPUT);
  
  //pinMode(resetSensor, INPUT);
  
  // don't declare analog input. it's always an input
  
  // inputs
  pinMode(leftSensorPin, INPUT);     
  pinMode(rightSensorPin, INPUT);
  pinMode(resetSensor, INPUT);
  
  analogValue = analogRead(analogSensor);
  
  attachInterrupt(0, reset, FALLING);  
  
  Serial.begin(9600);
}

void reset() {
  Serial.println("reset pressed");
  if(!onReset) {
    Serial.println("resetting everything");
    onReset = true;
    
    // move table all the way back
    // just start moving the table at the beginnning
    // it'll automatically stop moving when it hit the limit
    digitalWrite(backTableMotor, HIGH);
    Serial.println("moving table back");
    
    resetStatus = digitalRead(resetSensor);
    // move the table back to original left right position
    if(resetStatus == HIGH) {
      Serial.println("moving table right");
      while(resetStatus == HIGH) {
        digitalWrite(rightTableMotor, HIGH);
        //delay(tableMotorLength);
        //digitalWrite(rightTableMotor, LOW);
        //Serial.println("table right stop");
        //delay(delayRate);
        resetStatus = digitalRead(resetSensor);
      }
      digitalWrite(rightTableMotor, LOW);
    }
    else {
      Serial.println("moving table left");
      while(resetStatus == LOW) {
        digitalWrite(leftTableMotor, HIGH);
        //delay(tableMotorLength);
        //digitalWrite(leftTableMotor, LOW);
        //Serial.println("table left stop");
        //delay(delayRate);
        resetStatus = digitalRead(resetSensor);
      }
      digitalWrite(leftTableMotor, LOW);
    }
    
    // reset sensors back to original position
    Serial.println("moving left sensor");
    for(int i=0; i<leftSensorMoves; i++) {
      digitalWrite(leftSensorReset, HIGH);
      //delay(sensorMotorLength);
      digitalWrite(leftSensorReset, LOW);
      //delay(delayRate);
    }
    digitalWrite(leftSensorReset, LOW);
    Serial.println("moving right sensor");
    for(int i=0; i<rightSensorMoves; i++) {
      digitalWrite(rightSensorReset, HIGH);
      //delay(sensorMotorLength);
      //digitalWrite(rightSensorReset, LOW);
      //delay(delayRate);
    }
    digitalWrite(rightSensorReset, LOW);
    
    Serial.println("stopping back movement");
    digitalWrite(backTableMotor, LOW);
    
    // just in case something weird happens, the table won't try to do front and back to where it was
    analogValue = analogRead(analogSensor);
    
    for(int i=0; i<1000; i++) {
      Serial.println("waiting...");
    }
    Serial.println("stopping back movement");
    digitalWrite(backTableMotor, LOW);
    
    Serial.println("reset done");
    
    //delay(1000);
    
    
  } else {
    // second reset press
    // start the automation again
    Serial.println("automation begin");
    onReset = false;
    for(int i=0; i<1000; i++) {
      Serial.println("waiting...");
    }
    //delay(100);  
    Serial.println("done delay");
  }
  
  
  
}

void motorSetup() {
  // sensors are on motors to move into correct position
  // they move out until they stop sensing 
  // the sensors then measure if the person moves in front of the sensors
  
  // setup left sensor placement
  digitalWrite(leftSensorReset, LOW);
  while(digitalRead(leftSensorPin) == HIGH) {
    digitalWrite(leftSensorMotor, HIGH);
    delay(sensorMotorLength);
    digitalWrite(leftSensorMotor, LOW);
    leftSensorMoves++;
    delay(delayRate);
  }
  
  // setup right sensor placement
  digitalWrite(rightSensorReset, LOW);
  while(digitalRead(rightSensorPin) == HIGH) {
    digitalWrite(rightSensorMotor, HIGH); 
    delay(sensorMotorLength);
    digitalWrite(rightSensorMotor, LOW);
    rightSensorMoves++; 
    delay(delayRate);
  }
  
  analogValue = analogRead(analogSensor);
  
  setupDone = 1;
  setupCount = 0;
  
  // sensors are in correct positions
}


// table movement functions
// probably should use PWM
void moveLeft() {
  leftStatus = digitalRead(leftSensorPin);
  // moves until is the sensor stops sensing an object
  while(leftStatus == HIGH) {
    if(digitalRead(rightSensorPin) == HIGH) break;
    digitalWrite(leftTableMotor, HIGH);
    delay(tableMotorLength);
    digitalWrite(leftTableMotor, LOW);
    delay(delayRate);
    leftStatus = digitalRead(leftSensorPin);
  }
}
void moveRight() {
  rightStatus = digitalRead(rightSensorPin);
  while(rightStatus == HIGH) {
    if(digitalRead(leftSensorPin) == HIGH) break;
    digitalWrite(rightTableMotor, HIGH);
    delay(tableMotorLength);
    
    
    digitalWrite(rightTableMotor, LOW);
    delay(delayRate);
    rightStatus = digitalRead(rightSensorPin);
  }
}


void moveFront() {
  analogCurrent = analogRead(analogSensor);
  digitalWrite(backTableMotor, LOW);
  while(analogCurrent <= analogValue) {
    digitalWrite(frontTableMotor, HIGH);
    delay(tableMotorLength);
    digitalWrite(frontTableMotor, LOW);
    delay(delayRate);
    analogCurrent = analogRead(analogSensor);
    //Serial.println("moving forward");
  }
  analogValue = analogRead(analogSensor);
}
void moveBack() {
  analogCurrent = analogRead(analogSensor);
  digitalWrite(frontTableMotor, LOW);
  while(analogCurrent >= analogValue) {
    digitalWrite(backTableMotor, HIGH);
    delay(tableMotorLength);
    digitalWrite(backTableMotor, LOW);
    delay(delayRate);
    analogCurrent = analogRead(analogSensor);
    //Serial.println("moving back");
  }
  analogValue = analogRead(analogSensor);
}

// main()
void loop(){
  
  if(!onReset) {
  Serial.println("automating....");
  // setup the motor placement
  //if(true) {
  if(!setupDone || setupCount >= 5) {
    motorSetup();
  }
 
 
 
 
 
  
  // move table if sensors detect object
  leftStatus = digitalRead(leftSensorPin);
  rightStatus = digitalRead(rightSensorPin);
  analogCurrent = analogRead(analogSensor);
  
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
  
  if(analogCurrent*1.1 < analogValue) {
    moveFront();
  }
  else if(analogCurrent*.9 > analogValue) {
    moveBack();
  }
  //Serial.println(analogCurrent);
  
  }
  
  // not really sample rate due to time doing above calculations
  // but close enough
  delay(sampleRate);

}
