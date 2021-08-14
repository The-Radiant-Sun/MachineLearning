/* Framework by Code Bullet */
class Species {
  ArrayList<Bot> bots = new ArrayList<Bot>();
  float bestFitness = 0;
  Bot bestBot;
  float averageFitness = 0;
  int staleness = 0;
  Brain rep;
  
  float excessCoeff = 1;
  float weightDiffCoeff = 0.5;
  float compatibilityThreshold = 3;
  
  /* Constructor */
  Species(Bot b) {
    bots.add(b); 
    bestFitness = b.fitness; 
    rep = b.brain.clone();
    bestBot = b.clone();
  }
  
  /* Checks if a genome is within the same species */
  boolean sameSpecies(Brain b) {
    float compatibility;
    float excessAndDisjoint = getExcessDisjoint(b, rep); //Get the number of excess and disjoint genes between this player and the current species rep
    float averageWeightDiff = averageWeightDiff(b, rep); //Get the average weight difference between matching genes


    float largeGenomeNormaliser = b.genes.size() - 20;
    if (largeGenomeNormaliser < 1) {
      largeGenomeNormaliser = 1;
    }

    compatibility =  (excessCoeff* excessAndDisjoint/largeGenomeNormaliser) + (weightDiffCoeff* averageWeightDiff);
    
    return (compatibilityThreshold > compatibility);
  }
  
  void addToSpecies(Bot b) {
    bots.add(b);
  }
  
  /* Find the difference between two genomes */
  float getExcessDisjoint(Brain brain1, Brain brain2) {
    float matching = 0.0;
    for (int i = 0; i < brain1.genes.size(); i++) {
      for (int j = 0; j < brain2.genes.size(); j++) {
        if (brain1.genes.get(i).innovationNumber == brain2.genes.get(j).innovationNumber) {
          matching ++;
          break;
        }
      }
    }
    return (brain1.genes.size() + brain2.genes.size() - 2 * (matching));
  }
  
  /* Find the average difference in weight between two genomes */
  float averageWeightDiff(Brain brain1, Brain brain2) {
    if (brain1.genes.size() == 0 || brain2.genes.size() == 0) {
      return 0;
    }

    float matching = 0;
    float totalDiff = 0;
    for (int i = 0; i < brain1.genes.size(); i++) {
      for (int j = 0; j < brain2.genes.size(); j++) {
        if (brain1.genes.get(i).innovationNumber == brain2.genes.get(j).innovationNumber) {
          matching ++;
          totalDiff += abs(brain1.genes.get(i).weight - brain2.genes.get(j).weight);
          break;
        }
      }
    }
    if (matching == 0) {
      return 100; //Avoid dividing by zero
    }
    return totalDiff / matching;
  }
  
  /* Sorts the species by fitness */
  void sortSpecies() {
    ArrayList<Bot> temp = new ArrayList<Bot>();
    
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
    
    //If a new best player is found then reset staleness and update values
    if (bots.get(0).fitness > bestFitness) {
      staleness = 0;
      bestFitness = bots.get(0).fitness;
      rep = bots.get(0).brain.clone();
      bestBot = bots.get(0).clone();
    } else {
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
  
  /* Creates a child from the bots in this species */
  Bot createChild(ArrayList<ConnectionHistory> innovationHistory) {
    Bot child;
    if (random(1) < 0.25) {
      child =  selectBot().clone();
    } else {
      Bot parent1 = selectBot(); //Find two random parents
      Bot parent2 = selectBot();
      
      if (parent1.fitness < parent2.fitness) {
        child =  parent2.crossover(parent1); //Use the highest rated genome as the base
      } else {
        child =  parent1.crossover(parent2);
      }
    }
    
    child.brain.mutate(innovationHistory); //Make the child unique
    return child;
  }
  
  /* Choose bot based on fitness */
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
  
  /* Kills the bottom half of the species */
  void cull() {
    if (bots.size() > 2) {
      for (int i = bots.size() / 2; i < bots.size(); i++) {
        bots.remove(i); 
        i--;
      }
    }
  }
  
  void fitnessSharing() {
    for (int i = 0; i < bots.size(); i++) {
      bots.get(i).fitness /= bots.size();
    }
  }
}
