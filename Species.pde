class Species {
  ArrayList<Bot> bots = new ArrayList<Bot>();
  float bestFitness = 0;
  Bot bestBot;
  float averageFitness = 0;
  int staleness = 0;//how many generations the species has gone without an improvement
  Brain rep;
  
  //coefficients for testing compatibility 
  float excessCoeff = 1;
  float weightDiffCoeff = 0.5;
  float compatibilityThreshold = 3;
  
  //constructor which takes in the player which belongs to the species
  Species(Bot b) {
    bots.add(b); 
    //since it is the only one in the species it is by default the best
    bestFitness = b.fitness; 
    rep = b.brain.clone();
    bestBot = b.clone();
  }
  
  //returns whether the parameter genome is in this species
  boolean sameSpecies(Brain b) {
    float compatibility;
    float excessAndDisjoint = getExcessDisjoint(b, rep);//get the number of excess and disjoint genes between this player and the current species rep
    float averageWeightDiff = averageWeightDiff(b, rep);//get the average weight difference between matching genes


    float largeGenomeNormaliser = b.genes.size() - 20;
    if (largeGenomeNormaliser < 1) {
      largeGenomeNormaliser = 1;
    }

    compatibility =  (excessCoeff* excessAndDisjoint/largeGenomeNormaliser) + (weightDiffCoeff* averageWeightDiff);//compatablilty formula
    
    return (compatibilityThreshold > compatibility);
  }
  
  //add a bot to the species
  void addToSpecies(Bot b) {
    bots.add(b);
  }
  
  //returns the number of excess and disjoint genes between the 2 input genomes
  //i.e. returns the number of genes which dont match
  float getExcessDisjoint(Brain brain1, Brain brain2) {
    float matching = 0.0;
    for (int i = 0; i < brain1.genes.size(); i++) {
      for (int j = 0; j < brain2.genes.size(); j++) {
        if (brain1.genes.get(i).innovationNo == brain2.genes.get(j).innovationNo) {
          matching ++;
          break;
        }
      }
    }
    return (brain1.genes.size() + brain2.genes.size() - 2 * (matching));//return no of excess and disjoint genes
  }
  
  //returns the avereage weight difference between matching genes in the input genomes
  float averageWeightDiff(Brain brain1, Brain brain2) {
    if (brain1.genes.size() == 0 || brain2.genes.size() == 0) {
      return 0;
    }

    float matching = 0;
    float totalDiff = 0;
    for (int i = 0; i < brain1.genes.size(); i++) {
      for (int j = 0; j < brain2.genes.size(); j++) {
        if (brain1.genes.get(i).innovationNo == brain2.genes.get(j).innovationNo) {
          matching ++;
          totalDiff += abs(brain1.genes.get(i).weight - brain2.genes.get(j).weight);
          break;
        }
      }
    }
    if (matching == 0) {//divide by 0 error
      return 100;
    }
    return totalDiff / matching;
  }
  
  //sorts the species by fitness 
  void sortSpecies() {

    ArrayList<Bot> temp = new ArrayList<Bot>();

    //selection short 
    for (int i = 0; i < bots.size(); i ++) {
      float max = 0;
      int maxIndex = 0;
      for (int j = 0; j< bots.size(); j++) {
        if (bots.get(j).fitness > max) {
          max = bots.get(j).fitness;
          maxIndex = j;
        }
      }
      temp.add(bots.get(maxIndex));
      bots.remove(maxIndex);
      i--;
    }

    bots = (ArrayList)temp.clone();
    if (bots.size() == 0) {
      staleness = 200;
      return;
    }
    //if new best player
    if (bots.get(0).fitness > bestFitness) {
      staleness = 0;
      bestFitness = bots.get(0).fitness;
      rep = bots.get(0).brain.clone();
      bestBot = bots.get(0).clone();
    } else {//if no new best player
      staleness ++;
    }
  }
  
  void setAverage() {
    float sum = 0;
    for (int i = 0; i < bots.size(); i ++) {
      sum += bots.get(i).fitness;
    }
    averageFitness = sum / bots.size();
  }
  
  //gets baby from the players in this species
  Bot createChild(ArrayList<ConnectionHistory> innovationHistory) {
    Bot child;
    if (random(1) < 0.25) {//25% of the time there is no crossover and the child is simply a clone of a random(ish) player
      child =  selectBot().clone();
    } else {//75% of the time do crossover 

      //get 2 random(ish) parents 
      Bot parent1 = selectBot();
      Bot parent2 = selectBot();

      //the crossover function expects the highest fitness parent to be the object and the lowest as the argument
      if (parent1.fitness < parent2.fitness) {
        child =  parent2.crossover(parent1);
      } else {
        child =  parent1.crossover(parent2);
      }
    }
    
    child.brain.mutate(innovationHistory);
    return child;
  }
  
  //selects a player based on it fitness
   Bot selectBot() {
    float fitnessSum = 0;
    for(Bot bot : bots) {
      fitnessSum += bot.fitness;
    }

    float rand = random(fitnessSum);
    float runningSum = 0;

    for(Bot bot : bots) {
      runningSum += bot.fitness; 
      if (runningSum > rand) {
        return bot;
      }
    }
    
    return null;
  }
  
  //kills off bottom half of the species
  void cull() {
    if (bots.size() > 2) {
      for (int i = bots.size() / 2; i < bots.size(); i++) {
        bots.remove(i); 
        i--;
      }
    }
  }
  
  //in order to protect unique players, the fitnesses of each player is divided by the number of players in the species that that player belongs to 
  void fitnessSharing() {
    for (int i = 0; i < bots.size(); i++) {
      bots.get(i).fitness /= bots.size();
    }
  }
}
