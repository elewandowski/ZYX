//class Repellent{
//  
//  int x, y, z, size; 
//  float xA, yA, zA, prevZA, scrnX, scrnY;
//  boolean held;
//  
//  Repellent(){
//    
//    size = 60;
//    x = (int) random(10, width);
//    y = (int) random(10, height);
//    z = (int) random(-2500);
//    xA = random(1,1.5);
//    yA = random(1,1.5);
////    zA = random(0.5,1.5);
//    held = false;
//  }
//  
//  void update(){
//    
//    if(!held){
//      x += xA;
//      y += yA;
////      z += zA;
//    }
//    
//    if(x > width || x < 0) xA *= -1;
//    if(y > height || y < 0) yA *= -1;
////    if(z > 0 || z < -200) zA *= -1;
//  }
//  
//  void display(){
//    
//    strokeWeight(1);
//    stroke(255,0,0);
////    scrnX = screenX(x,y,z);
////    scrnY = screenY(x,y,z);
//    line(x,0,x,height);
//    line(0,y,width,y);
//    
//    pushMatrix();
//    translate(x,y,0);
////    rotateX(PI*0.25);
////    rotateY(PI*0.25);
////    rotateZ(PI*0.25);
//    fill(255,10);
//    stroke(0);
//    box(size, size, size);
//    popMatrix();
//  }
//  
//  void mouseDragged(int mX, int mY){
//    
//    if(mX > scrnX && mX < scrnX + size && mY > scrnY && mY < scrnY + size){
//      x = mX;
//      y = mY;
//      held = true;
//    }else{
//      held = false;
//    }
//  }
//}
