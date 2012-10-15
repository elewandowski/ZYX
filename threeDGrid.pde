class ThreeDGrid {

  int w, h; 
  float xCor, yCor;
  float noiseVal;

  ThreeDGrid(int w, int h) {
    this.w = w;
    this.h = h;
  }

  void update(int _x, int _y) {
    if(frameCount % 2 == 0){
      xCor -= (float(_x-width/2)/width/2) * 4;
      yCor -= (float(_y-height/2)/height/2) * 4;
    }
    if (xCor > w/2) xCor = w/2;
    else if (xCor < 0) xCor = 0;
    if (yCor > h/2) yCor = h/2;
    else if (yCor < 0) yCor = 0;
  }

  void display() {
    strokeWeight(0.5);
    translate(xCor, yCor);
    //the for loops have to have the same denominator so they match up
    for (int i=-width*2; i<width*3+1; i+=w) {
      for (int j=-width*4; j<height*3+1; j+=h) {
        stroke(60);
        //x lines
        line(-width*2, j, -i, width*3, j, -i);
        //y lines
        line(i, -height*2, -j, i, height*3, -j);
        //z lines
        line(i, j, width*2, i, j, -width*3);
      }
    }
  }
}

