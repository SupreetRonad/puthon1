// Black Line Follower
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

int table = 1;

int start = 0;
int firstDivide = 0;
int continueWithDelay = 0;
int inLoop = 0;
int reachedKitchen = 0;


int forwardSpeed = 60;
int turnSpeed = 70;
int turnSpeedAnti = 45;

#define echoPin 12 // attach pin D2 Arduino to pin Echo of HC-SR04
#define trigPin 11 //attach pin D3 Arduino to pin Trig of HC-SR04

// counter for turns
int count;

void setup() {
  Serial.begin(9600);
//  // put your setup code here, to run once:
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(8, INPUT);
  pinMode(9, INPUT);
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(11, OUTPUT); // Sets the trigPin as an OUTPUT
  pinMode(12, INPUT);
}

void loop()
{
  stopIfReachedKitchen(reachedKitchen);
  if (foundCheckpoint()) {

    // If the food is delivered
    if (table == 0 ) {
      delay(200);
      stopBot();
      reachedKitchen = 1;
    }

    // To decide right or left on first Checkpoint
    else if (firstDivide == 0) {
      firstDivide = 1;
      delay(200);
      if (table % 2 != 0) {
        //        while (digitalRead(leftIR) != HIGH) {
        //          leftBot();
        //        }
        virtualTurn(0);
        count = -1;
      } else {
        //        while (digitalRead(rightIR) != HIGH) {
        //          rightBot();
        //        }
        virtualTurn(1);
        count = 0;
      }
    }

    // For table count
    else {
      count += 2;
      delay(200);

      // All tables passed
      if (count > 4) {
        returnToKitchen(table);
        table = 0;
      }

      // Table reached
      else if (count == table) {
        reachedTable();
      }
    }
  }
}

void stopIfReachedKitchen() {
 if (reachedKitchen == 0) {
   followLine();
 }
 else {
   stopBot();
 }
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

void rightBot() {
 Serial.println("Right");
 analogWrite(enRight, turnSpeedAnti);
 analogWrite(enLeft, turnSpeed);
 //Tilt robot towards right by stopping the right wheel and moving the left one
 digitalWrite(MotorAip1, LOW); // If I want to turn right then the speed of the right wheel should be less than that of the left wheel, here, let a be the right wheel
 digitalWrite(MotorAip2, HIGH);
 digitalWrite(MotorBip1, HIGH); //
 digitalWrite(MotorBip2, LOW);  //
 //  delay(continueWithDelay);
}

void leftBot() {
 Serial.println("Left");
 analogWrite(enRight, turnSpeed);
 analogWrite(enLeft, turnSpeedAnti);
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
 analogWrite(enRight, forwardSpeed ); // right wheel
 analogWrite(enLeft, forwardSpeed ); // left wheel
 digitalWrite(MotorAip1, HIGH);
 digitalWrite(MotorAip2, LOW);
 digitalWrite(MotorBip1, HIGH);
 digitalWrite(MotorBip2, LOW);
 //  delay(continueWithDelay);
}

void stopBot() {
 Serial.println("Stop");
 //Stop both the motors
 analogWrite(enRight, 0);
 analogWrite(enLeft, 0);
 digitalWrite(MotorAip1, LOW);
 digitalWrite(MotorAip2, LOW);
 digitalWrite(MotorBip1, LOW);
 digitalWrite(MotorBip2, LOW);
 //  delay(continueWithDelay);
}

// Virtual Turns
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

bool foundCheckpoint() {
 return (digitalRead(leftIR) == HIGH && digitalRead(rightIR) == HIGH);
}

void reachedTable() {
 int leftTurn = 450;
 int pause = 5000;

 //  while (digitalRead(leftIR) != HIGH) {
 //    leftBot();
 //  }
 virtualTurn(0);

 while (!(digitalRead(leftIR) == HIGH && digitalRead(rightIR) == HIGH)) {
   followLine();
 }
 delay(200);

 //  delivered = 1;

 stopBot();
 delay(pause);

 while (!(digitalRead(leftIR) == HIGH && digitalRead(rightIR) == HIGH)) {
   followLine();
 }

 delay(200);

 //  while (digitalRead(leftIR) != HIGH) {
 //    leftBot();
 //  }
 virtualTurn(0);
}

void returnToKitchen() {
 if (table % 2 == 0) {
   //    while (digitalRead(rightIR) != HIGH) {
   //      rightBot();
   //    }
   virtualTurn(1);
 } else {
   //    while (digitalRead(leftIR) != HIGH) {
   //      leftBot();
   //    }
   virtualTurn(0);
 }
 table = 0;
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
