import processing.net.*;

// The serial port:
Server myServer;
Client myClient;

int x = 0;
int y = 0;

byte[] data;

void setup() {
  data = new byte[4720];
  int m = 0;
  for (int k = 0; k < 59; k++) {
    for (int l = 0; l < 80; l++) {
      data[m++] = (byte)(2 * k);
    }
  }

  myServer = new Server(this, 11539);
}

void draw() {
  if (myClient == null) {
    myClient = myServer.available();
    if (myClient == null) {
      return;
    }
    println("Connected!");
  }

  byte[] data = myClient.readBytes();
  if (data == null) {
    println("data == null");
    return;
  }

  println("read " + data.length + " bytes");

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


