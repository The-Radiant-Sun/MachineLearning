/* Drawing framework by code bullet */
class PWindow extends PApplet {
  NEAT bots;
  Brain botBrain;
  
  PWindow(NEAT t_bots) {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
    
    bots = t_bots;
  }

  /* Display current bot brain */
  void drawBrain() {
    int startX = 0;
    int startY = 0;
    int w = width;
    int h = height;
    
    if(bots.bots != null) {
      int v = 0;
      Bot bot = bots.bots.get(v);
      while(!bots.bots.get(v).alive) {
        v++;
        if(v == bots.bots.size()) {
          break;
        }
        
        bot = bots.bots.get(v);
      }
      
      botBrain = bot.brain;
      
      ArrayList<ArrayList<Node>> allNodes = new ArrayList<ArrayList<Node>>();
      ArrayList<PVector> nodePoses = new ArrayList<PVector>();
      ArrayList<Integer> nodeNumbers= new ArrayList<Integer>();
  
      //Split nodes into layers
      for (int i = 0; i < botBrain.layers; i++) {
        ArrayList<Node> temp = new ArrayList<Node>();
        for (int j = 0; j < botBrain.nodes.size(); j++) {
          if (botBrain.nodes.get(j).layer == i ) {
            temp.add(botBrain.nodes.get(j));
          }
        }
        allNodes.add(temp); //Add layer to list
      }
  
      //For each layer add the position of the node on the screen to the nodePoses arraylist
      for (int i = 0; i < botBrain.layers; i++) {
        fill(255, 0, 0);
        float x = startX + (float)((i + 1) * w) / (float)(botBrain.layers + 1.0);
        for (int j = 0; j < allNodes.get(i).size(); j++) {//for the position in the layer
          float y = startY + ((float)(j + 1.0) * h) / (float)(allNodes.get(i).size() + 1.0);
          nodePoses.add(new PVector(x, y));
          nodeNumbers.add(allNodes.get(i).get(j).number);
        }
      }
  
      //Draw connections 
      stroke(0);
      strokeWeight(2);
      for (int i = 0; i< botBrain.genes.size(); i++) {
        if (botBrain.genes.get(i).enabled) {
          stroke(0);
        } else {
          stroke(100);
        }
        PVector from;
        PVector to;
        from = nodePoses.get(nodeNumbers.indexOf(botBrain.genes.get(i).fromNode.number));
        to = nodePoses.get(nodeNumbers.indexOf(botBrain.genes.get(i).toNode.number));
        if (botBrain.genes.get(i).weight > 0) {
          stroke(255, 0, 0);
        } else {
          stroke(0, 0, 255);
        }
        strokeWeight(map(abs(botBrain.genes.get(i).weight), 0, 1, 0, 5));
        line(from.x, from.y, to.x, to.y);
      }
  
      //Draw nodes
      for (int i = 0; i < nodePoses.size(); i++) {
        fill(255);
        stroke(0);
        strokeWeight(1);
        ellipse(nodePoses.get(i).x, nodePoses.get(i).y, 20, 20);
        textSize(10);
        fill(0);
        textAlign(CENTER, CENTER);
        text(nodeNumbers.get(i), nodePoses.get(i).x, nodePoses.get(i).y);
      }
    }
  }
  
  void settings() {
    fullScreen();
  }
  
  void draw() {
    background(255);
    drawBrain();
  }
}
