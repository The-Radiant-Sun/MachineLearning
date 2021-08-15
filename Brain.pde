/* Recieves input from the bot, makes decisions based on that input */
class Brain {
  ArrayList<ConnectionGene> genes = new  ArrayList<ConnectionGene>(); //A list of connections between the nodes
  ArrayList<Node> nodes = new ArrayList<Node>(); //A list of the nodes
  
  int inputs;
  int outputs;
  
  int layers = 2; //Starting layers
  int nextNode = 0; //Starting node number
  int biasNode;
  
  ArrayList<Node> network = new ArrayList<Node>(); //A list of the nodes in the order that they will be iterated through
  
  /* Creates the nodes of the neural network */
  Brain() {
    inputs = 3; //Set beginning values for input and output
    outputs = 2;

    //Create the input nodes
    for (int i = 0; i < inputs; i++) {
      nodes.add(new Node(i));
      nextNode ++;
      nodes.get(i).layer = 0;
    }
    
    //Create the output nodes
    for (int i = 0; i < outputs; i++) {
      nodes.add(new Node(i + inputs));
      nodes.get(i+inputs).layer = 1;
      nextNode++;
    }

    //Add the bias node
    nodes.add(new Node(nextNode));
    biasNode = nextNode; 
    nextNode++;
    nodes.get(biasNode).layer = 0;
  }
  
  /* Returns matching node */
  Node getNode(int nodeNumber) {
    for (int i = 0; i < nodes.size(); i++) {
      if (nodes.get(i).number == nodeNumber) {
        return nodes.get(i);
      }
    }
    return null;
  }
  
  /* Creates the network out of the nodes */
  void connectNodes() {
    //Wipe the current connections
    for (int i = 0; i< nodes.size(); i++) {
      nodes.get(i).outputConnections.clear();
    }

    //Reconnect the nodes
    for (int i = 0; i < genes.size(); i++) {
      genes.get(i).fromNode.outputConnections.add(genes.get(i));
    }
  }
  
  //Feed input values into the network and returning the output
  float[] feedForward(float[] inputValues) {
    //Set outputs for the input nodes
    for (int i = 0; i < inputs; i++) {
      nodes.get(i).outputValue = inputValues[i];
    }
    
    nodes.get(biasNode).outputValue = 1;

    //For each node in the network send its output to connected nodes
    for (int i = 0; i < network.size(); i++) {
      network.get(i).engage();
    }

    //Save the outputs of forward nodes
    float[] output = new float[outputs];
    for (int i = 0; i < outputs; i++) {
      output[i] = nodes.get(inputs + i).outputValue;
    }

    //Reset all nodes for the next thought
    for (int i = 0; i < nodes.size(); i++) {
      nodes.get(i).inputSum = 0;
    }

    return output;
  }
  
  /* Set up the NN as a list of nodes in order to be engaged */
  void generateNetwork() {
    //Base code framework from Code Bullet
    connectNodes();
    network = new ArrayList<Node>();
    //For each layer add the node in that layer, since layers cannot connect to themselves there is no need to order the nodes within a layer
    for (int l = 0; l < layers; l++) {
      for (int i = 0; i < nodes.size(); i++) {
        if (nodes.get(i).layer == l) {
          network.add(nodes.get(i)); //Add the node to the network
        }
      }
    }
  }
  
