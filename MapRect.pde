class MasterMapRect {

  MapRect[] mapArray;
  int posCountX, posCountXDisplay, posCountXMax;
  int[] boidTypes = new int[boidArray.length];
  boolean mapOn;

  MasterMapRect(int numOfMapRects) {
    mapArray = new MapRect[numOfMapRects];
    for (int i=0; i<mapArray.length; i++) mapArray[i] = new MapRect(0, height/16*3 + height/32*5*i, width, height/8, 20, i);
    posCountXMax = posCountXDisplay = posCountX = 0;
    mapOn = false;
  }

  void display() {
    for (int i=mapArray.length-1; i>=0; i--) mapArray[i].display();
    for (int i=mapArray.length-1; i>=0; i--) {
      if (mapArray[i].map.on) {
        pushMatrix();
        translate(0, 0, 1);
        fill(55);
        rect(screenWidth/4, screenHeight/4, screenWidth/2, screenHeight/2);
        fill(255);
        text("audioMapping", mapArray[i].dDMenuAudio.x+25, mapArray[i].dDMenuAudio.y-7);
        mapArray[i].dDMenuAudio.display();
        fill(255);
        text("visualMapping", mapArray[i].dDMenuVisual.x+10, mapArray[i].dDMenuAudio.y-7);
        mapArray[i].dDMenuVisual.display();
        mapOn = true;
        popMatrix();
        break;
      }
      else mapOn = false;
    }
  }

  void saveData() {
    String bTypes[] = new String[1];
    bTypes[0] = ("BOIDTYPES\t");
    for (int i=0; i<boidTypes.length-1; i++) bTypes[0] += (String.valueOf(boidTypes[i]) + ",");
    fileWriter.addToSave(bTypes);
    for (int i=0; i<mapArray.length; i++) mapArray[i].saveData(i);
  }

  void mousePressed() {
    for (int i=0; i<mapArray.length; i++) mapArray[i].mousePressed();
  }

  void mouseDragged() {
    for (int i=0; i<mapArray.length; i++) mapArray[i].mouseDragged();
  }

  void mouseReleased() {
    for (int i=0; i<mapArray.length; i++) mapArray[i].mouseReleased();
  }

  void setPosCountX(int posCountX) {
    this.posCountX = posCountX;
    if (posCountXMax<posCountX) posCountXMax = posCountX+1;
    if (posCountXDisplay < posCountX) posCountXDisplay = posCountX;
    for (int i=0; i <mapArray.length; i++) mapArray[i].prevSegment = mapArray[i].posCountY[posCountX];
  }
  
  void eraseData(){
    for (int i=0; i<mapArray.length; i++) mapArray[i].eraseData();
    posCountXMax = posCountXDisplay = posCountX = 0;
    mapOn = false;
  }
}

class MapRect {

  int totalNumOfPaths = boidArray.length;
  Position[][] positions;
  int[] posCountY = new int[totalNumOfPaths];
  int x, y, w, h, resolution, normX, normY, segment, prevSegment, mappingAudio, mappingVisual, thisMapRect;
  Button erase, map;
  DropDownMenu dDMenuAudio, dDMenuVisual;

  MapRect(int x, int y, int w, int h, int resolution, int thisMapRect) {
    this.x = x;
    this.y = y;
    this.w = w/16*15;
    this.h = h;
    this.resolution = resolution;
    this.thisMapRect = thisMapRect;
    prevSegment = -1;

    positions = new Position[totalNumOfPaths][this.w/resolution];
    erase = new Button(this.w, 0, w/16, h/2);
    map = new Button(this.w, h/2, w/16, h/2);  
    dDMenuAudio = new DropDownMenu(int(width/8*2.5)-20, height/4+30, 25, parameterListAudio);
    dDMenuVisual = new DropDownMenu(int(width/8*4.5)-20, height/4+30, 25, parameterListVisual);
  }

