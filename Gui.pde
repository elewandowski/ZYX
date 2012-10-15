class Gui {

  float x, y;
  float level;
  boolean mouseContact;

  Gui(float x, float y) {
    mouseContact = false;
    this.x = x;
    this.y = y;
    level = 0;
  }
}

class Button extends Gui {

  int w, h;
  boolean on, prevOn;

  Button(int x, int y, int w, int h) {
    super(x, y);
    this.w = w;
    this.h = h;
  }

  void display() {
    if (on) fill(219, 71, 71);
    else fill(0);

    strokeWeight(0.5);
    stroke(255);
    rect(x, y, w, h);
  }
  
  boolean mousePressed(int x, int y) {
    if (this.x <= x  &&  this.x+w >= x  &&  this.y <= y  && this.y+h >= y) {
      on = !on;
      mouseContact = true;
      prevOn = true;
    }
    else{
      mouseContact = false;
      prevOn = false;
    }
    return mouseContact;
  }
  
  void mouseReleased(){
    on = false;
    prevOn = false;
  }
}

// describes a horizontal slider

class GuiSlider extends Gui {

  float w, h;

  GuiSlider(float x, float y, float w, float h, float level) {
    super(x, y);
    this.w = w;
    this.h = h;    
    this.level = level;
  }

  void change(float _x, float _y) {

    //    normalize the difference between the mouseX and origin x so it's usable
    level = (_x-x)/w;
  }

  void display() {
    stroke(255);
    fill(255);
    rect(x, y, w, h);
    fill(78, 100, 78, 127);
    rect(x, y, w*level, h);
  }

  boolean mouseContact(float _x, float _y) {
    if (x<=_x  &&  x+w>=_x  &&  y<=_y  && y+h>=_y) {
      mouseContact = true;
    }
    else {
      mouseContact = false;
    }
    return mouseContact;
  }
}

class DropDownMenu extends Gui {

  int w, h, textSize;
  int smallW, smallH;
  int firstMY, transY;
  boolean display, first;
  String[] list;
  String currentSelection = new String("Select");

  DropDownMenu(int x, int y, int textSize, String[] list) {
    super(x, y);
    this.textSize = textSize;
    this.list = list;
    display = false;
    first = true;
//    smallW = 150;
    smallH = 25;

    int wordCount = 0;
    float wordWidth = 0;
    
    textSize(textSize);
    for (int i=0; i<list.length; i++) {
      for (int j=0; j<list[i].length(); j++) if (j > wordCount) wordCount = j;
      if(textWidth(list[i]) > wordWidth) wordWidth = textWidth(list[i]);
    }

    smallW = w = int(wordWidth * 1.1);
    h = int((float)list.length * textSize * 1.25);
  }

  void display() {
    if (display) {
      fill(255);
      stroke(0);
      rect(x, y, w, h);

      pushMatrix();
      translate(0, transY);
      fill(0);
      textFont(smallFont);
      textSize(this.textSize);
      for (int i=0; i<list.length; i++) {
        fill(0);
        text(list[i], x+3, y+((i+1)*textSize*1.25-(textSize/8)));
        stroke(200);
        if(i < list.length-1) line(x+w/8, y+((i+1)*textSize*1.25+textSize*0.25), x+w/8*7, y+((i+1)*textSize*1.25+textSize*0.25));
      }
      popMatrix();
    }
    else {
      fill(0);
      rect(x, y, smallW, smallH);
      textFont(smallFont);
      textSize(textSize);
      fill(255);
      text(currentSelection, x + smallW/2 - textWidth(currentSelection)/2, y + smallH/2 + textSize/8*3);
    }
  }

  boolean mouseClicked(int mX, int mY) {

    if (!display && mX > x && mX < x + smallW && mY > y && mY < y + smallH) display = true;
    else if (display && mX > x && mX < x + w && mY > y && mY < y + h) {
      for (int i=0; i<list.length; i++) {
        if (mY > y+(i*textSize*1.25)-(textSize/8) && mY < y+((i+1)*textSize*1.25)-(textSize/8)) {
          currentSelection = list[i];
          display = false;
          break;
        }
      }
    }
    else display = false;
    return display;
  }

  void mouseDragged(int mX, int mY) {

    if (display) {
      if (first) {
        firstMY = mY;
        first = false;
      }
      if (y + h > screenHeight) transY = mY - firstMY;
    }
  }
}

class Clicker extends Gui{
  
  int size, lCol, rCol;
  int[] tri = new int[6];
  int[] tri2 = new int[6];
  int val = 0;
  int currentSelectLimit = 0;
  String[] list;
  boolean lOn, rOn, textOrNum;
  
  Clicker(int x, int y, int size){
    super(x,y);
    this.size = size;
    currentSelectLimit = boidArray.length-1;
    textOrNum = false;
    setTriangle();
  }
  
  Clicker(int x, int y, int size, String[] list){
    super(x,y);
    this.size = size;
    this.list = list;
    currentSelectLimit = list.length-1;
    textOrNum = true;
    setTriangle();
  }
  
  void setTriangle(){
    tri[0] = size/4*3;
    tri[1] = size/4*3;
    tri[2] = size/4;
    tri[3] = size/2;
    tri[4] = size/4*3;
    tri[5] = size/4;
    tri2[0] = size/4*9;
    tri2[1] = size/4*3;
    tri2[2] = size/4*11;
    tri2[3] = size/2;
    tri2[4] = size/4*9;
    tri2[5] = size/4;
  }
  
  void display(){
    pushMatrix();
    translate(x,y);
    strokeWeight(0.5);
    stroke(255);
    fill(colSchemeDark+lCol);
    rect(0,0,size,size);
    fill(0);
    noStroke();
    triangle(tri[0], tri[1], tri[2], tri[3], tri[4], tri[5]);
    fill(colSchemeDark);
    stroke(255);
    rect(size,0,size,size);
    fill(colSchemeDark+rCol);
    rect(size*2,0,size,size);
    fill(255);
    textAlign(CENTER);
    textFont(font);
    
    if(textOrNum){
      textSize(size/4*2);
      text(list[val], size/4*6+5, size/4*3);
    } else{
      textSize(size/4*3);
      text(String.valueOf(val+1), size/4*6, size/4*3);
    }
    
    textAlign(LEFT);
    fill(0);
    noStroke();
    triangle(tri2[0], tri2[1], tri2[2], tri2[3], tri2[4], tri2[5]);
    popMatrix();
  }
  
  void setVal(int select){
    val = select;
  }
  
  void mousePressed(int mX, int mY){
    if(!lOn && mX > x && mX < x+size && mY > y && mY < y+size){
      lOn = true;
      lCol = 100;
      if(val > 0) val--;
      
    } else if(!rOn && mX > x+size*2 && mX < x+size*3 && mY > y && mY < y+size){
      rOn = true;
      rCol = 100;
      if(val < currentSelectLimit) val++;
      
    } else{
      lOn = false;
      rOn = false;
    }
  }
  
  void mouseReleased(){
    lOn = false;
    rOn = false;
    lCol = 0;
    rCol = 0;
  }
}
