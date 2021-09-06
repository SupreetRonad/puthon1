// Black Line Follower
int IR1 = 8; //Right sensor
int IR2 = 9; //left Sensor
// motor one
int enA = 5; //Right motor
int MotorAip1 = 2;
int MotorAip2 = 3;
// motor two
int enB = 6; //Left motor
int MotorBip1 = 4;
int MotorBip2 = 7;

int table = 3;

int start = 0;
int firstDivide = 0;
int continueWithDelay = 0;
int inLoop = 0;


int forwardSpeed = 55;
int turnSpeed = 65;
int turnSpeedAnti = 45;

#define echoPin 12 // attach pin D2 Arduino to pin Echo of HC-SR04
#define trigPin 11 //attach pin D3 Arduino to pin Trig of HC-SR04

// counter for turns
int count;

// defines variables
long duration; // variable for the duration of sound wave travel
int distance;  // variable for the distance measurement

void setup() {
  Serial.begin(9600);
  // put your setup code here, to run once:
  pinMode(enA, OUTPUT);
  pinMode(enB, OUTPUT);
  pinMode(IR1, INPUT); // Right IR
  pinMode(IR2, INPUT); // Left IR
  pinMode(MotorAip1, OUTPUT);
  pinMode(MotorAip2, OUTPUT);
  pinMode(MotorBip1, OUTPUT);
  pinMode(MotorBip2, OUTPUT);
  pinMode(trigPin, OUTPUT); // Sets the trigPin as an OUTPUT
  pinMode(echoPin, INPUT);
}

void loop()
{
  Serial.println(firstDivide);
  followLine();
  if (table == 0 && digitalRead(IR1) == HIGH && digitalRead(IR2) == HIGH) {
    stopBot();
  }
  else if (digitalRead(IR1) == HIGH && digitalRead(IR2) == HIGH) {
    if (firstDivide == 0) {
      firstDivide = 1;
      delay(200);
      if (table % 2 != 0) {
        while (digitalRead(IR1) != HIGH) {
          leftBot();
        }
        count = -1;
      } else {
        while (digitalRead(IR2) != HIGH) {
          rightBot();
        }
        count = 0;
      }
    }
    else {
      count += 2;
      delay(200);

      if (count > 4) {
        returnToKitchen();
      }
      else if (count == table) {
        reachedTable();
      }
    }
  }
}

void followLine() {
  if (obstacleFound()) {
    stopBot();
  } else if (digitalRead(IR1) == LOW && digitalRead(IR2) == HIGH) {
    rightBot();
  } else if (digitalRead(IR1) == HIGH && digitalRead(IR2) == LOW) {
    leftBot();
  } else {
    forwardBot();
  }
}

void rightBot() {
  Serial.println("Right");
  analogWrite(enA, turnSpeedAnti);
  analogWrite(enB, turnSpeed);
  //Tilt robot towards right by stopping the right wheel and moving the left one
  digitalWrite(MotorAip1, LOW); // If I want to turn right then the speed of the right wheel should be less than that of the left wheel, here, let a be the right wheel
  digitalWrite(MotorAip2, HIGH);
  digitalWrite(MotorBip1, HIGH); //
  digitalWrite(MotorBip2, LOW);  //
  //  delay(continueWithDelay);
}

void leftBot() {
  Serial.println("Left");
  analogWrite(enA, turnSpeed);
  analogWrite(enB, turnSpeedAnti);
  //Tilt robot towards left by stopping the left wheel and moving the right one
  digitalWrite(MotorAip1, HIGH); //
  digitalWrite(MotorAip2, LOW);  //
  digitalWrite(MotorBip1, LOW);
  digitalWrite(MotorBip2, HIGH);
  //  delay(continueWithDelay);
}

void forwardBot() {
  Serial.println("Forward");
  //Move both the Motors
  analogWrite(enA, forwardSpeed ); // right wheel
  analogWrite(enB, forwardSpeed ); // left wheel
  digitalWrite(MotorAip1, HIGH);
  digitalWrite(MotorAip2, LOW);
  digitalWrite(MotorBip1, HIGH);
  digitalWrite(MotorBip2, LOW);
  //  delay(continueWithDelay);
}

void stopBot() {
  Serial.println("Stop");
  //Stop both the motors
  analogWrite(enA, 0);
  analogWrite(enB, 0);
  digitalWrite(MotorAip1, LOW);
  digitalWrite(MotorAip2, LOW);
  digitalWrite(MotorBip1, LOW);
  digitalWrite(MotorBip2, LOW);
  //  delay(continueWithDelay);
}

// Virtual Turns
void virtualTurn(int turn, int d) {
  switch (turn) {
    case 0:
      leftBot();
      break;
    case 1:
      rightBot();
      break;
    default:
      break;
  }
  delay(d);
}

long microsecondsToCentimeters(long microseconds) {
  return microseconds / 29 / 2;
}

bool foundCheckpoint() {
  return digitalRead(IR1) == HIGH && digitalRead(IR2) == HIGH;
}

void reachedTable() {
  int leftTurn = 450;
  int pause = 5000;

  while (digitalRead(IR1) != HIGH) {
    leftBot();
  }

  while (!(digitalRead(IR1) == HIGH && digitalRead(IR2) == HIGH)) {
    followLine();
  }
  delay(200);

  //  delivered = 1;

  stopBot();
  delay(pause);

  while (!(digitalRead(IR1) == HIGH && digitalRead(IR2) == HIGH)) {
    followLine();
  }

  delay(200);

  while (digitalRead(IR1) != HIGH) {
    leftBot();
  }
}

void returnToKitchen() {
  table = 0;
  if (table % 2 == 0) {
    while (digitalRead(IR2) != HIGH) {
      rightBot();
    }
  } else {
    while (digitalRead(IR1) != HIGH) {
      leftBot();
    }
  }

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
