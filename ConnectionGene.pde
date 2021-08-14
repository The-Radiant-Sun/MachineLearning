/* Connects two nodes */
class ConnectionGene {
  Node fromNode;
  Node toNode;
  float weight;
  boolean enabled = true;
  int innovationNumber; //Add a number to compare across genomes
  
  /* Create the connection */
  ConnectionGene(Node from, Node to, float w, int inno) {
    fromNode = from;
    toNode = to;
    weight = w;
    innovationNumber = inno;
  }
  
  /* Alter the weight of the connection */
  void mutateWeight() {
    float rand2 = random(1);
    if (rand2 < 0.1) {
      weight = random(-1, 1); //Significantly alter the connection 10% of the time
    } else {
      weight += randomGaussian() / 50; //Slightly alter the connection 90% of the time
      if(weight > 1){
        weight = 1;
      }
      if(weight < -1){
        weight = -1;        
        
      }
    }
  }
  
  /* Return a copy of this connection */
  ConnectionGene clone(Node from, Node  to) {
    ConnectionGene clone = new ConnectionGene(from, to, weight, innovationNumber);
    clone.enabled = enabled;

    return clone;
  }
}
