class Player {
  NeuralNetwork nn;
  Paddle paddle;
  int score;
  float fitness;
  
  Player(int[] nnInput, int y) {
    nn = new NeuralNetwork(nnInput);
    paddle = new Paddle(y);
    score = 0;
    fitness = 0;
  }
  
  Player(NeuralNetwork net, int y) {
    nn = net;
    paddle = new Paddle(y);
    score = 0;
    fitness = 0;
  }
  
  void update(float[] input) {
    float[] output = nn.feedForward(input).toArray();
    
    if (output[0] > 0.5) {
      paddle.move(true);
    }
    else if (output[1] > 0.5) {
      paddle.move(false);
    }
  }
  
  void show() {
    paddle.show();
  }
}
