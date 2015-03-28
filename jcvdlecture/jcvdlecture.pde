/**
 * Loop. 
 * 
 * Shows how to load and play a QuickTime movie file.  
 *
 */

import processing.video.*;

Movie movie;
int numPixels;
int blockSize = 10;
//Movie myMovie;
color myMovieColors[];
PImage img;


void setup() {
  size(640, 360);
  background(0);
  // Load and play the video in a loop
  movie = new Movie(this, "jcvd.mp4");
  movie.loop();
  numPixels = width;
  myMovieColors = new color[numPixels * numPixels];

}

void movieEvent(Movie m) {
  m.read();
  m.loadPixels();
 // img.loadPixels();
  for (int j = 0; j < numPixels; j++) {
    for (int i = 0; i < numPixels; i++) {
      myMovieColors[j*numPixels + i] = m.get(i, j);
    }
  }

}

void draw() {
  //if (movie.available() == true) {
  //  movie.read(); 
  //}
  for (int j = 0; j < numPixels; j++) {
    for (int i = 0; i < numPixels; i++) {
     // fill(myMovieColors[j*numPixels + i],mouseX*i);
     // rect(i*blockSize, j*blockSize, blockSize-1, blockSize-1);
          int loc = i + j*numPixels;
    // Get the R,G,B values from image
 /*   float r = red   (m.pixels[loc]);
    float g = green (m.pixels[loc]);
    float b = blue  (img.pixels[loc]);
    // Change brightness according to the mouse here
    float adjustBrightness = ((float) mouseX / width) * 8.0;
    r *= adjustBrightness;
    g *= adjustBrightness;
    b *= adjustBrightness;
    // Constrain RGB to between 0-255
    r = constrain(r,0,255);
    g = constrain(g,0,255);
    b = constrain(b,0,255);
    // Make a new color and set pixel in the window
    color c = color(r,g,b);
    pixels[loc] = c;
   */
    }
  //  updatePixels();
  }

  image(movie, 0, 0, width, height);
}

void mousePressed(){
 int x=mouseX;
int y=mouseY;
color cVert=get(x,y);
    float r = red   (get(x,y));
    float g = green (get(x,y));
    float b = blue  (get(x,y));
println(r+" "+g+" "+b );
}
