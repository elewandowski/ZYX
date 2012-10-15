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
//              tempRevData[0] = tempRevData[1] = 0;

              for (int j=0;j<=boidDisplayNumClicker.val;j++) {
                tempBoidData = boidArray[j].wtOutStereo();
                boidsOutput[0] += tempBoidData[0];
                boidsOutput[1] += tempBoidData[1];
//                tempRevData[0] += tempBoidData[0] * boidArray[j].reverbMix;
//                tempRevData[1] += tempBoidData[1] * boidArray[j].reverbMix;
              }

//              tempRevData[0] = revL.reverb(tempRevData[0]) / boidDisplayNumClicker.val+1;
//              tempRevData[1] = revR.reverb(tempRevData[1]) / boidDisplayNumClicker.val+1;

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

//void initAudio2() {
//  new Thread( new Runnable() {
//
//    public void run()
//    {     		
//      AndroidAudioDevice device1 = new AndroidAudioDevice();
//      Reverb revL = new Reverb(88200, 44100, 0.75);
//      Reverb revR = new Reverb(88200, 44100, 0.75);
//      float samples[] = new float[1024];
//      float boidsOutput[] = new float[2];
//      float tempBoidData[] = new float[2];
//      float tempRevData[] = new float[2];
//      boolean one = true;
//      //    float outputL, outputR, panL, panR, panAngle, clusterOut;
//      //    outputL = outputR = panL = panR = panAngle = 0;
//
//      while (true)
//      {
//
//        for ( int i = 0; i < samples.length; i+=2 )
//        {
//          if (audioOn) {
//            boidsOutput[0] = 0;
//            boidsOutput[1] = 0;
//            tempRevData[0] = 0;
////            tempRevData[1] = 0;
//
//            for (int j=0;j<=boidDisplayNumClicker.val/2;j++) {
//
//              tempBoidData = boidArray[j].wtOutStereo();
//              boidsOutput[0] += tempBoidData[0];
//              boidsOutput[1] += tempBoidData[1];
//              tempRevData[0] += tempBoidData[0] * boidArray[j].reverbMix;
//              tempRevData[1] += tempBoidData[1] * boidArray[j].reverbMix;
//            }
//
//            tempRevData[0] = revL.reverb(tempRevData[0]) / boidDisplayNumClicker.val+1;
//            tempRevData[1] = revR.reverb(tempRevData[1]) / boidDisplayNumClicker.val+1;
//
//            boidsOutput[0] /= boidDisplayNumClicker.val+1;
//            boidsOutput[1] /= boidDisplayNumClicker.val+1;
//
//            //        stereoLimiter(boidsOutput[0], boidsOutput[1]);
//
//            //        boidsOutput[0] = 
//            //        boidsOutput[1] = 
//
//            //        if (!cluster.isOn) cluster.record((boidsOutput[0] + boidsOutput[1]) * 0.5);
//
//            //        if(frameCount % 60 == 0 && !one){
//            //          println("playing " +boidsOutput[0]+" "+ millis());
//            //          one = true;
//            //        }
//            //        else if(frameCount % 60 != 0) one = false;
//
//            //        clusterOut = limiter(cluster.play());
//
//            samples[i]   = limiter((tempRevData[0] + boidsOutput[0]) * 0.5);
//            samples[i+1] = limiter((tempRevData[1] + boidsOutput[1]) * 0.5);
//
//            //        left[i] = (boidsOutput[0] + cluster.play()) * 0.75;
//            //        right[i] = (boidsOutput[1] + cluster.play()) * 0.75;
//          } 
//          else {
//            samples[i] = 0;
//            samples[i+1] = 0;
//          }
//        }
//        if(audioOn) device1.writeSamples( samples );
////        println("writingSample "+ millis());
//      }
//    }
//  }
//  ).start();
//}

