void setup() {
  pinMode(11, OUTPUT);
  Serial.begin(9600);  // start serial to PC 
}

void loop() {  
  if (Serial.available()) {
    char c = Serial.read();

    if(c == 'h') {
        digitalWrite(11,HIGH); //11番ピンの出力をHIGH = 5Vにする
    }

    if (c == 'l') {
        digitalWrite(11,LOW); //11番ピンの出力をLOW = 0Vにする      
    }
    
    Serial.println(c);
  }
}
