import processing.net.*;

// The serial port:
Server myServer;
Client myClient;

byte[] frame = new byte[9840];

PGraphics pg;

void setup() {
  size(640, 480);
  pg = createGraphics(80, 60);
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

  int maxPixel = 0;
  int minPixel = 16384;

  pg.beginDraw();
  pg.loadPixels();
  for (int y = 0; y < 60; y++) {
    for (int x = 0; x <80; x++) {
      int i = y * 164 + 2*x + 4;
      int pixel = 256 * (0xff & frame[i]) + (0xff & frame[i + 1]);
      if (pixel > maxPixel) {
        maxPixel = pixel;
      }
      if (pixel < minPixel) {
        minPixel = pixel;
      }
      if (pixel < 8000) {
        pixel = 8000;
      } else if (pixel > 8500) {
        pixel = 8500;
      }
      pixel = (int) map(pixel, 8000, 8500, 0, 255);
//      pixel >>= 4;
      pixel &= 0xff;
      color c = color(pixel);
      pg.pixels[y * pg.width + x] = c;
    }
  }
  pg.updatePixels();
  pg.endDraw();
  
  
//  println("maxPixel = " + maxPixel + ", minPixel = " + minPixel);
  
  image(pg, 0, 0, 640, 480);
}


