#include "bot.h"

int table = 0;
int start = 0;
int firstDivide = 0;
int continueWithDelay = 0;
int inLoop = 0;
int reachedKitchen = 1;
int count;

String tableString = "";

void setup() {
  Serial.begin(9600);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(8, INPUT);
  pinMode(9, INPUT);
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(12, INPUT);
}

void loop() {
  stopIfReachedKitchen(reachedKitchen);
  while (Serial.available() && table == 0) {
    tableString = Serial.readString();
    if (tableString != "") {
      table = tableString.toInt();    
      reachedKitchen = 0;
      Serial.flush(); 
    }
  }
  if (foundCheckpoint()) {
    if (table == 0 ) {
      delay(200);
      stopBot();
      reachedKitchen = 1;
      
      firstDivide = 0;
    }
    else if (firstDivide == 0) {
      firstDivide = 1;
      delay(200);
      if (table % 2 != 0) {
        virtualTurn(0);
        count = -1;
      } else {
        virtualTurn(1);
        count = 0;
      }
    }
    else {
      count += 2;
      delay(200);
      if (count > 4) {
        returnToKitchen(table);
        table = 0;
      }
      else if (count == table) {
        reachedTable();
      }
    }
  }
}
