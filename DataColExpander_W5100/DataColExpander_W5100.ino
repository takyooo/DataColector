// Circuit:
// * Ethernet shield W5100 attached to pins 10, 11, 12, 13

//#include <idDHT11.h>
#include <SPI.h>
#include <Ethernet.h>
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>
#include <DHT.h>
#include <SD.h>;
const int chipSelect = 4;

DHT dht;
LiquidCrystal_I2C lcd(0x38,16,2); 
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
char server[] = "datacol.2n.pl";    // name address for Google (using DNS)
EthernetClient client; // Initialize the Ethernet client library
char UnitName; //This Device Name to define
unsigned long lastReadingTime = 0;
const unsigned long readInterval = 9*100000; //15 minut

void setup(){
  dht.setup(7);
  lcd.init();
  lcd.backlight();
  Serial.begin(57600);
  Serial.print("Initializing SD card...");
  // make sure that the default chip select pin is set to
  // output, even if you don't use it:
  pinMode(10, OUTPUT);
  
  // see if the card is present and can be initialized:
  if (!SD.begin(chipSelect)) {
    Serial.println("Card failed, or not present");
    // don't do anything more:
    return;
  }
  Serial.println("card initialized.");


}
void loop(){
 // Serial.print(millis());
//  Serial.print();
  

  if (millis() - lastReadingTime > readInterval){
    int humidity = dht.getHumidity();
    int temperature = dht.getTemperature();
    Serial.println("Wilgotnosc: ");
    Serial.println(humidity, 1);
    Serial.println("Temperatura: ");
    Serial.println(temperature, 1);
    Serial.println("\n");
    
    File dataFile = SD.open("datalog.txt", FILE_WRITE);
    String dataString = "";
    dataString += "Wilgotnosc: ";
    dataString += String(humidity);
    dataString += " Temperatura: ";
    dataString += String(temperature);
    if (dataFile) {
      dataFile.println(dataString);
      dataFile.close();
      // print to the serial port too:
      Serial.println(dataString);
    }  
  // if the file isn't open, pop up an error:
    else {
      Serial.println("error opening datalog.txt");
      } 
    lastReadingTime = millis();
  }
  //delay(readInterval);
//    while(true);
  
}

// this method makes a HTTP connection to the server:


void sendData(char UnitName, char sensorId, char sensorData, char location) {
  // if there's a successful connection:
  if (client.connect(server, 80)) {
    Serial.println("connecting...");
    delay(1000);
    lcd.print("Server found !");
    lcd.setCursor(0,1);
    //LCD ip adress show
    for (byte thisByte = 0; thisByte < 4; thisByte++) {
      // print the value of each byte of the IP address:
      lcd.print(Ethernet.localIP()[thisByte], DEC);
      lcd.print("."); 
    }
    // send the HTTP PUT request:
    client.println("GET /api/devices/add_device?token_name=");
    client.print(UnitName);
    client.println("&date=");
    client.print("2014-06-30%2023:15:00");
    client.println("&sensor=");
    client.print(sensorId);
    client.println("&value=");
    client.print(sensorData);
    client.println("&window=");
    client.print(location);
    client.println("HTTP/1.1");
    client.println("Host: datacol.2n.pl");
    client.println("User-Agent: arduino-ethernet");
    client.println("Connection: close");
    client.println();
      if (client.available()) {
        char c = client.read();
        Serial.print(c);
      }
      if (!client.connected()) {
        Serial.println();
        Serial.println("disconnecting.");
        client.stop();
       
      } 
  else {
    // if you couldn't make a connection:
    Serial.println("connection failed");
    Serial.println("disconnecting.");
    client.stop();
    }
  }
}
