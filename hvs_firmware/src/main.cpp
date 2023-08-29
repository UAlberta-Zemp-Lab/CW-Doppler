#include <Arduino.h>

usb_serial_class& pc = Serial;
uint8_t ledPin = 13;
uint8_t dataPin = 14;
uint8_t clkPin = 15;
uint8_t latchPin = 16;
uint8_t clrPin = 17;

void setup() {
    pc.begin(115200);

    pinMode(ledPin, OUTPUT);
    pinMode(dataPin, OUTPUT);
    pinMode(clkPin, OUTPUT);
    pinMode(latchPin, OUTPUT);
    pinMode(clrPin, OUTPUT);

    digitalWrite(ledPin, LOW);
    digitalWrite(dataPin, LOW);
    digitalWrite(clkPin, LOW);
    digitalWrite(latchPin, LOW);
    digitalWrite(clrPin, LOW);
    
    for (int i = 0; i < 2; i++) {
        digitalWrite(ledPin, HIGH);
        delay(100);
        digitalWrite(ledPin, LOW);
        delay(100);
    }
}

void loop() {
    uint8_t buffer[4];
    if (pc.available() > 3) {
        if (pc.readBytes((char *)buffer, 4) > 4) {
            pc.println("Warning: Extra data sent, ignoring...");
        }
    
        /* Send 32 bits of data */
        // TODO: Consider properly using latch enable. Still haven't figured out the correct timing
        for (int byte = 3; byte >= 0; byte--) {
            for (int bit = 7; bit >= 0; bit--) {
                uint8_t data = (buffer[byte] >> bit) & 1;
                digitalWrite(dataPin, data);
                digitalWrite(ledPin, data);
                digitalWrite(clkPin, LOW);
                delay(50);
                digitalWrite(clkPin, HIGH);
            }
        }
    }
}