  /* Add a node to the NN by choosing a random connection, disabling it, then connecting twice, creating the node */
  void addNode(ArrayList<ConnectionHistory> innovationHistory) {
    //Base code framework from Code Bullet
    //Choose the connection
    if (genes.size() == 0) {
      addConnection(innovationHistory); 
      return;
    }
    
    int randomConnection = floor(random(genes.size()));
    int count = 0;
    while (genes.get(randomConnection).fromNode == nodes.get(biasNode) && genes.size() !=1 && count <= 5000) {
      count++;
      randomConnection = floor(random(genes.size())); //Prevent bias disconnect
    }
    genes.get(randomConnection).enabled = false; //Disable the connection

    int newNodeNo = nextNode;
    nodes.add(new Node(newNodeNo));
    nextNode++;
    
    int connectionInnovationNumber = getInnovationNumber(innovationHistory, genes.get(randomConnection).fromNode, getNode(newNodeNo));
    genes.add(new ConnectionGene(genes.get(randomConnection).fromNode, getNode(newNodeNo), 1, connectionInnovationNumber)); //Add a new connection with a weight of one
    connectionInnovationNumber = getInnovationNumber(innovationHistory, getNode(newNodeNo), genes.get(randomConnection).toNode);
    
    genes.add(new ConnectionGene(getNode(newNodeNo), genes.get(randomConnection).toNode, genes.get(randomConnection).weight, connectionInnovationNumber)); //Replace the old connection with the same weight
    getNode(newNodeNo).layer = genes.get(randomConnection).fromNode.layer + 1;

    connectionInnovationNumber = getInnovationNumber(innovationHistory, nodes.get(biasNode), getNode(newNodeNo));
    genes.add(new ConnectionGene(nodes.get(biasNode), getNode(newNodeNo), 0, connectionInnovationNumber)); //Connect the bias to the node
    
    if (getNode(newNodeNo).layer == genes.get(randomConnection).toNode.layer) {
      for (int i = 0; i< nodes.size() -1; i++) {//dont include this newest node
        if (nodes.get(i).layer >= getNode(newNodeNo).layer) {
          nodes.get(i).layer ++; //Add a new layer if the new node layer is equal to the output node layer
        }
      }
      layers++;
    }
    connectNodes();
    print(9);
  }
  
  /* Connects two nodes together */
  void addConnection(ArrayList<ConnectionHistory> innovationHistory) {
    //Base code by Code Bullet
    if (fullyConnected()) {
      println("Connection Failed"); //Error message
      return;
    }

    int randomNode1 = floor(random(nodes.size())); //Get random nodes
    int randomNode2 = floor(random(nodes.size()));
    while (ifConnected(randomNode1, randomNode2)) {
      randomNode1 = floor(random(nodes.size())); //Choose new nodes if they are already connected
      randomNode2 = floor(random(nodes.size()));
    }
    int temp;
    if (nodes.get(randomNode1).layer > nodes.get(randomNode2).layer) {
      temp = randomNode2; //Ensure nodes are properly ordered
      randomNode2 = randomNode1;
      randomNode1 = temp;
    }    

    int connectionInnovationNumber = getInnovationNumber(innovationHistory, nodes.get(randomNode1), nodes.get(randomNode2)); //Retrieve the innovation value

    genes.add(new ConnectionGene(nodes.get(randomNode1), nodes.get(randomNode2), random(-1, 1), connectionInnovationNumber)); //Add new connection
    connectNodes();
  }
  
  boolean ifConnected (int r1, int r2) {
    //Base code by Code Bullet
    if (nodes.get(r1).layer == nodes.get(r2).layer) return true; //If the nodes are in the same layer return true
    if (nodes.get(r1).isConnectedTo(nodes.get(r2))) return true; //If the nodes are already connected return true
    return false;
  }
  
  /* Create a new innovation value for new mutations, return old innvation value for non-unique mutations */
  int getInnovationNumber(ArrayList<ConnectionHistory> innovationHistory, Node from, Node to) {
    //Base code by Code Bullet
    boolean isNew = true;
    int connectionInnovationNumber = nextConnectionNo;
    for (int i = 0; i < innovationHistory.size(); i++) {
      if (innovationHistory.get(i).matches(this, from, to)) {
        isNew = false; //Mutation is not new
        connectionInnovationNumber = innovationHistory.get(i).innovationNumber; //Retrieve old mutation number
        break;
      }
    }

    if (isNew) {
      ArrayList<Integer> innoNumbers = new ArrayList<Integer>(); //Create new array representing the current genome if the mutation is new
      for (int i = 0; i< genes.size(); i++) {
        innoNumbers.add(genes.get(i).innovationNumber);
      }

      innovationHistory.add(new ConnectionHistory(from.number, to.number, connectionInnovationNumber, innoNumbers)); //Add new mutation to the innvation history
      nextConnectionNo++;
    }
    return connectionInnovationNumber;
  }
  
