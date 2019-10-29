#include <ESP8266WiFi.h> // To connect to Wi-Fi and Get Private IP in LAN
#include <WiFiClient.h> // To handle Clients
#include <ESP8266WebServer.h> // To create a local server in LAN

// Make sure your client device and NodeMCU are on the same network.

const char *ssid = "airtel123"; // name of Wi-Fi network
const char *password = "manas@123"; // password of Wi-Fi network

ESP8266WebServer server(80); // port 80 for HTTP

void homePage(void);
void goForward(void);
void goBack(void);
void goLeft(void);
void goRight(void);
void stopCar(void);
void notFound(void);
void goBerzerk(void);

const int motorOneA = D1;
const int motorOneB = D2;
const int motorTwoA = D3;
const int motorTwoB = D4;

void setup(void) {
  Serial.begin(9600);

  WiFi.begin(ssid, password); // Connect to a network
  Serial.println("");

  while (WiFi.status() != WL_CONNECTED) {
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
  server.onNotFound([]() {
    notFound();
  });
  server.begin();

  pinMode(D1, OUTPUT);
  pinMode(D2, OUTPUT);
  pinMode(D3, OUTPUT);
  pinMode(D4, OUTPUT);
  pinMode(LED_BUILTIN, OUTPUT);
}

void homePage(void) {
  Serial.println("Home Page.");
  digitalWrite(LED_BUILTIN, HIGH);
  server.send(200, "application/json", "{ \"message\" : \"Welcome, The server is up.\" }"); // Status Code, Content-Type/Mime-Type, Data
}

void goForward(void) {
  Serial.println("Go Forward.");
  server.send(200, "application/json", "{ \"message\" : \"Car is going forward.\" }");
}

void goBack(void) {
  Serial.println("Go Back.");
  server.send(200, "application/json", "{ \"message\" : \"Car is going in reverse.\" }");
}

void goLeft(void) {
  Serial.println("Go Left.");
  server.send(200, "application/json", "{ \"message\" : \"Car is going left.\" }");
}

void goRight(void) {
  Serial.println("Go Right.");
  server.send(200, "application/json", "{ \"message\" : \"Car is going right.\" }");
}

void stopCar(void) {

  Serial.println("Stop car.");
  server.send(200, "application/json", "{ \"message\" : \"Car is stopped.\" }");

  digitalWrite(motorOneA, LOW);
  digitalWrite(motorOneB, LOW);
  digitalWrite(motorTwoA, LOW);
  digitalWrite(motorTwoB, LOW);
}

void goBerzerk(void) {

  Serial.println("Go Berzerk.");
  server.send(200, "application/json", "{ \"message\" : \"Car is going Berzerk.\" }");

  digitalWrite(motorOneA, HIGH);
  digitalWrite(motorOneB, LOW);
  digitalWrite(motorTwoA, HIGH);
  digitalWrite(motorTwoB, LOW);

  delay(10000);

  digitalWrite(motorOneA, LOW);
  digitalWrite(motorOneB, LOW);
  digitalWrite(motorTwoA, LOW);
  digitalWrite(motorTwoB, LOW);
}

void notFound(void) {

  Serial.println("Not found.");
  server.send(404, "application/json", "{ \"message\" : \"Resource not found.\" }");

  digitalWrite(motorOneA, LOW);
  digitalWrite(motorOneB, LOW);
  digitalWrite(motorTwoA, LOW);
  digitalWrite(motorTwoB, LOW);
}

void loop(void) {
  server.handleClient();
}
