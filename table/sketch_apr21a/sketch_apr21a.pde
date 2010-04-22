const int analogSensor = 0;      // front/back sensor. Uses analog measurement



void setup() {
  Serial.begin(9600);
}



void loop() {
  Serial.println(analogRead(analogSensor));
  delay(200);
}
