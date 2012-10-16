class AudioThread {
  
  Reverb revL;
  Reverb revR;
  float samples[];
  float boidsOutput[];
  float tempBoidData[];
  float tempRevData[]; 
  boolean one = false;

  AudioThread() {
    revL = new Reverb(88200, 44100, 0.5);
    revR = new Reverb(88200, 44100, 0.5);
    samples = new float[1024];
    boidsOutput = new float[2];
    tempBoidData = new float[2];
    tempRevData = new float[2];
  }

  void initAudio() {
    new Thread( new Runnable() {
      public void run() {
        
        while (true) {
          if (audioOn) {
            for ( int i = 0; i < samples.length; i+=2 ) {
              
              boidsOutput[0] = boidsOutput[1] = 0;

              for (int j=0;j<=boidDisplayNumClicker.val;j++) {
                tempBoidData = boidArray[j].wtOutStereo();
                boidsOutput[0] += tempBoidData[0];
                boidsOutput[1] += tempBoidData[1];

              }

              boidsOutput[0] /= boidDisplayNumClicker.val+3;
              boidsOutput[1] /= boidDisplayNumClicker.val+3;
              

              //        stereoLimiter(boidsOutput[0], boidsOutput[1]);

              //        if (!cluster.isOn) cluster.record((boidsOutput[0] + boidsOutput[1]) * 0.5);

        if(frameCount % 120 == 0 && !one){
          println("playing " +boidsOutput[0]+" "+ millis());
          one = true;
        }
        else if(frameCount % 60 != 0) one = false;

              //        clusterOut = limiter(cluster.play());

              samples[i]   = (boidsOutput[0] );
              samples[i+1] = (boidsOutput[1] );
              
              //        left[i] = (boidsOutput[0] + cluster.play()) * 0.75;
              //        right[i] = (boidsOutput[1] + cluster.play()) * 0.75;
            }
            device.writeSamples( samples );
            device.track.play();
          } 
          else {
            device.track.pause();
          }
        }
      }
    }
    ).start();
  }
  
  void reset(){
    revL = new Reverb(88200, 44100, 0.75);
    revR = new Reverb(88200, 44100, 0.75);
    samples = new float[1024];
    boidsOutput = new float[2];
    tempBoidData = new float[2];
    tempRevData = new float[2];
  }
}

