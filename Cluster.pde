//class Cluster {
//
//  Sheet[] sheets;
//  boolean isOn;
//  int x, y, size, controlSize;
//  float sizeA, out, rX, rY, rZ;
//  WaveTable wt = new WaveTable(6);
//  Envelope e;
//
//  Cluster(int size, int controlSize, int numOf) {
//    sheets = new Sheet[numOf];
//    this.size = size;
//    this.controlSize = controlSize;
//    int _size;
//    for (int i=0; i<sheets.length; i++) {
//      _size = (int) random(1,size);
//      sheets[i] = new Sheet(random(-controlSize/2), random(-controlSize/2), random(-500), _size, _size*16);
//    }
//    sizeA = 1;
//    e = new Envelope(5,1,40000,1);
//  }
//
//  void display() {
//    
//    pushMatrix();
//    translate(x - controlSize/2, y - controlSize/2);
//    rotateX(rX);
//    rotateY(rY);
//    rotateZ(rZ);
//    
//    for (int i=0;i < sheets.length; i++) {
//      sheets[i].display();
//      sheets[i].setSizeA(e.env);
//    }
//
//    if (e.env > 0.01) isOn = true;
//    else isOn = false;
//    popMatrix();
//  }
//
//  void trigger(int x, int y) {
//    if (!isOn) {
//      e.trigger();
//      rX = random(TWO_PI);
//      rY = random(TWO_PI);
//      rZ = random(TWO_PI);
//      isOn = true;
//      this.x = x - size/2;
//      this.y = y - size/2;
//    }
//  }
//
//  void record(float sample) {
//    for (int i=0; i<sheets.length; i++) {
//      sheets[i].wT.record(sample);
//    }
//  }
//  
//  float play(){
//    out = 0;
//    if(isOn){
//      for (int i=0; i<sheets.length; i++) {
//        out += sheets[i].wT.output(1,1);
//      }
//    }
//    out = e.env(out);
//    return out;
//  }
//}
//
//class Sheet {
//
//  float x, y, z, size;
//  float rX, rY, rZ;
//  float sizeA;
//  boolean isOn;
//  WaveTable wT;
//
//  Sheet(float x, float y, float z, float size, int wtLength) {
//    this.x = x;
//    this.y = y;
//    this.z = z;
//    this.size = size;
//    rX = random(TWO_PI);
//    rY = random(TWO_PI);
//    rZ = random(TWO_PI);
//    sizeA = 1;
//    wT = new WaveTable(5, wtLength);
//  }
//
//  void display() {
//    pushMatrix();
//    translate(x, y, z);
//    rotateX(rX);
//    rotateY(rY);
//    rotateZ(rZ);
//    noStroke();
//    fill(127);
//    rect(0, 0, size*sizeA, size*sizeA);
//    stroke(255);
//    strokeWeight(0.5);
//    for(int i=0; i<4;i++){
//      line(random(size)*sizeA,random(size)*sizeA,random(size)*sizeA,random(size)*sizeA);
//    }
//    popMatrix();
//  }
//
//  void setSizeA(float sizeA) {
//    this.sizeA = sizeA;
//  }
//}

