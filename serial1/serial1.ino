#include <Servo.h>
const int maxHotPin = 6;
const int maxCoolPin = 8;
const int rec = 3;
const int frs = 2;
const int m_vent = 9;
const int m_def =7;
const int m_ac =4;
const int m_rad = 5;
const int m_fan = 10;
const int R_en = A0;
const int L_en = A1;
unsigned long rec_frs = 0;
unsigned long temp = 0;
unsigned long temp_auto = 0;
unsigned long vent_def = 0;
int diff_temp = 0;
float diff_auto = 0;
int diff_rf = 0;
int diff_vd = 0;

void setup() {
  pinMode(maxHotPin, OUTPUT);
  pinMode(maxCoolPin, OUTPUT);
  pinMode(rec,OUTPUT); 
  pinMode(frs, OUTPUT);
  pinMode(m_vent,OUTPUT);
  pinMode(m_def, OUTPUT);
  pinMode(m_fan, OUTPUT);
  pinMode(m_ac, OUTPUT);
  pinMode(m_rad, OUTPUT);
  pinMode(R_en, OUTPUT);
  pinMode(L_en, OUTPUT);

  digitalWrite(R_en,HIGH);
  digitalWrite(L_en, HIGH);
  TCCR1A = (1 << COM1B1) | (1 << WGM11);
  TCCR1B = (1 << WGM13) | (1 << WGM12) | (1 << CS10);
  ICR1 = 800;    
  Serial.begin(9600);
}

void loop() {
  if (Serial.available()) {
    String cmd = Serial.readStringUntil('\n');

    if (cmd.startsWith("temp:")) {
      int diff = cmd.substring(5).toInt();
      if (diff > 0) {
        digitalWrite(maxCoolPin, LOW);
        digitalWrite(maxHotPin, HIGH);
        temp = millis();
        diff_temp = diff;
      } else if (diff < 0) {
        digitalWrite(maxHotPin, LOW);
        digitalWrite(maxCoolPin, HIGH);
        temp = millis();
        diff_temp = abs(diff);
      }
    }
    if(cmd.startsWith("rec:")){
      int diff = cmd.substring(4).toInt();
      if(diff > 0){
        rec_frs = millis();
        digitalWrite(rec,HIGH);
        digitalWrite(frs,LOW);
        diff_rf = diff;
      }
      else if (diff < 0){
        rec_frs = millis();
        digitalWrite(frs,HIGH);
        digitalWrite(rec,LOW);
        diff_rf = abs(diff);
      }
    }
    if(cmd.startsWith("mode:")){
      int diff = cmd.substring(5).toInt();
     if (diff>0){
        digitalWrite(m_vent,HIGH);
        digitalWrite(m_def,LOW);
        vent_def = millis();
        diff_vd = diff;
     }else if(diff<=0){
        digitalWrite(m_vent,LOW);
        digitalWrite(m_def, HIGH);
        vent_def = millis();
        diff_vd = abs(diff);
     }
    } 
    if(cmd.startsWith("fan:")){
      int diff = cmd.substring(4).toInt();
      switch(diff){
        case 0:
          OCR1B = 0;
          break;
        case 1:
          OCR1B = 175;
          break;
        case 2:
          OCR1B = 197;
          break;
        case 3:
          OCR1B = 237;
          break;
        case 4:
          OCR1B = 385;
          break;
        case 5:
          OCR1B = 590;
          break;
      }
    }
    if(cmd.startsWith("ac:")){
        int diff = cmd.substring(3).toInt();
        if(diff == 1){
           digitalWrite(m_ac,HIGH);
           digitalWrite(m_rad, HIGH);
        }
        else if (diff == 0){
            digitalWrite(m_ac, LOW);
            digitalWrite(m_rad, LOW);
        }
    }
  }
if( millis()-rec_frs >= (diff_rf*1000)){
  digitalWrite(rec,LOW);
  digitalWrite(frs,LOW);
  }
if(millis() - temp >= (diff_temp *  450)){
  digitalWrite(maxCoolPin, LOW);
  digitalWrite(maxHotPin, LOW);
}
if(millis()- vent_def >= (diff_vd*1000)){
  digitalWrite(m_def,LOW);
  digitalWrite(m_vent,LOW);
}
}
