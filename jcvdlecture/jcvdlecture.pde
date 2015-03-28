/**
 * Loop.
 *
 * Shows how to load and play a QuickTime movie file.
 *
 */

import processing.video.*;

Movie movie;

Capture capture;
int numPixels;

int blockSize = 10;
PImage img;
color greenMask = -15883483;


void setup() {
  size(1280, 720);
  background(0);

  // initialize capture
  capture = new Capture(this, width, height);
  capture.start();
  numPixels = capture.width * capture.height;
  loadPixels();

  // Load and play the video in a loop
  movie = new Movie(this, "jcvd.mp4");
  movie.loop();
  numPixels = width;
  myMovieColors = new color[numPixels * numPixels];
}

void draw() {
  if (capture.available()) {
    capture.read(); // Read a new video frame
  }

  if (movie.available() == true) {
    movie.read();
  }

  for (int i = 0; i < width; i++) { 
    for (int j = 0; j < height; j++) {
      int loc = i + j*numPixels;
      // Get the R,G,B values from image
      float r = red   (movie.pixels[loc]);
      float g = green (movie.pixels[loc]);
      float b = blue  (movie.pixels[loc]);

      float distToGreen = (r-13) * (r-13) + (g-163) * (g-163) + (b - 37) * (b - 37); 

      if (distToGreen < 10000) {
        int loc2 = (width - i - 1) + j*numPixels;
        pixels[loc] = capture.pixels[loc2];
      }
      else
        pixels[loc] = movie.pixels[loc];
    }
  }  
  updatePixels();
}

void mousePressed() {
  int x=mouseX;
  int y=mouseY;
  color cVert=get(x, y);
  float r = red   (get(x, y));
  float g = green (get(x, y));
  float b = blue  (get(x, y));
  //  println(r+" "+g+" "+b );
  println(cVert);
}

