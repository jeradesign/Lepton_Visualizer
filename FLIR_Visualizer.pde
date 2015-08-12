import processing.net.*;

// The serial port:
Server myServer;
Client myClient;

byte[] frame = new byte[9840];

void setup() {
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

  if (myClient.available() < 9840) {
    return;
  }

  int result = myClient.readBytes(frame);

  println("read " + frame.length + " bytes");

  loadPixels();
  for (int y = 0; y < 60; y++) {
    for (int x = 0; x <80; x++) {
      int i = y * 164 + 2*x + 5;
      color c = color(0xff & frame[i]);
      pixels[y * width + x] = c;
    }
  }
  updatePixels();
}


