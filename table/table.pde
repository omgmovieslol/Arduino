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
const int leftSensorPin = 13;    // left sensor input
                                 // to allow the interrupt from the reset pin, which requires either pin 2 or 3, so using pin 2
const int rightSensorPin = 5;    // right sensor input

//const int resetSensor = 13;      // table left/right reset sensor
const int resetSensor = 1;       // reset sensor is going to be an analog input, since we're running out of digital I/O ports

const int analogSensor = 0;      // front/back sensor. Uses analog measurement



// output to motors
const int leftSensorMotor = 3;   // left sensor motor
const int leftSensorReset = 4;   // left sensor motor reverse direction
const int rightSensorMotor = 6;  // right sensor motor
const int rightSensorReset = 7;  // right sensor motor reverse direction

const int leftTableMotor = 8;    // move table to the left
const int rightTableMotor = 9;   // move table to the right

const int frontTableMotor = 10;  // move table to the front
const int backTableMotor = 11;   // move table to the back



const int ledPin = 13;           // testing pin

// user defined
const int sampleRate = 200;      // sampling rate in ms. original idea was 200 ms
const int sensorMotorLength = 250;// how long the motor should be activated when moving sensor motors
const int tableMotorLength = 200;// how long the table motor should be activated to move it
const int delayRate = 0;         // how long between movements.
                                 // 0 for a no-op, I guess. though the compiler should remove it
                                 
const int resetThreshold = 100;  // reset sensor threshold. analog value allowing it to detect the table



// VARIABLES
int leftStatus = 0;              // status of the left sensor
int rightStatus = 0;             // status of the right sensor
int setupDone = 0;               // status of the setup
int setupCount = 0;              // number of times the sensors failed. 5 requires a resetup.
int analogValue = 0;             // starting value of the analog sensor
int analogCurrent = 0;           // current analog value. compared to analogValue
int leftSensorMoves = 0;         // number of times the left sensors have moved. to reset to original position.
int rightSensorMoves = 0;        // number of times right sensor moved.
boolean onReset = false;
boolean startReady = false;



// testing ctrl-c ctrl-v's
// digitalWrite(ledPin, HIGH);
// digitalWrite(ledPin, LOW);

void setup() {
  // outputs
  pinMode(leftSensorMotor, OUTPUT);      
  pinMode(rightSensorMotor, OUTPUT);
  
  pinMode(leftTableMotor, OUTPUT);
  pinMode(rightTableMotor, OUTPUT);
  
  pinMode(leftSensorReset, OUTPUT);
  pinMode(rightSensorReset, OUTPUT);
  
  pinMode(resetSensor, INPUT);
  
  // don't declare analog input. it's always an input
  
  // inputs
  pinMode(leftSensorPin, INPUT);     
  pinMode(rightSensorPin, INPUT);
  
  // this is for the reset button. 
  // it will move the table back to the center
  // move the sensors back to their starting locations, hopefully
  attachInterrupt(0, reset, RISING);  
  
  
  analogValue = analogRead(analogSensor);
}

void reset() {
  //TODO: to the reset routine
  
  if(!onReset) {
    onReset = true;
    
    // move table all the way back
    // just start moving the table at the beginnning
    // it'll automatically stop moving when it hit the limit
    digitalWrite(backTableMotor, HIGH);
    
    // move the table back to original left right position
    if(analogRead(resetSensor) > resetThreshold) {
      while(analogRead(resetSensor) > resetThreshold) {
        digitalWrite(leftTableMotor, HIGH);
        delay(tableMotorLength);
        digitalWrite(leftTableMotor, LOW);
        delay(delayRate);
      }
    }
    else {
      while(analogRead(resetSensor) < resetThreshold) {
        digitalWrite(rightTableMotor, HIGH);
        delay(tableMotorLength);
        digitalWrite(rightTableMotor, LOW);
        delay(delayRate);
      }
    }
    
    // reset sensors back to original position
    for(int i=0; i<leftSensorMoves; i++) {
      digitalWrite(leftSensorReset, HIGH);
      delay(sensorMotorLength);
      digitalWrite(leftSensorReset, LOW);
      delay(delayRate);
    }
    for(int i=0; i<rightSensorMoves; i++) {
      digitalWrite(rightSensorReset, HIGH);
      delay(sensorMotorLength);
      digitalWrite(rightSensorReset, LOW);
      delay(delayRate);
    }
    
    
    digitalWrite(backTableMotor, LOW);
    
    // just in case something weird happens, the table won't try to do front and back to where it was
    analogValue = analogRead(analogSensor);
    
    
  } else {
    onReset = false;
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
  //rightStatus = digitalRead(rightSensorPin); // i 
  // moves until is the sen  sor stops sensing an object
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
  //leftStatus = digitalRead(leftSensorPin);
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
  while(analogCurrent <= analogValue) {
    digitalWrite(frontTableMotor, HIGH);
    delay(tableMotorLength);
    digitalWrite(frontTableMotor, LOW);
    delay(delayRate);
    analogCurrent = analogRead(analogSensor);
  }
}
void moveBack() {
  analogCurrent = analogRead(analogSensor);
  while(analogCurrent >= analogValue) {
    digitalWrite(backTableMotor, HIGH);
    delay(tableMotorLength);
    digitalWrite(backTableMotor, LOW);
    delay(delayRate);
    analogCurrent = analogRead(analogSensor);
  }
}

// main()
void loop(){
  
  if(!onReset && startReady) {
  
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
    
    /*if(analogCurrent*1.05 < analogValue) {
      moveFront();
    }
    else if(analogCurrent*.95 > analogValue) {
      moveBack();
    }*/
  
  }
  
  
  // not really sample rate due to time doing above calculations
  // but close enough
  delay(sampleRate);

}
