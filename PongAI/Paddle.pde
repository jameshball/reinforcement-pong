class Paddle {
  PVector pos;
  PVector size;
  
  Paddle(int y) {
    size = new PVector(50, 5);
    pos = new PVector(pongWidth / 2, y);
  }
  
  void move(boolean left) {
    if (left) {
      pos.x -= 3;
    }
    else {
      pos.x += 3;
    }
    
    if (pos.x > pongWidth - size.x/2) {
      pos.x = pongWidth - size.x/2;
    }
    else if (pos.x < size.x/2) {
      pos.x = size.x/2;
    }
  }
  
  void show() {
    fill(0, 0, 255);
    stroke(0);
    rect(pos.x - size.x/2, pos.y - size.y/2, size.x, size.y);
  }
}
