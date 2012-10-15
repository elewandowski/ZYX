class Shard {

  float x, y, z, w, h;  
  float xR, yR, zR, xRA, yRA, zRA, rot;
  float size;
  PVector[] vectors;

  Shard(float x, float y, float w, float h) {
    this.w = w;
    this.h = h;
    this.x = x;
    this.y = y;
    size = 1;
    vectors = new PVector[16];
    for (int i=0; i<vectors.length;i++) {
      vectors[i] = new PVector();
      vectors[i].set(random(-w/2, w/2), random(-h/2, h/2), random(-w/2, w/2));
    }
    z = random(-1000);
    xRA = random(-0.02, 0.02);
    yRA = random(-0.02, 0.02);
    zRA = random(-0.02, 0.02);
  }

  void update(float x, float y) {
    this.x = x;
    this.y = y;
    xR += xRA * rot;
    yR += yRA * rot;
    zR += zRA * rot;
  }

  void display(int type) {

    switch(type) {
      /////////////////////////////////////////////
    case 0:
      pushMatrix();
      translate(x, y, 0);
      box(50);

      rotateX(xR);
      rotateY(yR);
      rotateZ(zR);

      noFill();
      beginShape();
      for (int i=0; i<vectors.length;i++) {
        vertex(vectors[i].x * size, vectors[i].y * size, vectors[i].z * size);
      }
      endShape();

      for (int i=0; i<vectors.length;i+=4) {
        pushMatrix();
        translate(vectors[i].x * size, vectors[i].y * size, vectors[i].z * size);
        rect(0,0,20*size,20*size);
        popMatrix();
      }

      popMatrix();
      break;

      /////////////////////////////////////////////
    case 1:
      pushMatrix();
      translate(x, y, 0);
      pushMatrix();
      rotateX(PI/4);
      rotateZ(PI/4);
      box(50);
      popMatrix();

      rotateX(xR);
      rotateY(yR);
      rotateZ(zR);
      
      noFill();    
      for (int i=0; i<int(vectors.length/3*2);i++) {
        pushMatrix();
        translate(vectors[i].x * size, vectors[i].y * size, vectors[i].z * size);
        box(5);
        popMatrix();
      }

      popMatrix();
      break;
      ///////////////////////////////////////////////
    case 2:
      pushMatrix();
      translate(x, y, 0);
      box(50);

      rotateX(xR);
      rotateY(yR);
      rotateZ(zR);

      noFill();

      for (int i=0; i<vectors.length;i++) {
        line(vectors[i].x * size, vectors[i].y * size, vectors[i].z * size, 
        0, 0, 0);
      }

      popMatrix();
      break;
      ///////////////////////////////////////////////
    case 3:
      pushMatrix();
      translate(x, y, 0);

      rotateX(xR);
      rotateY(yR);
      rotateZ(zR);
      strokeCap(SQUARE);
      noFill();

      for (int i=0; i<vectors.length;i+=2) {
        pushMatrix();
        translate(vectors[i].x * size/4, vectors[i].y * size/4, vectors[i].z * size/4);
        box(size *50, size * 50, size * 50);
        popMatrix();
      }

      popMatrix();
      break;

      ///////////////////////////////////////////////
    case 4:
      pushMatrix();
      translate(x, y, 0);

      rotateX(xR);
      rotateY(yR);
      rotateZ(zR);
      noFill();

      for (int i=0; i<vectors.length;i+=2) {
        pushMatrix();

        translate(vectors[i].x * size/4 + random(-5, 5), vectors[i].y * size/4 + random(-5, 5), vectors[i].z * size/4 + random(-5, 5));
        rect(0, 0, size * 50, size * 50);
        popMatrix();
      }

      popMatrix();
      break;

      ///////////////////////////////////////////////
    case 5:
      pushMatrix();
      translate(x, y, 0);

      pushMatrix();
      rotateX(PI/8);
      rotateZ(PI/8);
      box(50);
      popMatrix();

      rotateX(xR);
      rotateY(yR);
      rotateZ(zR);
      noFill();

      for (int i=0; i<vectors.length;i++) {
        pushMatrix();
        rotateY(PI/2);
        translate(vectors[i].x * size/2, vectors[i].y * size/2, vectors[i].z * size/2);
        box(size *50, size * 50, size * 50);
        popMatrix();
      }

      popMatrix();
      break;
    }
  }

  void setSize(float size) {
    this.size = 0.1 + size * 0.9;
  }
  
  void setRot(float rot){
    this.rot = rot;
  }
}


