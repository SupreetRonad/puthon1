#include "Arduino.h"
#include "bot.h"

// IR sensors
int leftIR = 8; //left sensor
int rightIR = 9; //right Sensor

// motor one
int enRight = 5; //Right motor
int MotorAip1 = 2;
int MotorAip2 = 3;

// motor two
int enLeft = 6; //Left motor
int MotorBip1 = 4;
int MotorBip2 = 7;

// motor speeds
int forwardSpeed = 55;
int turnSpeed = 70;
int turnSpeedAnti = 45;

#define echoPin 12 // attach pin D2 Arduino to pin Echo of HC-SR04
#define trigPin 11 //attach pin D3 Arduino to pin Trig of HC-SR04


void rightBot() {
  analogWrite(enRight, turnSpeedAnti);
  analogWrite(enLeft, turnSpeed);
  //Tilt robot towards right by stopping the right wheel and moving the left one
  digitalWrite(MotorAip1, LOW); // If I want to turn right then the speed of the right wheel should be less than that of the left wheel, here, let a be the right wheel
  digitalWrite(MotorAip2, HIGH);
  digitalWrite(MotorBip1, HIGH); //
  digitalWrite(MotorBip2, LOW);  //
}
void leftBot() {
  analogWrite(enRight, turnSpeed);
  analogWrite(enLeft, turnSpeedAnti);
  //Tilt robot towards left by stopping the left wheel and moving the right one
  digitalWrite(MotorAip1, HIGH); //
  digitalWrite(MotorAip2, LOW);  //
  digitalWrite(MotorBip1, LOW);
  digitalWrite(MotorBip2, HIGH);
}
void forwardBot() {
  //Move both the Motors
  analogWrite(enRight, forwardSpeed); // right wheel
  analogWrite(enLeft, forwardSpeed); // left wheel
  digitalWrite(MotorAip1, HIGH);
  digitalWrite(MotorAip2, LOW);
  digitalWrite(MotorBip1, HIGH);
  digitalWrite(MotorBip2, LOW);
}
void stopBot() {
  //Stop both the motors
  analogWrite(enRight, 0);
  analogWrite(enLeft, 0);
  digitalWrite(MotorAip1, LOW);
  digitalWrite(MotorAip2, LOW);
  digitalWrite(MotorBip1, LOW);
  digitalWrite(MotorBip2, LOW);
}

void followLine() {
  if (obstacleFound()) {
    stopBot();
  } else if (digitalRead(leftIR) == LOW && digitalRead(rightIR) == HIGH) {
    rightBot();
  } else if (digitalRead(leftIR) == HIGH && digitalRead(rightIR) == LOW) {
    leftBot();
  } else {
    forwardBot();
  }
}
void virtualTurn(int turn) {
  switch (turn) {
    case 0:
      while (digitalRead(leftIR) != HIGH) {
        leftBot();
      }
      break;
    case 1:
      while (digitalRead(rightIR) != HIGH) {
        rightBot();
      }
      break;
    default:
      break;
  }
}

long microsecondsToCentimeters(long microseconds) {
  return microseconds / 29 / 2;
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
  if (cm <= 20) {
    return true;
  } else {
    return false;
  }
}

bool foundCheckpoint() {
  return (digitalRead(leftIR) == HIGH && digitalRead(rightIR) == HIGH);
}
void reachedTable() {
  int turnDelay = 200;
  int pause = 5000;
  virtualTurn(0);
  while (!(foundCheckpoint())) {
    followLine();
  }
  delay(turnDelay);
  stopBot();
  delay(pause);
  Serial.println("Done");
  while (!(foundCheckpoint())) {
    followLine();
  }
  delay(turnDelay);
  virtualTurn(0);
}

void returnToKitchen(int table) {
  if (table % 2 == 0) {
    virtualTurn(1);
  } else {
    virtualTurn(0);
  }
}
void stopIfReachedKitchen(int reachedKitchen) {
  if (reachedKitchen == 0) {
    followLine();
  } else {
    stopBot();
  }
}
