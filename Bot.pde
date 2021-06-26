class Bot {
  Brain brain;
  
  int brainInputs = 3;
  int brainOutputs = 2;
  
  float[] decision = new float[2];
  
  int lifespan = 0;
  int score = 0;
  
  int generation = 0;
  
  float fitness;
  
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float size;
  
  Cell goal;
  Cell spawn;
  boolean[][] walls;
  
  ArrayList<Cell> travelled;
  
  boolean alive;
  
  Bot(Cell t_goal, Cell t_spawn, float t_size, boolean[][] t_walls) {
    brain = new Brain();
    
    goal = t_goal;
    spawn = t_spawn;
    walls = t_walls;
  
    travelled = new ArrayList<Cell>();
    travelled.add(spawn);
    
    size = t_size;
    
    position = new PVector(spawn.trueX, spawn.trueY);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    
    alive = true;
  }
  
  void kill() {
    alive = false;
  }
  
  //gets the output of the brain then converts them to actions
  void think() {
    float max = 0;
    int maxIndex = 0;
    
    //get the output of the neural network
    decision = brain.feedForward(vision);

    for (int i = 0; i < decision.length; i++) {
      if (decision[i] > max) {
        max = decision[i];
        maxIndex = i;
      }
    }
  }
  
  //returns a clone of this player with the same brain
  Bot clone() {
    Bot clone = new Bot(goal, spawn, size);
    clone.brain = brain.clone();
    clone.fitness = fitness;
    clone.brain.generateNetwork(); 
    clone.gen = gen;
    clone.bestScore = score;
    return clone;
  }
  
  //since there is some randomness in games sometimes when we want to replay the game we need to remove that randomness
  //this fuction does that

  Bot cloneForReplay() {
    Bot clone = new Bot(goal, spawn, size, walls);
    clone.brain = brain.clone();
    clone.fitness = fitness;
    clone.brain.generateNetwork();
    clone.generation = generation;
    clone.score = score;
    return clone;
  }
  
  Bot crossover(Bot parent2) {
    Bot child = new Bot(goal, spawn, size, walls);
    child.brain = brain.crossover(parent2.brain);
    child.brain.generateNetwork();
    return child;
  }
  
  void calculateFitness() {
    fitness = 1 / (pow(2, travelled.get(travelled.size() - 1).getH()) * lifespan);
  }
  
  void Display() {
    Cell lastTravelled = travelled.get(travelled.size() - 1);
    
    if(lastTravelled.isWall || position.x < 1 || position.x > width - 1 || position.y < 1 || position.y > height - 1) {
      kill();
    }
    
    position.add(velocity);
    velocity.add(acceleration);
    
    fitness = 1 / pow(2, lastTravelled.getH() + 1);
    
    if(lastTravelled.isGoal) {
      kill();
    }

    if(alive) {
      stroke(0);
      fill(175);
    } else {
      stroke(255, 0, 0);
      fill(175, 0, 0);
    }
    
    ellipse(position.x, position.y, size, size);
  }
}
