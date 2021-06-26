class NEAT {
  ArrayList<Bot> bots;
  
  Cell goal;
  Cell spawn;

  float botSize;
  int botNumber;
  
  int deadBots;
  boolean allDead;
  
  NEAT(Cell t_goal, Cell t_spawn, float t_botSize, int t_botNumber, int pathLength) {
    goal = t_goal;
    spawn = t_spawn;
    
    botSize = t_botSize;
    botNumber = t_botNumber;
    
    
    bots = new ArrayList<Bot>();
    for(int i = 0; i < botNumber; i++) {
      bots.add(new Bot(map.goal, map.spawn, botSize, pathLength));
    }
  }
  
  void selectBots() {
    
  }
  
  void crossover() {
    
  }
  
  void mutate() {
    
  }
  
  void display() {
    deadBots = 0;
  
    for(Bot bot: bots){
      if(bot.alive) {
        bot.Display();
      } else {
        deadBots++;
      } if(deadBots == botNumber) {
        allDead = true;
      }
    }
  }
}
