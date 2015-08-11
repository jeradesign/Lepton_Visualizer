import processing.serial.*;

// The serial port:
Serial myPort;

int x = 0;
int y = 0;

byte[] data;

void setup() {
  // List all the available serial ports:
  println(Serial.list());

  data = new byte[4720];
  int m = 0;
  for (int k = 0; k < 59; k++) {
    for (int l = 0; l < 80; l++) {
      data[m++] = (byte)(2 * k);
    }
  }
  myPort = new Serial(this, "/dev/cu.usbserial-A903C363", 115200);
  println(myPort.readStringUntil(10));
  println(myPort.readStringUntil(10));

  myPort.write("./FollowMe\r");
}

void draw() {
  if (myPort.available() == 0) {
    return;
  }
  byte[] data = myPort.readBytes();

  loadPixels();
  for (int i = 0; i < data.length; i++) {
    color c = color(0xff & data[i]);
    pixels[y * width + x] = c;
    x++;
    if (x >= 80) {
      x = 0;
      y++;
      if (y >= 60) {
        y = 0;
      }
    }
  }
  updatePixels();
}

void mousePressed() {
  myPort.write("\u0003");
  exit(); 
}