  void display() {

    pushMatrix();
    translate(x, y);

    stroke(255);
    strokeWeight(0.5);
    fill(colSchemeDark);
    rect(0, 0, w, h);
    stroke(219, 71, 71);
    if(mappingAudio == 11 || mappingVisual == 10){ // if mapping audio or visual types
      for(int i=0; i<5; i++){
        line(0,h*i/5,w,h*i/5);
      }
    } else if(mappingAudio == 5){ // if mapping audio filterType
       for(int i=0; i<3; i++){
          line(0,h*i/3,w,h*i/3);
        }
    } else {
      line(0,h*(1-OFF_THRESHOLD),w,h*(1-OFF_THRESHOLD));
    }
    
    for (int i=0; i<=mMR.posCountXDisplay; i++) {
      if (i == boidEditNumClicker.val){
        stroke(2);
        stroke(255);
      } else {
        strokeWeight(0.5);
        stroke(colSchemeDark*2);
      }
      for (int j=0; j<posCountY[i]; j++) {
        if (j == 0) point(positions[i][j].x, positions[i][j].y);
        else line(positions[i][j-1].x, positions[i][j-1].y, positions[i][j].x, positions[i][j].y);
      }
    }
    
    textSize(12);
    textFont(smallFont);
    erase.display();
    fill(255);
    text("erase", w + erase.w/2 - textWidth("erase")/2, h/4);
    map.display();
    fill(255);
    text("map", w + erase.w/2 - textWidth("map")/2, h/4*3);
    popMatrix();
  }

  void saveData(int index) {

    String[] output = new String[mMR.posCountXMax+3];

    output[0] = ("MAPRECT\t" + String.valueOf(index));
    //to avoid saving null
    if (hmA.get(dDMenuAudio.currentSelection) != null) output[1] = ("ASSIGNMENT AUDIO\t" + hmA.get(dDMenuAudio.currentSelection));
    if (hmV.get(dDMenuVisual.currentSelection) != null) output[2] = ("ASSIGNMENT VISUAL\t" + hmV.get(dDMenuVisual.currentSelection));
    
    for (int i=0; i<mMR.posCountXMax; i++) {
      output[i+3] = ("PATH\t" + String.valueOf(i) + "\t");

      for (int j=0; j<posCountY[i]; j++) {
        output[i+3] += positions[i][j].print();
      }
    }
    fileWriter.addToSave(output);
  }
  
  void eraseData(){
    positions = new Position[totalNumOfPaths][this.w/resolution];
    posCountY = new int[totalNumOfPaths];
    prevSegment = -1; 
  }

  void mouseDragged() {

    normX = mouseX-x;
    normY = mouseY-y;
    if (!mMR.mapOn && normX <= w && normX >= 0 && normY <= h && normY >= 0) {

      segment = int((float)normX / resolution);

      if (posCountY[mMR.posCountX] == 0) prevSegment = 0;
      else prevSegment = positions[mMR.posCountX][posCountY[mMR.posCountX]-1].segment;

      if (segment > prevSegment && posCountY[mMR.posCountX] < positions[0].length) {
        float tempVal = map((float)normY, h, 0, 0f, 1f);
        positions[mMR.posCountX][posCountY[mMR.posCountX]] = new Position(segment, tempVal, segment*resolution, int((1-tempVal) * h));
        posCountY[mMR.posCountX]++;
      }
    }
  }

  void mousePressed() {

    normX = mouseX-x;
    normY = mouseY-y;

    if (map.on && !dDMenuAudio.mouseClicked(mouseX, mouseY)) {
      if (hmA.get(dDMenuAudio.currentSelection) != null) {
        mappingAudio = Integer.parseInt(hmA.get(dDMenuAudio.currentSelection).toString());
      }
    }
    if (map.on && !dDMenuVisual.mouseClicked(mouseX, mouseY)) {
      if (hmV.get(dDMenuVisual.currentSelection) != null) {
        mappingVisual = Integer.parseInt(hmV.get(dDMenuVisual.currentSelection).toString());
      }
    }
    if (erase.mousePressed(normX, normY)) {
      for (int i=0; i<posCountY[mMR.posCountX]; i++) positions[mMR.posCountX][i] = null;
      prevSegment = -1;
      posCountY[mMR.posCountX] = 0;
    }
    if (map.mousePressed(normX, normY)) {
      for (int i=0; i<mMR.mapArray.length; i++) if (i != thisMapRect) mMR.mapArray[i].map.on = false;
    }
  }

  void mouseReleased() {
    erase.mouseReleased();
  }
}

class Position {

  float val;
  int segment, x, y;

  Position(int segment, float val, int x, int y) {  
    this.segment = segment;
    this.val = val;
    this.x = x;
    this.y = y;
  }

  String print() {
    String s = (String.valueOf((float)segment/mMR.mapArray[0].w) +","+ String.valueOf(val) +"\t");
    return s;
  }
}

