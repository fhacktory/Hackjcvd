/**
 * Loop.
 *
 * Shows how to load and play a QuickTime movie file.
 *
 */

import processing.video.*;
import ddf.minim.*;
import g4p_controls.*;


Minim minim;
AudioInput in;
AudioRecorder recorder;
boolean flag;
int videoId;

Movie movie;

Capture capture;
int numPixels;
int nb=0;

VideoOutput vo;

void setup() {
  if (!flag) {
    size(640, 360);
    createGUI();
    customGUI();
  //  println("pas sette");
    vo = new VideoOutput(this.g, sketchPath, "export/jeanClaude.mp4", 30);
  }



  if (!flag) {
  //  println("pas sette 2");

    return;
  }

 // println("c'est sette ");

  // initialize capture
  capture = new Capture(this, width, height);
  capture.start();
  numPixels = capture.width * capture.height;
  loadPixels();
  String[]  paths;
  paths = new String[] {
    "kata1.mp4", "armed.mp4", "off.mp4"
  };



  // Load and play the video in a loop
  movie = new Movie(this, paths[videoId]);
  movie.loop();
  numPixels = width;
  
  // get sound recorder
  minim = new Minim(this);
  in = minim.getLineIn();
  recorder = minim.createRecorder(in, "export/sound.wav");
}

void draw() {
 // println("debut draw ");

  if (!flag) {
   // println("pas sete draw ");

    return;
  }
  if (capture.available()) {
    capture.read(); // Read a new video frame
  }

  if (movie.available() == true) {
    movie.read();
  }
  // get sound recorder
//  minim = new Minim(this);
 // in = minim.getLineIn();
 // recorder = minim.createRecorder(in, "export/sound.wav");

  textFont(createFont("Arial", 12));

  for (int i = 0; i < width; i++) { 
    for (int j = 0; j < height; j++) {
      int loc = i + j*numPixels;
      // Get the R,G,B values from image
      float r = red   (movie.pixels[loc]);
      float g = green (movie.pixels[loc]);
      float b = blue  (movie.pixels[loc]);

      float distToGreen = (r-13) * (r-13) + (g-163) * (g-163) + (b - 37) * (b - 37); 

      // check if jcvd is green
      if (distToGreen < 10000) {
        // display capture horizontally flipped
        int loc2 = (width - i - 1) + j*numPixels;
        pixels[loc] = capture.pixels[loc2];
      } else
        // display jcvd
      pixels[loc] = movie.pixels[loc];
    }
  }  
  updatePixels();

  // draw the waveforms

    if ( recorder.isRecording() ) {
   // text("Enregistrement en cours, appuyez sur R pour arrêter...", 5, 15);
    //saveFrame("export/img"+String.format("%05d", nb)+".tga");
    //nb++;
    vo.saveFrame();
  } else
  {
    text("Appuyer sur R pour enregistrer.", 5, 15);
  }
}


void keyReleased()
{
   if ( key == 's' ) 
  {exit();
  }
  if ( key == 'r' ) 
  {
    // to indicate that you want to start or stop capturing audio data, you must call
    // beginRecord() and endRecord() on the AudioRecorder object. You can start and stop
    // as many times as you like, the audio data will be appended to the end of the buffer 
    // (in the case of buffered recording) or to the end of the file (in the case of streamed recording). 
    if ( recorder.isRecording() ) 
    {
      recorder.endRecord();
      recorder.save();
      vo.close();
    } else 
    {
      recorder.beginRecord();
    }
  }
}
// Use this method to add additional statements
// to customise the GUI controls
public void customGUI() {
}

public void loadVideo(int i) {
  flag = true;

  if (i<0) {
    flag = false;
  }
  videoId = i;
  
  setup();
}
