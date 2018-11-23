class Ball {
  PVector pos;
  PVector size;
  PVector vel;
  
  // If up is true, the first direction the ball moves in is upwards.
  Ball(boolean up) {
    pos = new PVector(pongWidth/2, pongHeight/2);
    size = new PVector(5, 5);
    vel = PVector.fromAngle(random(PI/4, 3*PI/4)).mult(5);
    
    if (!up) {
      vel = new PVector(-vel.x, -vel.y);
    }
  }
  
  void update() {
    pos.add(vel);
  }
  
  void show() {
    fill(255, 0, 0);
    stroke(0);
    ellipse(pos.x, pos.y, size.x, size.y);
  }
  
  void checkWalls() {
    if (pos.x < size.x/2 || pos.x > pongWidth - size.x/2) {
      vel = new PVector(-vel.x, vel.y);
      if (pos.x < size.x/2) {
        pos.x = 5;
      }
      else {
        pos.x = pongWidth - 5;
      }
    }
  }
  
  boolean outOfBounds() {
    return pos.y < size.y/2 || pos.y > pongHeight - size.y/2;
  }
}
