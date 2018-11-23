import java.util.Arrays;
import java.util.Comparator;
import java.util.Collections;

int pongWidth = 400;
int pongHeight = 400;
int gen = 0;
int playersRendered = 10;
boolean hideGraphs = false;
Population pop = new Population(50, new int[] { 5, 3, 2});

void setup() {
  size(1700, 800, P2D);
  frameRate(1000);
}

void draw() {
  background(255);
  pop.update();
  pop.show();
  
  if (pop.isAllFinished()) {
    pop.naturalSelection();
  }
  
  textSize(12);
  text("Number finished: " + pop.getNumberFinished(), 20, 450);
  text("Framerate: " + frameRate, 20, 480);
  text("Frames: " + frameCount, 20, 510);
  if (gen > 0) {
    text("Avg score: " + pop.lastAvg, 20, 540);
  }
  
  if (!hideGraphs) {
    pop.maxFitnessGraph.show();
    pop.avgFitnessGraph.show();
    pop.nnGraph.show(1200, 0);
  }
}

void keyPressed() {
  switch(key) {
    case 'g':
      hideGraphs = toggle(hideGraphs);
      break;
    case '=':
      playersRendered++;
      break;
    case '-':
      playersRendered--;
      break;
    case 's':
      pop.saveBestPlayer();
      break;
    case 'l':
      pop.replaceAllNN("/data/nn.json");
      break;
  }
}

boolean toggle(boolean bln) {
  if (bln) {
    return false;
  }
  
  return true;
}
