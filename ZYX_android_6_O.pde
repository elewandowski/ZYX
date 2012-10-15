//import ddf.minim.*;
//import ddf.minim.signals.*;
//Minim minim;
//AudioOutput out;
//MinimAudio mAudio;

int interpMax = 20;
int clockCount = 1;
int clockSpeed = 3000;
float force = 8;
float friction = 0.9;
float OFF_THRESHOLD = 0.1;
int STATE = 0;
int colSchemeDark = 50;

PFont font, smallFont;
boolean audioOn, prevMousePressed, prevClock;
int cntrlSpX, cntrlSpY, mX, mY, thisMX, thisMY, prevMX, prevMY;

Clicker boidTypeClicker, boidEditNumClicker, boidDisplayNumClicker;
Boid[] boidArray;
WaveTable[] waveTableArray;
Button[] saveButtonArray;
Button backButton, forwardButton;
//Repellent repellent;
ThreeDGrid grid;
MasterMapRect mMR;
//Cluster cluster;
FileWriter fileWriter;
FileReader fileReader;
AudioThread audioThread;
AndroidAudioDevice device = new AndroidAudioDevice();

HashMap hmA = new HashMap();
HashMap hmV = new HashMap();
String[] parameterListAudio = {"volume", "pitchCentre", "attackTime", "decayTime", "filterCutOff", "filterType", "delayTime", "delayFeedback", "FMmodCentre", "FMmodAmount", "distortion", "boidAudioType", "noMapping"};
String[] parameterListVisual = {"zPosition", "size", "colour", "glideAmount", "rotationSpeed", " ", "yPosition", "...", "...", "...", "boidVisualType", "noMapping"};
String[] boidType = {"sin", "tri", "saw", "sqr", "nse", "hrm"};

void setup() {
  size(screenWidth, screenHeight, OPENGL);
  orientation(LANDSCAPE);
  noLights();

  //  minim = new Minim(this);
  //  out = minim.getLineOut(Minim.STEREO, 2048);
  //  mAudio = new MinimAudio();
  
  audioThread = new AudioThread();
  fileWriter = new FileWriter();
  fileReader = new FileReader();
  font = loadFont("DejaVuSans-ExtraLight-64.vlw");
  smallFont = loadFont("DejaVuSansMono-24.vlw");
  textFont(font);

  waveTableArray = new WaveTable[6];
  boidArray = new Boid[16];
  grid = new ThreeDGrid(int(width/1.5), int(width/1.5));
//  cluster = new Cluster(5000, width/2, 20);
  mMR = new MasterMapRect(5);
//  repellent = new Repellent();
  backButton = new Button(width/32, width/32, width/16, width/16);
  forwardButton = new Button(width/32*29, width/32, width/16, width/16);
  saveButtonArray = new Button[8];
  boidEditNumClicker = new Clicker(width/8, width/32, width/16);
  boidTypeClicker = new Clicker(width/32*11, width/32, width/16, boidType);
  boidDisplayNumClicker = new Clicker(width/16*9, width/32, width/16);

  for (int i=0; i<parameterListAudio.length; i++) hmA.put(parameterListAudio[i], i);
  for (int i=0; i<parameterListVisual.length; i++) hmV.put(parameterListVisual[i], i);
  for (int i=0; i<waveTableArray.length; i++) waveTableArray[i] = new WaveTable(i);
  for (int i=0; i<boidArray.length; i++) boidArray[i] = new Boid(random(width/4, width/4*3), random(height/4, height/4*3), 500, i, 0);
  int tSize = width/16;
  int totalSize = int(((tSize + (width/8*0.125))*4));
  int totalHeight = int(((tSize + (width/8*0.125))*2));
  for (int i=0; i<saveButtonArray.length; i++) saveButtonArray[i] = new Button(width/2 - totalSize/4*3 + int((width/8*1.125)*(i%4)) - 10, int((width/8*1.125)*(i/4)) + totalSize/16*10, tSize, tSize);

  audioThread.initAudio();
//  initAudio2();
}

