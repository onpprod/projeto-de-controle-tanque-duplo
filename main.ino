#include <Wire.h>
#include <Ultrasonic.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27,20,4);

//Define os pinos para o trigger e echo
#define pino_trigger1 4
#define pino_echo1 5
#define pino_trigger2 7
#define pino_echo2 6
#define pino_motor 3
// 
//Inicializa o sensor nos pinos definidos acima
Ultrasonic ultrasonic1(pino_trigger1, pino_echo1);
Ultrasonic ultrasonic2(pino_trigger2, pino_echo2);

int analogPin = 0; // pino para leitura do potenciômetro
int val = 0; //variável para armazenar o valor lido
float tensao = 0.0;
int out = 0;

void setup()
{ 
  Serial.begin(9600);
  Serial.println("Lendo dados do sensor...");
  
  lcd.init(); // initialize the lcd 
  lcd.backlight(); // Print a message to the LCD
  lcd.begin(16,2);

}
 
void loop()
{
  val = analogRead(analogPin);// le o valor analógico
  out = val/4;
  analogWrite(pino_motor, out);


  Serial.println(out);
  lcd.setCursor(0,0);
  lcd.print("Analog: ");
  lcd.print(val);
  lcd.print("    ");

//Le as informacoes do sensor, em cm e pol
  float cmMsec1, inMsec1;
  float cmMsec2, inMsec2;

  long microsec1 = ultrasonic1.timing();
  long microsec2 = ultrasonic2.timing();

  cmMsec1 = ultrasonic1.convert(microsec1, Ultrasonic::CM);
  cmMsec2 = ultrasonic2.convert(microsec2, Ultrasonic::CM);

  //Exibe informacoes no serial monitor
  lcd.setCursor(0,1);
  lcd.print("D1:");
  lcd.print(cmMsec1);
  lcd.print(" ");
  Serial.print("D1:");
  Serial.print(cmMsec1);

  lcd.setCursor(8,1);
  lcd.print("D2:");
  lcd.print(cmMsec2);
  lcd.print(" ");
  Serial.print("D2:");
  Serial.print(cmMsec2);
  delay(1000);
}