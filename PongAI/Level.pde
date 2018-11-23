class Level {
  Player p1;
  Player p2;
  Ball ball;
  boolean finished;
  
  Level(int[] nnInput) {
    p1 = new Player(nnInput, pongHeight - 20);
    p2 = new Player(nnInput, 20);
    finished = false;
    
    ball = new Ball(random(1) > 0.5);
  }
  
  Level(NeuralNetwork nn1, NeuralNetwork nn2) {
    p1 = new Player(nn1, pongHeight - 20);
    p2 = new Player(nn2, 20);
    finished = false;
    
    ball = new Ball(random(1) > 0.5);
  }
  
  void update() {
    if (!finished) {
      ball.update();
      checkCollisions();
      p1.update(getInputs(p1.paddle));
      p2.update(getInputs(p2.paddle));
      
      if (p1.score == 15 || p2.score == 15) {
        finished = true;
        p1.fitness *= (p1.score/15);
        p2.fitness *= (p2.score/15);
      }
    }
  }
  
  void show() {
    if (!finished) {
      p1.show();
      p2.show();
      ball.show();
    }
  }
  
  void checkCollisions() {
    ball.checkWalls();
    
    if (ball.outOfBounds()) {
      if (ball.pos.y > p1.paddle.pos.y) {
        p2.score++;
        ball = new Ball(false);
      }
      else {
        p1.score++;
        ball = new Ball(true);
      }
    }
    
    if (ball.pos.x < p1.paddle.pos.x + p1.paddle.size.x/2 && ball.pos.x > p1.paddle.pos.x - p1.paddle.size.x/2 && ball.pos.y > p1.paddle.pos.y - p1.paddle.size.y/2) {
      ball.vel = PVector.fromAngle(PI/2 - (PI/3)*(p1.paddle.pos.x - ball.pos.x)/(p1.paddle.size.x/2) + random(PI/8)).mult(-5);
      p1.fitness += 2;
    }
    else if (ball.pos.x < p2.paddle.pos.x + p2.paddle.size.x/2 && ball.pos.x > p2.paddle.pos.x - p2.paddle.size.x/2 && ball.pos.y < p2.paddle.pos.y + p2.paddle.size.y/2) {
      ball.vel = PVector.fromAngle(PI/2 + (PI/3)*(p2.paddle.pos.x - ball.pos.x)/(p2.paddle.size.x/2) + random(PI/8)).mult(5);
      p1.fitness += 2;
    }
  }
  
  float[] getInputs(Paddle p) {
    float[] inputs = new float[5];
    inputs[0] = p.pos.x + p.size.x/2 - ball.pos.x;
    inputs[1] = p.pos.x - p.size.x/2 - ball.pos.x;
    inputs[2] = p.pos.dist(ball.pos);
    inputs[3] = abs(p.pos.y - ball.pos.y);
    //inputs[4] = pongWidth - p.pos.x + p.size.x/2;
    //inputs[5] = p.pos.x - p.size.x/2;
    inputs[4] = abs(p1.paddle.pos.x - p2.paddle.pos.x);
    
    return inputs;
  }
  
  Player betterPlayer() {
    if (p1.score > p2.score) {
      return p1;
    }
     return p2;
  }
}