void draw() {

  switch(STATE) {

    //////////////////////////////////////////
  case 0:
    background(0);
    textSize(64);
    textAlign(CENTER);
    for(int i=0; i<width+textWidth("ZYX"); i+=textWidth("ZYX")){
      fill(colSchemeDark);
      text("ZYX", i, height/8);
    }   
    textSize(48);
    textAlign(LEFT);
    for (int i=0; i<saveButtonArray.length; i++) {
      fill(255);
      text(i, saveButtonArray[i].x, saveButtonArray[i].y - saveButtonArray[i].h/4);
      saveButtonArray[i].display();
    }
    textSize(64);
    fill(255);
    textAlign(CENTER);
    text("select your composition", width/2, height/8*7);
    break;

    //////////////////////////////////////////  
  case 1:

    if (!mousePressed && prevMousePressed) mouseReleased();
    background(colSchemeDark/4);
    mMR.display();
    backButton.display();
    forwardButton.display();
    boidEditNumClicker.display();
    boidDisplayNumClicker.display();
    boidTypeClicker.display();
    break;

    //////////////////////////////////////////
  case 2:

    if (!mousePressed && prevMousePressed) mouseReleased();
    hint(ENABLE_DEPTH_TEST);
    background(0);
    if (!prevClock && millis()%clockSpeed < clockSpeed/2) {
      prevClock = true;
      clockCount++;
      if (clockCount >= mMR.mapArray[0].positions[0].length) {
        resetClock();
        STATE = 1;
        break;
      }
    } 
    else if (millis()%clockSpeed > clockSpeed/2) prevClock = false;

    //    repellent.update();
    //    repellent.display();

    directionalLight(255, 255, 255, -1, 0, 0);
    pushMatrix();
    grid.update(mouseX, mouseY);
    grid.display();


    for (int i=0; i<=boidDisplayNumClicker.val; i++) {
      boidArray[i].update();
      if (boidArray[i].isOn)boidArray[i].display();
    }
    

//    cluster.display();
    popMatrix();

    noLights();
    hint(DISABLE_DEPTH_TEST);
    backButton.display();
    fill(255);
    textSize(20);
    text(frameRate, width - 100, height - 10);
    text(clockCount, width - 100, height - 25);

    break;
  }
}

void mousePressed() {

  prevMX = mouseX;
  prevMY = mouseY;

  switch(STATE) {

  case 0:
    for (int i=0; i<saveButtonArray.length; i++) {
      saveButtonArray[i].mousePressed(mouseX, mouseY);
      if (saveButtonArray[i].on) {
        fileReader.read(i+1);
        saveButtonArray[i].on = false;
        STATE = 1;
        break;
      }
    }
    break;

  case 1:

    backButton.mousePressed(mouseX, mouseY);
    forwardButton.mousePressed(mouseX, mouseY);

    if (forwardButton.on == true) {
      STATE = 2;
      resetClock();
      audioThread.reset();
      fileWriter.createSaveFile();
      mMR.saveData();
      fileWriter.write();
      forwardButton.on = false;
      for (int i=0; i<=boidDisplayNumClicker.val; i++) {
        boidArray[i].reset();
        boidArray[i].setAudioType(mMR.boidTypes[i]);
        boidArray[i].setVisualType(mMR.boidTypes[i]);
      }
      audioOn = true;
    }
    if (backButton.on == true) {
      STATE = 0;
      backButton.on = false;
      fileWriter.createSaveFile();
      mMR.saveData();
      fileWriter.write();
      mMR.eraseData();
    }

    boidEditNumClicker.mousePressed(mouseX, mouseY);
    if (boidEditNumClicker.lOn || boidEditNumClicker.rOn){
      if (boidEditNumClicker.val > mMR.posCountXMax && boidDisplayNumClicker.val < boidEditNumClicker.val) boidDisplayNumClicker.val = boidEditNumClicker.val;
      for (int i=0; i<mMR.mapArray.length; i++) mMR.setPosCountX(boidEditNumClicker.val);
    }

    boidTypeClicker.val = mMR.boidTypes[boidEditNumClicker.val];
    boidTypeClicker.mousePressed(mouseX, mouseY);
    if (boidTypeClicker.lOn || boidTypeClicker.rOn) mMR.boidTypes[boidEditNumClicker.val] = boidTypeClicker.val;
    
    boidDisplayNumClicker.mousePressed(mouseX, mouseY);
    if (boidDisplayNumClicker.lOn || boidDisplayNumClicker.rOn){
      if(boidDisplayNumClicker.val < 1) boidDisplayNumClicker.val = 1;
      mMR.posCountXDisplay = boidDisplayNumClicker.val;
      if(boidEditNumClicker.val > boidDisplayNumClicker.val) boidEditNumClicker.val = boidDisplayNumClicker.val;
    }

    mMR.mousePressed();
    break;

  case 2:
    backButton.mousePressed(mouseX, mouseY);
//    cluster.trigger(mX, mY);

    if (backButton.on) {
      STATE = 1;
      backButton.on = false;
      audioOn = false;
      hint(ENABLE_DEPTH_TEST);
    }
    break;
  }

  prevMousePressed = true;
}

void mouseDragged() {

//  thisMX = mX = mouseX;
//  thisMY = mY = mouseY;

  switch(STATE) {

  case 1:
    mMR.mouseDragged();
    break;

  case 2:
    for (int i=0; i<=boidDisplayNumClicker.val; i++) boidArray[i].mouseDragged();
//    repellent.mouseDragged(mouseX, mouseY);
    break;
  }

  prevMX = mouseX;
  prevMY = mouseY;
}

void mouseReleased() {

  prevMousePressed = false;

  switch(STATE) {
  case 0:

    break;
  case 1:
    mMR.mouseReleased();
    boidEditNumClicker.mouseReleased();
    boidTypeClicker.mouseReleased();
    boidDisplayNumClicker.mouseReleased();
    break;
  case 2:

    break;
  }
}

void resetClock(){
  clockCount = 0;
  for (int i=0; i<boidArray.length; i++) boidArray[i].resetCount();
}

//void stop() {
//  out.close();
//  minim.stop();
//  super.stop();
//}

