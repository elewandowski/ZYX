//class MinimAudio implements AudioSignal {
//
//    float samples[] = new float[1024];
//    Reverb revL = new Reverb(22050, 5512, 0.5);
//    Reverb revR = new Reverb(22050, 5512, 0.5);
//    float outputL, outputR, panL, panR, panAngle;
//    float boidsOutput[] = new float[2];
//    float tempBoidData[] = new float[2];
//    float tempRevData[] = new float[2];
//
//
//  MinimAudio() {
//        outputL = outputR = panL = panR = panAngle = 0;
//  }
//
//  void generate(float[] samples) {
//  }
//
//  void generate(float[] left, float[] right) {
//
//    for ( int i = 0; i < left.length; i++ ) {
//
//      if(audioOn){
//        boidsOutput[0] = 0;
//        boidsOutput[1] = 0;
//        tempRevData[0] = 0;
//        tempRevData[1] = 0;
//
//        for (int j=0;j<mMR.posCountX;j++) {
//
//          tempBoidData = boidArray[j].wtOutStereo();
//
//          tempRevData[0] += tempBoidData[0] * boidArray[j].reverbMix;
//          tempRevData[1] += tempBoidData[1] * boidArray[j].reverbMix;
//
//          boidsOutput[0] += tempBoidData[0];
//          boidsOutput[1] += tempBoidData[1];
//        }
//        
//        tempRevData[0] = revL.reverb(tempRevData[0]);
//        tempRevData[1] = revL.reverb(tempRevData[1]);
//        
//        boidsOutput[0] /= mMR.posCountX;
//        boidsOutput[1] /= mMR.posCountX;
//
//        if (!cluster.isOn) cluster.record((boidsOutput[0] + boidsOutput[1]) * 0.5);
//        
//        left[i] = (boidsOutput[0] + cluster.play() + tempRevData[0]*0.5);
//        right[i] = (boidsOutput[1] + cluster.play() + tempRevData[1]*0.5);
//        
////        left[i] = (boidsOutput[0] + cluster.play()) * 0.75;
////        right[i] = (boidsOutput[1] + cluster.play()) * 0.75;
//        
//        stereoLimiter(left[i], right[i]);
//        
////        samples[i]   = (boidsOutput[0] + cluster.play() + tempRevData[0]) * 0.75;
////        samples[i+1] = (boidsOutput[1] + cluster.play() + tempRevData[1]) * 0.75;
////        stereoLimiter(samples[i], samples[i+1]);
//
//        } else {
//          samples[i] = 0;
//          samples[i+1] = 0;
//        }
//    }
//  }
//}

