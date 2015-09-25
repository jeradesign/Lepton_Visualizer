import processing.net.*;

final int ROWS = 60;
final int COLS = 80;
final int ROWSIZE = 164;
final int MIN_TEMP = 8100;
final int MAX_TEMP = 8400;
final int FRAMESIZE = ROWS * COLS * 3;

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
//    println("y = " + y + " ------------------------------------");
    for (int x = 0; x < COLS; x++) {
      int i = 3 * (y * COLS + x);
//      println("x = " + x + ", i = " + i);
      int pixelr = frame[i] & 0xff;
      int pixelg = frame[i + 1] & 0xff;
      int pixelb = frame[i + 2] & 0xff;
//      println("" + pixelr + ", " + pixelg + ", " + pixelb);
      color c = color(pixelr, pixelg, pixelb);
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