  /* returns whether or not the network is fully connected */
  boolean fullyConnected() {
    //Base code by Code Bullet
    int maxConnections = 0;
    int[] nodesInLayers = new int[layers];

    for (int i =0; i< nodes.size(); i++) {
      nodesInLayers[nodes.get(i).layer] += 1; //Fill the array with the nodes
    }

    for (int i = 0; i < layers-1; i++) {
      int nodesInFront = 0;
      for (int j = i+1; j < layers; j++) {
        nodesInFront += nodesInLayers[j]; //Add nodes for every layer infront of the current layer
      }

      maxConnections += nodesInLayers[i] * nodesInFront; //Generates the maximum possible connections within the network
    }

    if (maxConnections == genes.size()) {
      return true; //Return true if the network is fully connected
    }
    return false;
  }
  
  /* Mutate the genome */
  void mutate(ArrayList<ConnectionHistory> innovationHistory) {
    //Base code by Code Bullet
    if (genes.size() == 0) {
      addConnection(innovationHistory);
    }
    float rand1 = random(1);
    if (rand1 < 0.8) {
      for (int i = 0; i < genes.size(); i++) {
        genes.get(i).mutateWeight(); //Mutate weights 80% of the time
      }
    }
    float rand2 = random(1);
    if (rand2 < 0.08) {
      addConnection(innovationHistory); //Add a new connection 8% of the time
    }
    float rand3 = random(1);
    if (rand3 < 0.02) {
      addNode(innovationHistory); //Add a new node 2% of the time
    }
  }
  
  /* Mix the traits of two genomes */
  Brain crossover(Brain parent2) {
    //Base code by Code Bullet
    Brain child = new Brain(inputs, outputs, true); //Create the new genome
    child.genes.clear();
    child.nodes.clear();
    child.layers = layers;
    child.nextNode = nextNode;
    child.biasNode = biasNode;
    ArrayList<ConnectionGene> childGenes = new ArrayList<ConnectionGene>(); //Form the required list of genes
    ArrayList<Boolean> isEnabled = new ArrayList<Boolean>(); 
    
    for (int i = 0; i < genes.size(); i++) {
      boolean setEnabled = true;
      int parent2gene = matchingGene(parent2, genes.get(i).innovationNumber);
      if (parent2gene != -1) { //If the genes match
        if (!genes.get(i).enabled || !parent2.genes.get(parent2gene).enabled) { //If either of the matching genes are disabled

          if (random(1) < 0.75) {
            setEnabled = false; //Disable the gene 75% of the time
          }
        }
        
        float rand = random(1);
        if (rand < 0.5) {
          childGenes.add(genes.get(i)); //Add gene from paret one 50% of the time
        } else {
          childGenes.add(parent2.genes.get(parent2gene)); //Add gene from parent two 50% of the time
        }
      } else {
        childGenes.add(genes.get(i)); //Add excess genes
        setEnabled = genes.get(i).enabled;
      }
      isEnabled.add(setEnabled);
    }
    
    for (int i = 0; i < nodes.size(); i++) {
      child.nodes.add(nodes.get(i).clone()); //Inherit all nodes
    }

    for ( int i = 0; i < childGenes.size(); i++) {
      child.genes.add(childGenes.get(i).clone(child.getNode(childGenes.get(i).fromNode.number), child.getNode(childGenes.get(i).toNode.number))); //Inherit all connections
      child.genes.get(i).enabled = isEnabled.get(i);
    }

    child.connectNodes();
    return child; //Return the new genome
  }
  
  /* Create an empty genome */
  Brain(int in, int out, boolean crossover) {
    inputs = in; 
    outputs = out;
  }
  
  /* Return if a gene matching the input innovation number is found */
  int matchingGene(Brain parent2, int innovationNumber) {
    //Base code by Code Bullet
    for (int i = 0; i < parent2.genes.size(); i++) {
      if (parent2.genes.get(i).innovationNumber == innovationNumber) {
        return i;
      }
    }
    return -1; //No matching gene found
  }
  
