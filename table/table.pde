/*
Senior Design 
Spring 2010
Automated Adjustable Table

James Wilson
*/

/*
TODO:
Concurrent FB/LR movement
If analog too far, don't move

*/

// CONSTANTS

// inputs
const int leftSensorPin = 11;     // left sensor input
const int rightSensorPin = 5;    // right sensor input

const int resetSensor = 10;      // table left/right reset sensor

const int analogSensor = 0;      // front/back sensor. Uses analog measurement

// output to motors
const int leftSensorMotor = 3;   // left sensor motor
const int leftSensorReset = 4;   // left sensor motor reverse direction
const int rightSensorMotor = 7;  // right sensor motor
const int rightSensorReset = 6;  // right sensor motor reverse direction

const int leftTableMotor = 9;    // move table to the left
const int rightTableMotor = 8;   // move table to the right

const int frontTableMotor = 12;  // move table to the front
const int backTableMotor = 13;   // move table to the back

const int resetSwitch = 2;       // reset switch



const int ledPin = 13;           // testing pin

// user defined
const int sampleRate = 200;      // sampling rate in ms. original idea was 200 ms
const int sensorMotorLength = 250;// how long the motor should be activated when moving sensor motors
const int tableMotorLength = 200;// how long the table motor should be activated to move it
const int delayRate = 0;         // how long between movements.
                                 // 0 for a no-op, I guess
const int awayReset = 40;        // if the sensor reads smaller than this value, run reset command
                                 // this is probably because user left table


// VARIABLES
int leftStatus = 0;              // status of the left sensor
int rightStatus = 0;             // status of the right sensor
int setupDone = 0;               // status of the setup
int setupCount = 0;              // number of times the sensors failed. 5 requires a resetup.
int analogValue = 0;             // starting value of the analog sensor
int analogCurrent = 0;           // current analog value. compared to analogValue
int leftSensorMoves = 0;         // number of times the left sensors have moved. to reset to original position.
int rightSensorMoves = 0;        // number of times right sensor moved.
boolean onReset = true;
long resetTime = 0;
int analogOn = 0;
int moveDone = 0;
int analogFront = 0;
int analogBack = 0;


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
  
  pinMode(resetSensor, INPUT);
  pinMode(resetSwitch, INPUT);
  
  // don't declare analog input. it's always an input
  
  // inputs
  pinMode(leftSensorPin, INPUT);     
  pinMode(rightSensorPin, INPUT);
  
  analogValue = analogRead(analogSensor);
  
  Serial.begin(9600);
}

