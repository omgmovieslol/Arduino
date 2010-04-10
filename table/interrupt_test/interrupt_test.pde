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
  pinMode(ledPin, OUTPUT);      

  attachInterrupt(0, reset, RISING);  
  Serial.begin(9600);
  //attachInterrupt(0, start, FALLING); // button now more likely a switch

}

void reset() {
  //TODO: to the reset routine
  
  Serial.println("interrupt");
  
  if(!onReset) {
    onReset = true;
  } else {
    onReset = false;
  }
  
   digitalWrite(ledPin, LOW);
  
  
  
}


// main()
void loop(){
  
  if(!onReset) {
  
    digitalWrite(ledPin, HIGH);
  
  }
  
  
  // not really sample rate due to time doing above calculations
  // but close enough
  delay(sampleRate);

}
