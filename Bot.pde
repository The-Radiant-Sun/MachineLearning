/* Represents the physical avatar of a neural network and controls all interactions between the neural network and other entities */
class Bot {
  Brain brain; //The neural network
  
  //int brainInputs = 9;
  int brainInputs = 3; //The number of values sent to the brain
  int brainOutputs = 2; //The number of values recieved from the brain
  
  float[] decision = new float[brainOutputs];
  
  int lifespan = 0; //How long it has been alive
  int score = 0; //The score it has achieved
  
  int generation = 0; //Its generation number
  
  float fitness; //How likely its neural network is to be selected for future propergation
  
  PVector position; //Its position on the map
  PVector velocity; //The velocity that effects the position
  PVector acceleration; //The acceleration will be affected by the neural network and changes the velocity
  
  float size; //The visual size of the bot, this has no effect on interactions
  
  Cell goal; //Endpoint
  Cell spawn; //Startpoint
  
  ArrayList<Cell> travelled; //List of cells it has travelled through
  Cell lastTravelled; //Last cell travelled through, should be current cell it is on
  
  boolean alive; //If it is alive or dead
  
  Bot(Cell t_goal, Cell t_spawn, float t_size) {
    /* Sets the bot up for further interaction */
    brain = new Brain();
    
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
    /* Sets the bot to be dead */
    alive = false;
  }
  
  //gets the output of the brain then converts them to actions
  void think() {
    int v = 3;
    int vMax = brainInputs;
    
    float[] vision = new float[vMax]; //Values passed to brain
    
    vision[0] = lastTravelled.getH(); //Current distance from goal
    
    PVector toGoal = new PVector(goal.trueX, goal.trueY).sub(velocity); //Difference between the velocity and the position of the goal
    
    vision[1] = toGoal.x;
    vision[2] = toGoal.y;
    
    /*
    for(Cell neighbour : lastTravelled.neighbours) {
      vision[v] = neighbour.isWall ? 1 : 0;
      v++;
    }
    if(v < vMax) {
      for(int n = v; n < vMax; n++) {
        vision[v] = 1;
      }
    }
    */
    
    decision = brain.feedForward(vision); //Pass the brain the information gathered
  }

  /* Creates a copy of the current bot for future comparisons */
  Bot clone() {
    Bot clone = new Bot(goal, spawn, size);
    clone.brain = brain.clone();
    clone.fitness = fitness;
    clone.brain.generateNetwork();
    clone.generation = generation;
    clone.score = score;
    return clone;
  }
  
  /* Combines aspects of this neural network and another neural network to allow for controlled diversity when repopulating */
  Bot crossover(Bot parent2) {
    Bot child = new Bot(goal, spawn, size);
    child.brain = brain.crossover(parent2.brain);
    child.brain.generateNetwork(); //Generates neural network from crossed over elements
    return child;
  }
  
  /* Updates the fitness to be inversly proportional to the distance from the goal */
  void calculateFitness() {
    fitness = 1 / pow(2, lastTravelled.getH());
  }
  
  /* Rendering the bot and completing all the single-frame updates */
  void Display() {
    lastTravelled = travelled.get(travelled.size() - 1); //Setting the last travelled cell for convinience
    
    think(); //Getting the result of the neural network
    
    //Kills bot if it collides with a wall or leaves the map
    if(lastTravelled.isWall || !lastTravelled.collisionWith(position)) {
      kill();
    }
    
    position.add(velocity); //Change vectors
    velocity.add(acceleration);
    
    acceleration.x = decision[0] * cos(decision[1] * 2 * PI); //Update acceleration depending on the neural network outputs
    acceleration.y = decision[0] * sin(decision[1] * 2 * PI);
    
    score = int(-lastTravelled.getH()); //Update score
    
    //Kills bot if the magnitude of action is below a certain value or they have reached the goal
    if(lastTravelled.isGoal || decision[0] < 0.05) {
      kill();
    }

    //Render the bot
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
