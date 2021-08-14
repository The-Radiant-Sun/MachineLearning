/* The changelog of a connection */
class ConnectionHistory {
  int fromNode;
  int toNode;
  int innovationNumber;

  ArrayList<Integer> innovationNumbers = new ArrayList<Integer>(); //Create a list of unique identifiers
  
  /* Create the history */
  ConnectionHistory(int from, int to, int inno, ArrayList<Integer> innovationNos) {
    fromNode = from;
    toNode = to;
    innovationNumber = inno;
    innovationNumbers = (ArrayList)innovationNos.clone();
  }
  
  /* Check the difference between genomes */
  boolean matches(Brain brain, Node from, Node to) {
    if (brain.genes.size() == innovationNumbers.size()) {
      if (from.number == fromNode && to.number == toNode) {
        for (int i = 0; i < brain.genes.size(); i++) {
          if (!innovationNumbers.contains(brain.genes.get(i).innovationNumber)) {
            return false; //Return false if the connectiosn are different
          }
        }
        
        return true;
      }
    }
    return false;
  }
}
