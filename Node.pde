/* Framework by Code Bullet */
class Node {
  int number;
  float inputSum = 0;
  float outputValue = 0;
  ArrayList<ConnectionGene> outputConnections = new ArrayList<ConnectionGene>();
  int layer = 0;
  PVector drawPos = new PVector();
  
  Node(int no) {
    number = no;
  }
  
  /* Sends output forwards */
  void engage() {
    if (layer != 0) {
      outputValue = sigmoid(inputSum);
    }

    for (int i = 0; i< outputConnections.size(); i++) {
      if (outputConnections.get(i).enabled) {
        outputConnections.get(i).toNode.inputSum += outputConnections.get(i).weight * outputValue; //Add the weighted output to the sum of inputs for connected nodes
      }
    }
  }
  
  float sigmoid(float x) {
    float y = 1 / (1 + pow((float)Math.E, -4.9*x));
    return y;
  }

  /* Tests node connections */
  boolean isConnectedTo(Node node) {
    if (node.layer == layer) {
      return false;
    }
    
    if (node.layer < layer) {
      for (int i = 0; i < node.outputConnections.size(); i++) {
        if (node.outputConnections.get(i).toNode == this) {
          return true;
        }
      }
    } else {
      for (int i = 0; i < outputConnections.size(); i++) {
        if (outputConnections.get(i).toNode == node) {
          return true;
        }
      }
    }

    return false;
  }
  
  /* Copy node */
  Node clone() {
    Node clone = new Node(number);
    clone.layer = layer;
    return clone;
  }
 }
