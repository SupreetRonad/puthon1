#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>

#define FIREBASE_HOST "puthon-45317-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "QV0ObMktqGkNGcZzJMt29d6oY6zYdBS5KMCR4nLU"
#define WIFI_SSID "sathvik_X1"
#define WIFI_PASSWORD "admin123"

void setup() {
  Serial.begin(9600);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.println("\t\t...Connecting to Internet...\t\t");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.println("Please Wait...");
    delay(500);
  }
  Serial.print("Connected to ");
  Serial.println(WiFi.localIP());
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.stream("/4kixXZxIJbQ5biBRSIFhjsh8NMz2/56");
}

void loop() {
  if (Firebase.failed()) {
    Serial.print("Streaming Error - ");
    Serial.println(Firebase.error());
  }
  if (Firebase.available()) {

    FirebaseObject event = Firebase.readEvent();
    String eventType = event.getString("type");
    Serial.print("Event type: ");
    Serial.println(eventType);
    if (eventType == "put") {
      bool delivered = Firebase.getBool("/4kixXZxIJbQ5biBRSIFhjsh8NMz2/56/delivered");
      Serial.print("Delivered: ");
      Serial.println(delivered);
      if (delivered == false) {
        Serial.println("Start Journey");
        int table = Firebase.getInt("/4kixXZxIJbQ5biBRSIFhjsh8NMz2/56/tableNo");
        Serial.print("Table: ");
        Serial.println(table);
        delay(1000);
        informDelivered();
      }
    }
  }
}

void informDelivered() {
  Firebase.setBool("/4kixXZxIJbQ5biBRSIFhjsh8NMz2/56/delivered", true);
  Serial.println("Delivered to the table.");
}
