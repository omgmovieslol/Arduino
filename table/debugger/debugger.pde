const int leftSensorPin = 5;     // left sensor input
const int rightSensorPin = 3;    // right sensor input (analog)
const int analogSensor = 0;      // front/back sensor. Uses analog measurement
const int resetSensor = 12;      // table left/right reset sensor
const int resetSwitch = 2;       // reset switch



const int leftSensorMotor = 4;   // left sensor motor
const int leftSensorReset = 3;   // left sensor motor reverse direction
const int rightSensorMotor = 10;  // right sensor motor
const int rightSensorReset = 6;  // right sensor motor reverse direction

const int leftTableMotor = 9;    // move table to the left
const int rightTableMotor = 8;   // move table to the right

const int frontTableMotor = 5;  // move table to the front
const int backTableMotor = 7;   // move table to the back

//const int ledPin = 13;



void setup() {
  //pinMode(leftSensorPin, INPUT); 
  pinMode(rightSensorPin, INPUT);  
  pinMode(resetSensor, INPUT);
  pinMode(resetSwitch, INPUT);
  
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
  Serial.begin(9600);  
}

void loop() {
  Serial.println(analogRead(leftSensorPin));
  Serial.println(analogRead(rightSensorPin));
  Serial.println("\n");
  Serial.println(analogRead(analogSensor));
  Serial.println(digitalRead(resetSensor));
  Serial.println(digitalRead(resetSwitch));
  Serial.println("\n\n\n");
  digitalWrite(leftTableMotor, LOW);
  digitalWrite(frontTableMotor, LOW);
  digitalWrite(backTableMotor, LOW);
  digitalWrite(rightTableMotor, LOW);


  
  digitalWrite(leftSensorMotor, LOW);
  digitalWrite(leftSensorReset, LOW);
  
  digitalWrite(rightSensorMotor, LOW);
  digitalWrite(rightSensorReset, LOW);
  
  
  //Serial.println("\n\n\n");
  delay(400);
}
