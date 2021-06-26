class Bot {
  Brain brain;
  int pathStep;
  
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float size;
  
  Cell goal;
  Cell spawn;
  
  ArrayList<Cell> travelled;
  
  boolean alive;

  float fitness;
  
  
  Bot(Cell t_goal, Cell t_spawn, float t_size, int pathLength) {
    brain = new Brain(pathLength);
    pathStep = 0;
    
    goal = t_goal;
    spawn = t_spawn;
  
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
    
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }
  
  void Display() {
    Cell lastTravelled = travelled.get(travelled.size() - 1);
    
    if(lastTravelled.isWall || position.x < 1 || position.x > width - 1 || position.y < 1 || position.y > height - 1) {
      kill();
    }
    
    position.add(velocity);
    
    velocity.add(acceleration);
    
    if(pathStep < brain.path.length) {
      acceleration = brain.path[pathStep];
      pathStep++;
    } else {
      kill();
    }
    
    fitness = 1 / pow(2, lastTravelled.getH());
    
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
