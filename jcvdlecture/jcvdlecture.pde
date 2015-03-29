import java.util.Date;
import java.text.SimpleDateFormat;
import java.text.DateFormat;
/**
 * Loop.
 *
 * Shows how to load and play a QuickTime movie file.
 *
 */

import processing.video.*;
import ddf.minim.*;

Minim minim;
AudioInput in;
AudioRecorder recorder;

Movie movie;

Capture capture;
int numPixels;
int nb=0;
  DateFormat dateFormat = new SimpleDateFormat("dd-MM-yy_HH-mm-ss");
  Date date = new Date();

void setup() {
  size(1280, 720);
  background(0);

  // initialize capture
  capture = new Capture(this, width, height);
  capture.start();
  numPixels = capture.width * capture.height;
  loadPixels();

  // Load and play the video in a loop
 // movie = new Movie(this, "https://github.com/fhacktory/hackjcvd/blob/master/jcvdlecture/data/jcvd.mp4?raw=true");
 movie = new Movie(this, "jcvd.mp4");
  movie.loop();
  numPixels = width;

  // get sound recorder
  minim = new Minim(this);
  in = minim.getLineIn();
  //recorder = minim.createRecorder(in, "myrecording.wav");

  //gestion de plusieurs fichiers son

  recorder = minim.createRecorder(in, "export/son/"+dateFormat.format(date)+"_jcvd.wav");
  //System.out.println(dateFormat.format(date));

  textFont(createFont("Arial", 12));
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

  if ( recorder.isRecording() )
  {
    text("Enregistrement en cours, appuyez sur R pour arrêter...", 5, 15);
      saveFrame("export/images/"+dateFormat.format(date)+"_img"+nb+".tga");
  nb++;
  } else
  {
    text("Appuyer sur R pour enregistrer.", 5, 15);
  }
  

}


void keyReleased()
{
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
    } else 
    {
      recorder.beginRecord();
      date = new Date();
    }
  }
 /* if ( key == 's' )
  {
    // we've filled the file out buffer, 
    // now write it to the file we specified in createRecorder
    // in the case of buffered recording, if the buffer is large, 
    // this will appear to freeze the sketch for sometime
    // in the case of streamed recording, 
    // it will not freeze as the data is already in the file and all that is being done
    // is closing the file.
    // the method returns the recorded audio as an AudioRecording, 
    // see the example  AudioRecorder >> RecordAndPlayback for more about that
    recorder.save();
    println("Done saving.");
  }*/
}
