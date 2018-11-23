class Population {
  Level[] levels;
  int bestIndex;
  float lastAvg;
  Graph maxFitnessGraph = new Graph(500, 50, "Generation", "Max. Fitness" , 670, 275, 4, new int[] { 0, 0, 0 });
  Graph avgFitnessGraph = new Graph(500, 450, "Generation", "Avg. Fitness" , 670, 275, 4, new int[] { 255, 0, 0 });
  int framesSinceLastSort;
  NNGraph nnGraph;
  
  Population (int size, int[] lengthArr) {
    levels = new Level[size];
    
    for (int i = 0; i < size; i++) {
      levels[i] = new Level(lengthArr);
    }
    
    nnGraph = new NNGraph(levels[0].betterPlayer().nn, 700, 800, 10, 10);
    
    framesSinceLastSort = frameCount;
  }
  
  void show() {
    showBestPlayers();
  }
  
  void update() {
    for (int i = 0; i < levels.length; i++) {
      levels[i].update();
    }
  }
  
  boolean isAllFinished() {
    for (int i = 0; i < levels.length; i++) {
      if (!levels[i].finished) {
        return false;
      }
    }
    
    return true;
  }
  
  void naturalSelection() {
    getAvg();
    
    Level[] nextGen = new Level[levels.length];
    
    bestIndex = getBest();
    nextGen[levels.length - 1] = new Level(levels[bestIndex].betterPlayer().nn, levels[bestIndex].betterPlayer().nn);
    
    gen++;
    
    for (int i = 0; i < levels.length - 1; i++) {
      nextGen[i] = new Level(uniformCrossover(selectParent(), selectParent()).mutateWeights(), uniformCrossover(selectParent(), selectParent()).mutateWeights());
    }
    
    float maxScore = levels[0].betterPlayer().fitness;
    
    for (int i = 1; i < levels.length; i++) {
      if (levels[i].betterPlayer().fitness > maxScore) {
        maxScore = levels[i].betterPlayer().fitness;
      }
    }
    
    maxFitnessGraph.addData(new Datapoint(maxScore, false));
    avgFitnessGraph.addData(new Datapoint(scoreSum() / (levels.length * 2), false));
    
    levels = nextGen;
  }
  
  void getAvg() {
    float sum = 0;
    
    for (int i = 0; i < levels.length; i++) {
      sum += levels[i].p1.fitness;
      sum += levels[i].p2.fitness;
    }
    
    lastAvg = sum / (levels.length * 2);
  }
  
  NeuralNetwork uniformCrossover(NeuralNetwork parent1, NeuralNetwork parent2) {
    if (parent1.dimensionsAreIdentical(parent2)) {
      NeuralNetwork child = new NeuralNetwork(parent1.lengths);
      
      for (int i = 0; i < child.weightMatrices.length; i++) {
        for (int j = 0; j < child.weightMatrices[i].rows; j++) {
          for (int k = 0; k < child.weightMatrices[i].cols; k++) {
            if (random(1) > 0.5) {
              child.weightMatrices[i].data[j][k] = parent1.weightMatrices[i].data[j][k];
            }
            else {
              child.weightMatrices[i].data[j][k] = parent2.weightMatrices[i].data[j][k];
            }
          }
        }
      }
      
      return child;
    }
    
    return null;
  }
  
  float fitnessSum() {
    float sum = 0;
    
    for (int i = 0; i < levels.length; i++) {
      sum += pow(levels[i].p1.fitness, 2);
      sum += pow(levels[i].p2.fitness, 2);
    }
    
    return sum;
  }
  
  float scoreSum() {
    float sum = 0;
    
    for (int i = 0; i < levels.length; i++) {
      sum += levels[i].p1.fitness;
      sum += levels[i].p2.fitness;
    }
    
    return sum;
  }
  
  NeuralNetwork selectParent() {
    if (fitnessSum() == 0) {
      return levels[(int)random(levels.length)].p1.nn;
    }
    
    float randomNum = random(fitnessSum());
    float runningSum = 0;
    
    for (int i = 0; i < levels.length; i++) {
      runningSum += pow(levels[i].p1.fitness, 2);
      
      if (runningSum > randomNum) {
        return levels[i].p1.nn;
      }
      
      runningSum += pow(levels[i].p2.fitness, 2);
      
      if (runningSum > randomNum) {
        return levels[i].p2.nn;
      }
    }
    
    return null;
  }
  
  int getBest() {
    float max = levels[0].betterPlayer().fitness;
    int maxIndex = 0;
    
    for (int i = 1; i < levels.length; i++) {
      if (levels[i].betterPlayer().fitness > max) {
        max = levels[i].p1.fitness;
        maxIndex = i;
      }
    }
    
    return maxIndex;
  }
  
  int getNumberFinished() {
    int sum = 0;
    
    for (int i = 0; i < levels.length; i++) {
      if (levels[i].finished) {
        sum++;
      }
    }
    
    return sum;
  }
  
  void showBestPlayers() {
    if (playersRendered > 0) {
      if (frameCount - framesSinceLastSort > 200) {
        Arrays.sort(levels, new Comparator<Level>() {
          @Override
          public int compare(Level l1, Level l2) {
            float fitness1 = l1.betterPlayer().fitness;
            float fitness2 = l2.betterPlayer().fitness;
            
            if (l1.finished) {
              fitness1 = -1;
            }
            
            if (l2.finished) {
              fitness2 = -1;
            }
            
            return Float.compare(fitness1, fitness2);
          }
        });
        
        Collections.reverse(Arrays.asList(levels));
        
        framesSinceLastSort = frameCount;
      }
      
      for (int i = 0; i < playersRendered; i++) {
        levels[i].show();
      }
      
      nnGraph.nn = levels[0].betterPlayer().nn;
    }
    
  }
  
  void saveBestPlayer() {
    levels[getBest()].betterPlayer().nn.save("/data/nn.json");
  }
  
  void replaceAllNN(String filePath) {
    for (int i = 0; i < levels.length; i++) {
      levels[i].p1.nn.load(filePath);
      levels[i].p2.nn.load(filePath);
    }
  }
}
