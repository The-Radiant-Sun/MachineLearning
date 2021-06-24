class Bot {
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float size;
  
  float maxSpeed;
  
  Cell goal;
  Cell spawn;
  
  ArrayList<Cell> travelled;
  
  boolean alive;

  float fitness;
  
  
  Bot(Cell t_goal, Cell t_spawn, float t_maxSpeed, float t_size) {
    goal = t_goal;
    spawn = t_spawn;
  
    travelled = new ArrayList<Cell>();
    travelled.add(spawn);
    
    size = t_size;
    
    maxSpeed = t_maxSpeed;
    
    acceleration = new PVector(0, 0);
    velocity = PVector.random2D();
    position = new PVector(spawn.trueX, spawn.trueY);
    
    alive = true;
  }
  
  float checkSpeed(float speed, float check) {
    if(speed > check) {
      return check;
    }
    return speed;
  }
  
  void kill() {
    alive = false;
    
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }
  
  void Display() {
    if(travelled.get(travelled.size() - 1).isWall) {
      kill();
    }
    
    position.add(velocity);
    velocity.add(acceleration);
    
    velocity = new PVector(checkSpeed(velocity.x, maxSpeed), checkSpeed(velocity.y, maxSpeed));
    
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
