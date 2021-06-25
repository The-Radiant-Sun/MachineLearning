class Brain {
  PVector[] path;
  
  Brain(int pathLength) {
    path = new PVector[pathLength];
    newPath();
  }
  
  void newPath() {
    for(int i = 0; i < path.length; i ++) {
      path[i] = PVector.fromAngle(random(2*PI));
    }
  }
}
