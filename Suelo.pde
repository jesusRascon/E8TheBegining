// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// Box2DProcessing example

// A fixed boundary class

class Suelo {

  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  Boolean xd;

  // But we also have to make a body for box2d to know about it
  Body b;

  Suelo(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    xd = true;

    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    // We're just a box
    sd.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    b = box2d.createBody(bd);

    FixtureDef fd = new FixtureDef();
    fd.shape = sd;

    b.createFixture(fd);
    b.resetMassData();
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(b);

    fill(0);
    stroke(0);
    rectMode(CENTER);
    rect(pos.x, pos.y, w, h);
  }

  void move() {
    if (frameCount%40 == 0) {
      Vec2 vel = b.getLinearVelocity();
      if (xd)
        vel.x += 10;
      else
        vel.x -=10;
      b.setLinearVelocity(vel);
      println('2');
    }
  }
}