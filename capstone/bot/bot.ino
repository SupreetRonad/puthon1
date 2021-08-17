// Black Line Follower
int IR1 = 8;    //Right sensor
int IR2 = 9;  //left Sensor
// motor one
int enA = 5;    //Right motor
int MotorAip1 = 2;
int MotorAip2 = 3;
// motor two
int enB = 6;    //Left motor
int MotorBip1 = 4;
int MotorBip2 = 7;

int table = 2;

#define echoPin 12 // attach pin D2 Arduino to pin Echo of HC-SR04
#define trigPin 11 //attach pin D3 Arduino to pin Trig of HC-SR04

// counter for turns
int count = 0;

// defines variables
long duration; // variable for the duration of sound wave travel
int distance; // variable for the distance measurement

void setup() {
  Serial.begin(9600);

  // put your setup code here, to run once:
  pinMode(enA, OUTPUT);
  pinMode(enB, OUTPUT);
  pinMode(IR1, INPUT);
  pinMode(IR2, INPUT);
  pinMode(MotorAip1, OUTPUT);
  pinMode(MotorAip2, OUTPUT);
  pinMode(MotorBip1, OUTPUT);
  pinMode(MotorBip2, OUTPUT);
  pinMode(trigPin, OUTPUT); // Sets the trigPin as an OUTPUT
  pinMode(echoPin, INPUT);
}
void loop() {
  if (obstacleFound()) {
    stopBot();
  } else {
    if (digitalRead(IR1) == HIGH && digitalRead(IR2) == HIGH) {
      count++;
      delay(150);
      if (count == table) {
        takeLeft();
      }
    } else if (digitalRead(IR1) == LOW && digitalRead(IR2) == HIGH) {
      rightBot();
    } else if (digitalRead(IR1) == HIGH && digitalRead(IR2) == LOW) {
      leftBot();
    } else {
      forwardBot();
    }
  }
}

void rightBot() {
  Serial.println("Right");
  analogWrite (enA, 40);
  analogWrite (enB, 80);
  //Tilt robot towards right by stopping the right wheel and moving the left one
  digitalWrite(MotorAip1, LOW);    // If I want to turn right then the speed of the right wheel should be less than that of the left wheel, here, let a be the right wheel
  digitalWrite(MotorAip2, HIGH);
  digitalWrite(MotorBip1, HIGH); //
  digitalWrite(MotorBip2, LOW); //

  // delay(100);
}

void leftBot() {
  Serial.println("Left");
  analogWrite (enA, 80);
  analogWrite (enB, 40);
  //Tilt robot towards left by stopping the left wheel and moving the right one
  digitalWrite(MotorAip1, HIGH); //
  digitalWrite(MotorAip2, LOW);  //
  digitalWrite(MotorBip1, LOW);
  digitalWrite(MotorBip2, HIGH);

  // delay(100);
}

void forwardBot() {
  Serial.println("Forward");
  //Move both the Motors
  analogWrite (enA, 80);
  analogWrite (enB, 80);
  digitalWrite(MotorAip1, HIGH);
  digitalWrite(MotorAip2, LOW);
  digitalWrite(MotorBip1, HIGH);
  digitalWrite(MotorBip2, LOW);

}

void stopBot() {
  Serial.println("Stop");
  //Stop both the motors
  analogWrite (enA, 0);
  analogWrite (enB, 0);
  digitalWrite(MotorAip1, LOW);
  digitalWrite(MotorAip2, LOW);
  digitalWrite(MotorBip1, LOW);
  digitalWrite(MotorBip2, LOW);
}

long microsecondsToCentimeters(long microseconds) {
  return microseconds / 29 / 2;
}

void takeLeft() {

  int leftTurn = 900;
  int rightTurn = 500;
  int turnForward = 500;
  int forward = 1000;
  int pause = 5000;

  forwardBot();
  delay(300);

  leftBot();
  delay(leftTurn);

  forwardBot();
  delay(turnForward);

  rightBot();
  delay(rightTurn);

  forwardBot();
  delay(forward);

  stopBot();
  delay(pause);

  forwardBot();
  delay(forward);

  rightBot();
  delay(rightTurn);

  forwardBot();
  delay(turnForward);

  leftBot();
  delay(leftTurn);

  forwardBot();
}

bool obstacleFound() {
  long duration, cm;
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  cm = microsecondsToCentimeters(duration);
  //  Serial.print(cm);
  //  Serial.println(" cm");
  if (cm <= 20) {
    return true;
  } else {
    return false;
  }
}