  /* Prints genome information */
  void printGenome() {
    println("Print genome  layers:", layers);  
    println("bias node: "  + biasNode);
    println("nodes");
    for (int i = 0; i < nodes.size(); i++) {
      print(nodes.get(i).number + ",");
    }
    println("Genes");
    for (int i = 0; i < genes.size(); i++) {
      println("gene " + genes.get(i).innovationNumber, "From node " + genes.get(i).fromNode.number, "To node " + genes.get(i).toNode.number, 
        "is enabled " +genes.get(i).enabled, "from layer " + genes.get(i).fromNode.layer, "to layer " + genes.get(i).toNode.layer, "weight: " + genes.get(i).weight);
    }

    println();
  }
  
  
  /* Return a copy of this genome */
  Brain clone() {
    Brain clone = new Brain(inputs, outputs, true);

    for (int i = 0; i < nodes.size(); i++) {
      clone.nodes.add(nodes.get(i).clone()); //Copy all nodews
    }

    for ( int i = 0; i < genes.size(); i++) {//copy genes
      clone.genes.add(genes.get(i).clone(clone.getNode(genes.get(i).fromNode.number), clone.getNode(genes.get(i).toNode.number))); //Copy all connections
    }

    clone.layers = layers;
    clone.nextNode = nextNode;
    clone.biasNode = biasNode;
    clone.connectNodes();

    return clone; //Return clone
  }
  
  /* Draw the genome on the screen */
  void drawGenome(int startX, int startY, int w, int h) {
    //Code by Code Bullet
    ArrayList<ArrayList<Node>> allNodes = new ArrayList<ArrayList<Node>>();
    ArrayList<PVector> nodePoses = new ArrayList<PVector>();
    ArrayList<Integer> nodeNumbers= new ArrayList<Integer>();
    
    for (int i = 0; i < layers; i++) {
      ArrayList<Node> temp = new ArrayList<Node>();
      for (int j = 0; j < nodes.size(); j++) {
        if (nodes.get(j).layer == i ) {
          temp.add(nodes.get(j)); //Arange the nodes according to the current layer
        }
      }
      allNodes.add(temp); //Add the current layer to array
    }
    
    for (int i = 0; i < layers; i++) {
      fill(255, 0, 0);
      float x = startX + (float)((i + 1) * w) / (float)(layers + 1.0);
      for (int j = 0; j < allNodes.get(i).size(); j++) {
        float y = startY + ((float)(j + 1.0) * h)/(float)(allNodes.get(i).size() + 1.0);
        nodePoses.add(new PVector(x, y)); //Add node position to array
        nodeNumbers.add(allNodes.get(i).get(j).number); //Add node number to array
      }
    }
    
    stroke(0);
    strokeWeight(2);
    for (int i = 0; i< genes.size(); i++) {
      if (genes.get(i).enabled) {
        stroke(0);
      } else {
        stroke(100);
      }
      PVector from;
      PVector to;
      from = nodePoses.get(nodeNumbers.indexOf(genes.get(i).fromNode.number)); //Draw conections
      to = nodePoses.get(nodeNumbers.indexOf(genes.get(i).toNode.number)); //Draw connections
      if (genes.get(i).weight > 0) {
        stroke(255, 0, 0);
      } else {
        stroke(0, 0, 255);
      }
      strokeWeight(map(abs(genes.get(i).weight), 0, 1, 0, 5));
      line(from.x, from.y, to.x, to.y);
    }
    
    for (int i = 0; i < nodePoses.size(); i++) {
      fill(255);
      stroke(0);
      strokeWeight(1);
      ellipse(nodePoses.get(i).x, nodePoses.get(i).y, 20, 20); //Draw nodes ontop of connections
      textSize(10);
      fill(0);
      textAlign(CENTER, CENTER);
      text(nodeNumbers.get(i), nodePoses.get(i).x, nodePoses.get(i).y);
    }
  }
}
