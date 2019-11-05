/*
  6V Battery Positive - L298N 12V Input
  6V Battery Negative - L298N GND

  L298N Motor1 A - Motor 1
  L298N Motor1 B - Motor 1

  L298N Motor2 A - Motor 2
  L298N Motor2 B - Motor 2

  NodeMCU D1 - L298N IN1
  NodeMCU D2 - L298N IN2
  NodeMCU D3 - L298N IN3
  NodeMCU D4 - L298N IN4

  D8 - Buzzer (horn) Positive
  GND - NodeMCU GND

  L298N GND - NodeMCU GND (common ground)
  You can either power your NodeMCU using 5V Output from L298N or using a USB Cable (better way).
*/

// Make sure your client device and NodeMCU are on the same network.

#include <ESP8266WiFi.h> // To connect to Wi-Fi and Get Private IP in LAN
#include <WiFiClient.h> // To handle Clients
#include <ESP8266WebServer.h> // To create a local server in LAN

const char *ssid = "Manas"; // name of Wi-Fi network
const char *password = "0987654321"; // password of Wi-Fi network

ESP8266WebServer server(80); // port 80 for HTTP

void homePage(void);
void goForward(void);
void goBack(void);
void goLeft(void);
void goRight(void);
void stopCar(void);
void notFound(void);
void goBerzerk(void);
void honk(void);

void setup(void) {
  Serial.begin(9600);

  pinMode(D1, OUTPUT); // IN1
  pinMode(D2, OUTPUT); // IN2
  pinMode(D3, OUTPUT); // IN3
  pinMode(D4, OUTPUT); // IN4
  pinMode(D8, OUTPUT); // Buzzer
  pinMode(LED_BUILTIN, OUTPUT);

  WiFi.begin(ssid, password); // Connect to a network
  Serial.println("");

  while (WiFi.status() != WL_CONNECTED) {
    digitalWrite(LED_BUILTIN, HIGH);
    delay(500);
    digitalWrite(LED_BUILTIN, LOW);
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");

  // NAT assigns a IP address to NodeMCU and then it runs a server to which other devices can connect to on the same network.

  Serial.println(WiFi.localIP()); // connect to Wi-Fi to get Private IP in LAN

  Serial.print("MAC Address: ");
  Serial.println(WiFi.macAddress()); // MAC Address of NodeMCU

  // Server endpoints

  server.on("/", homePage);
  server.on("/forward", goForward);
  server.on("/reverse", goBack);
  server.on("/left", goLeft);
  server.on("/right", goRight);
  server.on("/stop", stopCar);
  server.on("/berzerk", goBerzerk);
  server.on("/honk", honk);
  server.onNotFound([]() {
    notFound();
  });
  server.begin();

}

void homePage(void) {
  Serial.println("Home Page.");
  server.send(200, "application/json", "{ \"message\" : \"Welcome, The server is up.\" }"); // Status Code, Content-Type/Mime-Type, Data
}

void goForward(void) {
  Serial.println("Go Forward.");
  digitalWrite(D1, HIGH);
  digitalWrite(D2, LOW);
  digitalWrite(D3, HIGH);
  digitalWrite(D4, LOW);

  server.send(200, "application/json", "{ \"message\" : \"Car is going forward.\" }");
}

void goBack(void) {
  Serial.println("Go Back.");
  digitalWrite(D1, LOW);
  digitalWrite(D2, HIGH);
  digitalWrite(D3, LOW);
  digitalWrite(D4, HIGH);

  server.send(200, "application/json", "{ \"message\" : \"Car is going in reverse.\" }");
}

void goLeft(void) {
  Serial.println("Go Left.");
  digitalWrite(D1, LOW);
  digitalWrite(D2, LOW);
  digitalWrite(D3, HIGH);
  digitalWrite(D4, LOW);

  server.send(200, "application/json", "{ \"message\" : \"Car is going left.\" }");
}

void goRight(void) {
  Serial.println("Go Right.");
  digitalWrite(D1, HIGH);
  digitalWrite(D2, LOW);
  digitalWrite(D3, LOW);
  digitalWrite(D4, LOW);

  server.send(200, "application/json", "{ \"message\" : \"Car is going right.\" }");
}

void stopCar(void) {
  Serial.println("Stop car.");
  server.send(200, "application/json", "{ \"message\" : \"Car is stopped.\" }");

  digitalWrite(D1, LOW);
  digitalWrite(D2, LOW);
  digitalWrite(D3, LOW);
  digitalWrite(D4, LOW);
}

void goBerzerk(void) {
  Serial.println("Go Berzerk.");
  server.send(200, "application/json", "{ \"message\" : \"Car is going Berzerk.\" }");

  digitalWrite(D1, HIGH);
  digitalWrite(D2, LOW);
  digitalWrite(D3, LOW);
  digitalWrite(D4, HIGH);

  delay(10000);

  digitalWrite(D1, LOW);
  digitalWrite(D2, LOW);
  digitalWrite(D3, LOW);
  digitalWrite(D4, LOW);
}

void honk(void) {
  Serial.println("Honk.");
  server.send(200, "application/json", "{ \"message\" : \"Car is honking.\" }");

  digitalWrite(D8, HIGH);
  delay(200);
  digitalWrite(D8, LOW);
}

void notFound(void) {
  Serial.println("Resource not found.");
  server.send(404, "application/json", "{ \"message\" : \"Resource not found.\" }");

  digitalWrite(D1, LOW);
  digitalWrite(D2, LOW);
  digitalWrite(D3, LOW);
  digitalWrite(D4, LOW);
}

void loop(void) {
  server.handleClient();
}
