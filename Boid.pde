class Boid {

  int thisBoid, audioType, visualType, colR, colG, colB, wtIndex, wtIndexMod, lastClockCount, modOut, modCentre, modAmount;
  float x, y, xA, yA, accelerationX, accelerationY, size, freq, pan, wtOut, modFreq, mouseDist, zNorm, distance, rotX, rotY, rotZ, scrnX, scrnY, weight, glideX, glideY;
  boolean isOn;
  //  int wTType = (int) random(6);

  float [] stereoOut;
  float [] control = new float[mMR.mapArray.length];
  int [] segmentCount = new int[control.length];
  int [] segmentDist = new int[control.length];
  float [] segmentDiff = new float[control.length];

  float z, volume, pitchCentre, envelopeTime, filterCutOff, delayTime, delayFeedback, reverbMix, reverbFeedback, distortion;
  float colour;
  int filterType;

  Shard s;
  Envelope e;
  Delay d;
  Filter f;
  Filter freqFilter, panFilter, volFilter, delayTimeFilter;
//  Filter[] controlFilters = new Filter[control.length];

  Boid (float x, float y, int size, int thisBoid, int type) {

    this.x = x;
    this.y = y;
    this.size = size;
    this.thisBoid = thisBoid;
    visualType = audioType = type;
    
    xA = random(-1, 1);
    yA = random(-1, 1);
    weight = random(0.9, 1);
    
    s = new Shard(x, y, size, size);
    e = new Envelope (1, 10, 1, 100);
    freqFilter = new Filter(0.35);
    volFilter = new Filter(0.01);
    panFilter = new Filter(0.01);
    delayTimeFilter = new Filter(0.1);
    f = new Filter(1);
    d = new Delay(44100, (int)random(200, 22100), delayFeedback);
  }
  
  void reset(){
    isOn = true;
    stereoOut = new float [2];
    delayFeedback = 0.66;
    reverbMix = 0.5f;
    pitchCentre = 220;
    distortion = colour = 1;
    volume = .75;
    glideX = 0;
    glideY = 0;
    modAmount = 0;
    modCentre = 24;
    z = width/4;
    e.on = true;
    d.mix = 0;
    d.erase();
  }

  public void update() {
    
    scrnX = screenX(x,y,z);
    scrnY = screenY(x,y,z);
    
    if(scrnX > 0 && scrnX < width && scrnY > 0 && scrnY < height){
      xA *= friction;
      yA *= friction;
    } else {
      xA -= 0.1 * weight;
      yA -= 0.1 * weight; 
    }

    for (int i=0; i <=boidDisplayNumClicker.val; i++) {
      
      if (i!=thisBoid) {
        distance = dist(boidArray[i].x, boidArray[i].y, x, y);
        if (distance < size/2 && boidArray[i].isOn && isOn) {
          if(e.on) e.queue();      
          stroke(255);
          line(boidArray[i].x, boidArray[i].y, boidArray[i].z, x, y, z);
        } 
      }
    }
    
    x += xA + glideX;
    y += yA + glideY;

    if (x >= width) x = 1;
    else if (x <= 0) x = width-1;
    if (y >= height) y = 1;
    else if (y <= 0) y = height-1;

    s.update(x, y);
    newFreq();
    newModFreq();

    //only do interpolation once every new mcClockCount
    for (int i=0; i<mMR.mapArray.length; i++) {
      if (mMR.mapArray[i].positions[thisBoid][segmentCount[i]] != null) {
        interpolate(i);
        sendAudioMapping(mMR.mapArray[i].mappingAudio, control[i]);
        sendVisualMapping(mMR.mapArray[i].mappingVisual, control[i], mMR.mapArray[i].mappingAudio);
      }
    }
  }

  public void display() {
    stroke(255*colour+35, colG*colour+35, colB*colour+35);
    fill(255*colour+35, colG*colour+35, colB*colour+35);
    pushMatrix();
    translate(0, 0, z);
    s.display(visualType);
    popMatrix();
  }

  void mousePressed() {
    //    if(!prevMousePressed){
    //      prevMX = thisMX = mouseX;
    //      prevMY = thisMY = mouseY;
    //    }
  }

  void mouseDragged() {
    if (mouseX != prevMX && mouseY != prevMY) {
      mouseDist = dist(mouseX, mouseY, screenX(x + grid.xCor, y, z), screenY(x, y + grid.yCor, z));
      if (mouseDist < size/8) {
        accelerationX = ( (mouseX-prevMX) / (size/8) ) * force;
        accelerationY = ( (mouseY-prevMY) / (size/8) ) * force;
        xA += accelerationX * weight;
        yA += accelerationY * weight;
      }
    }
  }

  public void interpolate(int i) {

    if (clockCount != this.lastClockCount) {
      //      println("keBlac " + thisBoid +" "+ clockCount +" "+ this.lastClockCount +" "+ segmentCount[i] +" "+ mMR.mapArray[i].positions[thisBoid][segmentCount[i]].segment +" "+ mMR.mapArray[i].positions[thisBoid][segmentCount[i]].val);
      if (mMR.mapArray[i].positions[thisBoid][segmentCount[i]].segment < clockCount && mMR.mapArray[i].positions[thisBoid][segmentCount[i]+1] != null) {
        segmentDiff[i] = mMR.mapArray[i].positions[thisBoid][segmentCount[i]+1].val - mMR.mapArray[i].positions[thisBoid][segmentCount[i]].val;
        segmentDist[i] = mMR.mapArray[i].positions[thisBoid][segmentCount[i]+1].segment - mMR.mapArray[i].positions[thisBoid][segmentCount[i]].segment;
        segmentCount[i]++;
      }

      if (i == mMR.mapArray.length-1) this.lastClockCount = clockCount;
      control[i] = mMR.mapArray[i].positions[thisBoid][segmentCount[i]].val;
    } else {
//      control[i] += ((float)segmentDiff[i] / segmentDist[i]) / (clockSpeed / frameRate);
//      if(frameCount % 60 == 0) println(control[i] +" "+ segmentDiff[i] +" "+ segmentDist[i] +" "+ frameRate +" "+ (((float)segmentDiff[i] / segmentDist[i]) / (clockSpeed / frameRate)));
    }
  }

  public void resetCount() {
    for (int i=0; i<segmentCount.length; i++) segmentCount[i] = 0;
  }

  public void newFreq() {
    freq = freqFilter.loPass(abs((1-(y/height))));
  }
  
  void newModFreq(){
    modFreq = abs((float)x/width);
  }

  public float[] wtOutStereo() {
    if (isOn) { 
      pan = panFilter.loPass((float)x/width);
      stereoOut[0] = distortion(f.filter(d.delay(e.env(wtOut())), filterType), distortion) * sqrt(1-pan);
      stereoOut[1] = distortion(f.filter(d.delay(e.env(wtOut())), filterType), distortion) * sqrt(pan);
    } else {
      stereoOut[0] = 0;
      stereoOut[1] = 0;
    }
    return stereoOut;
  }

  public float wtOut() {
    
//    if(wtIndex < 0) wtIndex = abs(wtIndex);
//    else if(wtIndex > 44099) wtIndex = wtIndex - 44100; 
    
    wtOut = waveTableArray[audioType].waveTable[wtIndex] * volFilter.loPass(volume);
    wtIndex += abs(int(20 + freq * pitchCentre)) + modOut;
    if(wtIndex < 0) wtIndex = abs(wtIndex) % 44100;
    else if(wtIndex >= 44100) wtIndex %= 44100;
    
    modOut = int(waveTableArray[audioType].waveTable[wtIndexMod] * modAmount);
    wtIndexMod += int(modFreq * modCentre);
    if(wtIndexMod < 0) wtIndexMod = abs(wtIndexMod) % 44100;
    else if(wtIndexMod >= 44100) wtIndexMod %= 44100;
    
    return wtOut;
  }

  public void sendAudioMapping(int caseNum, float control) {
    
    switch(caseNum) {

    case 0: 
      volume = control;
      break;

    case 1: 
      pitchCentre = int(pow(control*10, 2) * 30);
      break;

    case 2:
      if (control > OFF_THRESHOLD) {
        e.on = true;
        e.setAttack(pow(control*10, 2) * 30); 
      } else{
        e.on = false;
      }
      break;

    case 3:
     if (control > OFF_THRESHOLD) {
       e.on = true;
       e.setDecay(pow(control*10, 2) * 30);
     } else{
       e.on = false;
//       println("env = off");
     }
      break;

    case 4: 
    if (control > OFF_THRESHOLD) {
      f.on = true;
      f.cutOff = control;
    } else f.on = false;
//      println("setting cutoff "+control);
      break;

    case 5: 
    if (control > 0.33) {
      f.on = true;
      filterType = int(((control) * 4) - 0.1 ); 
    } else f.on = false;
//      println("settingFilterType "+int((control * 3) ));
      break;

    case 6:
      if (control > OFF_THRESHOLD) {
        d.mix = 0.5;
        d.delayTime = 10 + int(delayTimeFilter.loPass(control) * 22050);
      } else d.mix = 0;
      break;

    case 7:
      if (control > OFF_THRESHOLD) {
        d.mix = 0.5;
        d.feedback = control*0.98;
      } else d.mix = 0;
      break;

    case 8:
      if (control > OFF_THRESHOLD) {
        modCentre = int(control * 50);
      } else{
        modCentre = 0;
      }
      break;

    case 9:
      if (control > OFF_THRESHOLD) {
        modAmount = int(control * 50);
      } else {
        modAmount = 0;
      }
      break;

    case 10: 
      distortion = 1 + control*5; 
      break;

    case 11: 
      setAudioType(int(control * 5 - 0.1)); 
      break;

    default: 
      break;
    }
  }

  public void sendVisualMapping(int caseNum, float control, int audioMapping) {
    
    if(audioMapping == 2 || audioMapping == 3) control = e.env;
    
    switch(caseNum) {

    case 0: 
      if (control > OFF_THRESHOLD) {
        z = -control * (width) + width*0.5;
        zNorm = control;
        isOn = true;
//        if(frameCount % 30==0) println(thisBoid+ "is on ");
      }
      else isOn = false;
      break;

    case 1: 
      s.setSize(0.1 + control*1.5);
//      println("setting Size");
      break;

    case 2:
      colour = control;
      break;
      
    case 3:
    if (control > OFF_THRESHOLD) {
      glideX = accelerationX * control;
      glideY = accelerationY * control;
    } else {
      glideX = 0;
      glideY = 0;
    }
      break;

    case 4:
      s.setRot(control);
      break;

    case 5://DELAYTIME
      
      break;

    case 6://DELAYFEEDBACK

      break;

    case 7://REVERBMIX

      break;

    case 8://REVERBFEEDBACK

      break;

    case 9://DISTORTION
      
      break;
      //BOIDTYPE
    case 10: 
      setVisualType(int(control * 6)); 
      break;
    }
  }

  public void setVisualType(int type) {

    visualType = type;
    switch(type) {
    case 0://sin
      colG = 100;
      colB = 150;
      break;    
    case 1://tri
      colG = colB = 100;
      break;
    case 2://saw
      colG = 255;
      colB = 0;
      break;
    case 3://square
      colG = 150;
      colB = 45;
      break;
    case 4://noise
      colB = colG = 255;
      break;
    case 5://harm
      colB = colG = 50;
      break;
    }
  }

  public void setAudioType(int type) {
    audioType = type;
  }
}