void reset() {
  
  if(!onReset) {
    onReset = true;
    
    // move table all the way back
    // just start moving the table at the beginnning
    // it'll automatically stop moving when it hit the limit
    digitalWrite(backTableMotor, HIGH);
    resetTime = millis()/1000;
    // move the table back to original left right position
    if(digitalRead(resetSensor) == HIGH) {
      while(digitalRead(resetSensor) == HIGH) {
        digitalWrite(rightTableMotor, HIGH);
        delay(tableMotorLength);
        digitalWrite(rightTableMotor, LOW);
        delay(delayRate);
      }
    }
    else {
      while(digitalRead(resetSensor) == LOW) {
        digitalWrite(leftTableMotor, HIGH);
        delay(tableMotorLength);
        digitalWrite(leftTableMotor, LOW);
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
    leftSensorMoves=0;
    for(int i=0; i<rightSensorMoves; i++) {
      digitalWrite(rightSensorReset, HIGH);
      delay(sensorMotorLength);
      digitalWrite(rightSensorReset, LOW);
      delay(delayRate);
    }
    rightSensorMoves=0;
    
    // twenty second delay to move table all the way back
    resetTime = 30000-(((millis()/1000)-resetTime)*1000);
    Serial.println(resetTime);
    delay(resetTime); 
    resetTime = 0;
    digitalWrite(backTableMotor, LOW);
    
    // just in case something weird happens, the table won't try to do front and back to where it was
    analogValue = analogRead(analogSensor);
    
    
  } else {
    // second reset press
    // start the automation again
    onReset = false;
    motorSetup();
    analogValue = analogRead(analogSensor);
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
    // removed reset option during motor setup
    // button can still be pressed down
    // so it would cause reset to run again
    //if(digitalRead(resetSwitch) == LOW) reset();
    delay(delayRate);
  }
  
  // setup right sensor placement
  digitalWrite(rightSensorReset, LOW);
  while(digitalRead(rightSensorPin) == HIGH) {
    digitalWrite(rightSensorMotor, HIGH); 
    delay(sensorMotorLength);
    digitalWrite(rightSensorMotor, LOW); 
    rightSensorMoves++;
    //if(digitalRead(resetSwitch) == LOW) reset();
    delay(delayRate);
  }
  
  //analogValue = analogRead(analogSensor);
  
  setupDone = 1;
  setupCount = 0;
  
  // sensors are in correct positions
}

void moveTable() {
  while(!moveDone) {
    leftStatus = digitalRead(leftSensorPin);
    rightStatus = digitalRead(rightSensorPin);
    analogCurrent = analogRead(analogSensor);
    digitalWrite(backTableMotor, LOW);
    digitalWrite(frontTableMotor, LOW);
    
    if(analogOn) {
      if(analogCurrent < awayReset) {
        reset();
      } else if(analogCurrent <= analogValue && analogFront) {
        digitalWrite(frontTableMotor, HIGH);
        if(digitalRead(resetSwitch) == LOW) reset();
        analogBack = 0;
      } else if(analogCurrent >= analogValue && analogBack) {
        digitalWrite(backTableMotor, HIGH);
        if(digitalRead(resetSwitch) == LOW) reset();
        analogFront = 0;
      }
      else {
        analogOn = 0;
        analogFront = 0;
        analogBack = 0;
      }
    }
    
    if(leftStatus == HIGH) {
      if(digitalRead(rightSensorPin) == HIGH) break;
      digitalWrite(leftTableMotor, HIGH);
      delay(tableMotorLength);
      digitalWrite(leftTableMotor, LOW);
      if(digitalRead(resetSwitch) == LOW) reset();
    }
    else if(rightStatus == HIGH) {
      if(digitalRead(leftSensorPin) == HIGH) break;
      digitalWrite(rightTableMotor, HIGH);
      delay(tableMotorLength);
      digitalWrite(rightTableMotor, LOW);
      if(digitalRead(resetSwitch) == LOW) reset();
    }
    else {
      delay(tableMotorLength);
    }
    
    if(analogCurrent*1.15 < analogValue) {
      analogOn = 1;
      analogFront = 1;
    }
    else if(analogCurrent*.85 > analogValue) {
      analogOn = 1;
      analogBack = 1;
    }
    else if(leftStatus == LOW && rightStatus == LOW) {
      moveDone = 1;
    }
    
    digitalWrite(frontTableMotor, LOW);
    digitalWrite(backTableMotor, LOW);
  }
}  


// main()
void loop(){
  
  // setup the motor placement
  if(!onReset) {
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
    
    moveDone = 0;
    
    if(analogCurrent < awayReset) {
      reset();
    }
    
    if(analogCurrent*1.15 < analogValue) {
      analogOn = 1;
      analogFront = 1;
      moveTable();
    }
    else if(analogCurrent*.85 > analogValue) {
      analogOn = 1;
      analogBack = 1;
      moveTable();
    }
    else if(leftStatus == HIGH || rightStatus == HIGH) {
      analogOn = 0;
      moveTable();
    }
  }
  
  //Serial.println(analogCurrent);
  if(digitalRead(resetSwitch) == LOW) reset();
  
  
  // not really sample rate due to time doing above calculations
  // but close enough
  delay(sampleRate);

}
