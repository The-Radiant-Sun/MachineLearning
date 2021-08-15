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
  
  /* Initializer */
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
  
  /* Generate bots for allocated spawn size */
  void spawn() {
    bots = new ArrayList<Bot>();
    for(int i = 0; i < botNumber; i++) {
      bots.add(new Bot(map.goal, map.spawn, botSize)); //Create the bot
      bots.get(i).brain.generateNetwork(); //Give it a mind
      bots.get(i).brain.mutate(innovationHistory); //Make it unique
    }
    
    generation++; //Log the new generation
  }
  
  /* Chooses genes based on a skewed choice */
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
  
  /* Sets the best player globally and for this generation */
  void setBestPlayer() {
    Bot tempBest =  species.get(0).bots.get(0);
    tempBest.generation = generation;

    //Records globally if it is the best of all generations
    if (tempBest.score > bestScore) {
      botGen.add(tempBest.clone());
      println("old best:", bestScore);
      println("new best:", tempBest.score);
      bestScore = tempBest.score;
      bestBot = tempBest.clone();
    }
  }
  
  /* Use principals of natural selection to increase capability of bot generations over long periods */
  void naturalSelection() {
    speciate(); //Seperate the population into species 
    calculateFitness(); //Calculate the fitness of each player
    sortSpecies(); //Sort the species to be ranked in fitness order, best first
    
    if (massExtinctionEvent) { 
      massExtinction(); //Eliminate multiple species if needed
      massExtinctionEvent = false;
    }
    
    cullSpecies(); //Eliminate the bottom half of each species
    setBestPlayer(); //Save the best player of this generation
    killStaleSpecies(); //Remove species which haven't improved in the last 15 generations
    killBadSpecies(); //Kill species which are not viable


    println("generation", generation, "Number of mutations", innovationHistory.size(), "species: " + species.size()); //Log current data


    float averageSum = getAvgFitnessSum();
    ArrayList<Bot> children = new ArrayList<Bot>();
    println("Species:");               
    for (int j = 0; j < species.size(); j++) {
      println("best unadjusted fitness:", species.get(j).bestFitness);
      for (int i = 0; i < species.get(j).bots.size(); i++) {
        print("Bot " + i, "fitness: " + species.get(j).bots.get(i).fitness, "score " + species.get(j).bots.get(i).score, ' '); //Record data
      }
      println();
      children.add(species.get(j).bestBot.clone()); //Re-insert best bot copy
      int NoOfChildren = floor(species.get(j).averageFitness/averageSum * bots.size()) -1; //Allocated child branches this species is allowed
      for (int i = 0; i< NoOfChildren; i++) {
        children.add(species.get(j).createChild(innovationHistory));
      }
    }
    print(4);
    while (children.size() < bots.size()) {
      children.add(species.get(0).createChild(innovationHistory)); //If current population is not sufficiant then populate with the most fit species
    }
    print(5);
    bots.clear();
    bots = (ArrayList)children.clone(); //Set the children as the current population
    generation += 1;
    print(6);
    for (int i = 0; i< bots.size(); i++) {
      bots.get(i).brain.generateNetwork(); //Give the childeren direction
    }
  }
  
  /* Seperate population into species */
  void speciate() {
    for (Species s : species) {
      s.bots.clear();
    }
    for (int i = 0; i < bots.size(); i++) {
      boolean speciesFound = false;
      for (Species s : species) {
        if (s.sameSpecies(bots.get(i).brain)) {
          s.addToSpecies(bots.get(i));
          speciesFound = true;
          break;
        }
      }
      if (!speciesFound) {
        species.add(new Species(bots.get(i))); //Create new species if diversion is significant
      }
    }
  }
  
  void calculateFitness() {
    for (Bot bot : bots) {
      bot.calculateFitness();
    }
  }
  
  /* Sorts the bots and species by their fitnesses */
  void sortSpecies() {
    for (Species s : species) {
      s.sortSpecies();
    }
    
    ArrayList<Species> temp = new ArrayList<Species>();
    for (int i = 0; i < species.size(); i ++) {
      float max = 0;
      int maxIndex = 0;
      for (int j = 0; j< species.size(); j++) {
        if (species.get(j).bestFitness > max) {
          max = species.get(j).bestFitness; //Compare best fitnessess across species
          maxIndex = j;
        }
      }
      temp.add(species.get(maxIndex));
      species.remove(maxIndex);
      i--;
    }
    species = (ArrayList)temp.clone();
  }
  
  /* Kills all species which haven't improved in 15 generations */
  void killStaleSpecies() {
    for (int i = 2; i< species.size(); i++) {
      if (species.get(i).staleness >= 15) {
        species.remove(i);
        i--;
      }
    }
  }
  
  /* If a species is unable to reproduce then eliminate it */
  void killBadSpecies() {
    float averageSum = getAvgFitnessSum();

    for (int i = 1; i< species.size(); i++) {
      if (species.get(i).averageFitness/averageSum * bots.size() < 1) {//if wont be given a single child 
        species.remove(i);//sad
        i--;
      }
    }
  }

  float getAvgFitnessSum() {
    float averageSum = 0;
    for (Species s : species) {
      averageSum += s.averageFitness;
    }
    return averageSum;
  }

  /* Removes the bottom half of each species */
  void cullSpecies() {
    for (Species s : species) {
      s.cull();
      s.fitnessSharing();
      s.setAverage();
    }
  }
  
  void massExtinction() {
    for (int i =5; i< species.size(); i++) {
      species.remove(i);
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
