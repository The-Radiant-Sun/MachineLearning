class NEAT {
  ArrayList<Bot> bots;
  
  Bot bestBot;
  int bestScore;
  
  int generation;
  
  ArrayList<ConnectionHistory> innovationHistory = new ArrayList<ConnectionHistory>();
  ArrayList<Bot> botGen = new ArrayList<Bot>();
  ArrayList<Species> species = new ArrayList<Species>();

  boolean massExtinctionEvent = false;
  boolean newStage = false;
  
  Cell goal;
  Cell spawn;

  float botSize;
  int botNumber;
  
  int deadBots;
  boolean allDead;
  
  NEAT(float t_botSize, int t_botNumber) {
    botSize = t_botSize;
    botNumber = t_botNumber;
    
    generation = 0;
  }
  
  void updateValues(Cell t_goal, Cell t_spawn) {
    allDead = false;
    
    goal = t_goal;
    spawn = t_spawn;
  }
  
  void spawn() {
    bots = new ArrayList<Bot>();
    for(int i = 0; i < botNumber; i++) {
      bots.add(new Bot(map.goal, map.spawn, botSize));
      bots.get(i).brain.generateNetwork();
      bots.get(i).brain.mutate(innovationHistory);
    }
    
    generation++;
  }
  
  Bot selectGenes(float sumFitness) {
    float chance = random(sumFitness);
    float i = 0;
    
    for(Bot bot : bots) {
      i += bot.fitness;
      if(i > chance) {
        return bot;
      }
    }
    
    return null;
  }
  
  //sets the best player globally and for this gen
  void setBestPlayer() {
    Bot tempBest =  species.get(0).bots.get(0);
    tempBest.generation = generation;

    //if best this gen is better than the global best score then set the global best as the best this gen

    if (tempBest.score > bestScore) {
      botGen.add(tempBest.cloneForReplay());
      println("old best:", bestScore);
      println("new best:", tempBest.score);
      bestScore = tempBest.score;
      bestBot = tempBest.cloneForReplay();
    }
  }
  
  void naturalSelection() {
    speciate();//seperate the population into species 
    calculateFitness();//calculate the fitness of each player
    sortSpecies();//sort the species to be ranked in fitness order, best first
    
    if (massExtinctionEvent) { 
      massExtinction();
      massExtinctionEvent = false;
    }
    
    cullSpecies();//kill off the bottom half of each species
    setBestPlayer();//save the best player of this gen
    killStaleSpecies();//remove species which haven't improved in the last 15(ish) generations
    killBadSpecies();//kill species which are so bad that they cant reproduce


    println("generation", generation, "Number of mutations", innovationHistory.size(), "species: " + species.size());


    float averageSum = getAvgFitnessSum();
    ArrayList<Bot> children = new ArrayList<Bot>();//the next generation
    println("Species:");               
    for (int j = 0; j < species.size(); j++) {//for each species

      println("best unadjusted fitness:", species.get(j).bestFitness);
      for (int i = 0; i < species.get(j).bots.size(); i++) {
        print("Bot " + i, "fitness: " +  species.get(j).bots.get(i).fitness, "score " + species.get(j).bots.get(i).score, ' ');
      }
      println();
      children.add(species.get(j).bestBot.cloneForReplay());//add champion without any mutation

      int NoOfChildren = floor(species.get(j).averageFitness/averageSum * bots.size()) -1;//the number of children this species is allowed, note -1 is because the champ is already added
      for (int i = 0; i< NoOfChildren; i++) {//get the calculated amount of children from this species
        children.add(species.get(j).createChild(innovationHistory));
      }
    }

    while (children.size() < bots.size()) {//if not enough babies (due to flooring the number of children to get a whole int) 
      children.add(species.get(0).createChild(innovationHistory));//get babies from the best species
    }
    bots.clear();
    bots = (ArrayList)children.clone(); //set the children as the current population
    generation += 1;
    for (int i = 0; i< bots.size(); i++) {//generate networks for each of the children
      bots.get(i).brain.generateNetwork();
    }
  }
  
  //seperate population into species based on how similar they are to the leaders of each species in the previous gen
  void speciate() {
    for (Species s : species) {//empty species
      s.bots.clear();
    }
    for (int i = 0; i < bots.size(); i++) {//for each player
      boolean speciesFound = false;
      for (Species s : species) {//for each species
        if (s.sameSpecies(bots.get(i).brain)) {//if the player is similar enough to be considered in the same species
          s.addToSpecies(bots.get(i));//add it to the species
          speciesFound = true;
          break;
        }
      }
      if (!speciesFound) {//if no species was similar enough then add a new species with this as its champion
        species.add(new Species(bots.get(i)));
      }
    }
  }
  
  //calculates the fitness of all of the players 
  void calculateFitness() {
    for (int i = 1; i<bots.size(); i++) {
      bots.get(i).calculateFitness();
    }
  }
  
  //sorts the players within a species and the species by their fitnesses
  void sortSpecies() {
    //sort the players within a species
    for (Species s : species) {
      s.sortSpecies();
    }

    //sort the species by the fitness of its best player
    //using selection sort like a loser
    ArrayList<Species> temp = new ArrayList<Species>();
    for (int i = 0; i < species.size(); i ++) {
      float max = 0;
      int maxIndex = 0;
      for (int j = 0; j< species.size(); j++) {
        if (species.get(j).bestFitness > max) {
          max = species.get(j).bestFitness;
          maxIndex = j;
        }
      }
      temp.add(species.get(maxIndex));
      species.remove(maxIndex);
      i--;
    }
    species = (ArrayList)temp.clone();
  }
  
  //kills all species which haven't improved in 15 generations
  void killStaleSpecies() {
    for (int i = 2; i< species.size(); i++) {
      if (species.get(i).staleness >= 15) {
        species.remove(i);
        i--;
      }
    }
  }
  
  //if a species sucks so much that it wont even be allocated 1 child for the next generation then kill it now
  void killBadSpecies() {
    float averageSum = getAvgFitnessSum();

    for (int i = 1; i< species.size(); i++) {
      if (species.get(i).averageFitness/averageSum * bots.size() < 1) {//if wont be given a single child 
        species.remove(i);//sad
        i--;
      }
    }
  }
  
  //returns the sum of each species average fitness
  float getAvgFitnessSum() {
    float averageSum = 0;
    for (Species s : species) {
      averageSum += s.averageFitness;
    }
    return averageSum;
  }

  //kill the bottom half of each species
  void cullSpecies() {
    for (Species s : species) {
      s.cull(); //kill bottom half
      s.fitnessSharing();//also while we're at it lets do fitness sharing
      s.setAverage();//reset averages because they will have changed
    }
  }
  
  void massExtinction() {
    for (int i =5; i< species.size(); i++) {
      species.remove(i);//sad
      i--;
    }
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
        naturalSelection();
        break;
      }
    }
  }
}
