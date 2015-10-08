import processing.net.*;

final int FRAMESIZE = 9840;
final int ROWS = 60;
final int COLS = 80;
final int ROWSIZE = 164;
final int MIN_TEMP = 8100;
final int MAX_TEMP = 8400;

// The serial port:
Server myServer;
Client myClient;

byte[] frame = new byte[FRAMESIZE];

PGraphics pg;

long lastBadFrame = -1;

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

  if (!myClient.active()) {
    myClient = null;
    return;
  }

  if (myClient.available() < FRAMESIZE) {
    return;
  }

  int result = myClient.readBytes(frame);

  if (result != FRAMESIZE) {
    println("bad FRAMESIZE = " + result);
  }

//  checkFrame();

  int maxPixel = 0;
  int minPixel = 16384;

  pg.beginDraw();
  pg.loadPixels();
  for (int y = 0; y < ROWS; y++) {
    for (int x = 0; x <COLS; x++) {
      int i = y * ROWSIZE + 2*x + 4;
      int pixel = 256 * (0xff & frame[i]) + (0xff & frame[i + 1]);
      if (pixel > maxPixel) {
        maxPixel = pixel;
      }
      if (pixel < minPixel) {
        minPixel = pixel;
      }
      if (pixel < MIN_TEMP) {
        pixel = MIN_TEMP;
      } else if (pixel > MAX_TEMP) {
        pixel = MAX_TEMP;
      }
      pixel = (int) map(pixel, MIN_TEMP, MAX_TEMP, 0, 255);
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
//  println("frame " + frameCount);
}

void checkFrame() {
  for (int i = 0; i < ROWS; i++) {
    int rowNumber = 256 * (0x0f & frame[i * ROWSIZE]) + (0xff & frame[i * ROWSIZE + 1]);
    if (rowNumber != i) {
      println("bad rowNumber. expected " + i + ", got " + rowNumber);
      if (lastBadFrame != frameCount) {
        saveBytes("badframe-" + frameCount + ".dat", frame);
        lastBadFrame = frameCount;
      }
//      System.exit(1);
    }
  }
}
