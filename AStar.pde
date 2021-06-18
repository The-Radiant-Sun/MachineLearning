class AStar{
  ArrayList<Cell> open = new ArrayList<Cell>();
  ArrayList<Cell> closed = new ArrayList<Cell>();
  
  ArrayList<Cell> path = new ArrayList<Cell>();
  
  boolean pathFound, possiblePath;
  
  Cell current;

  Cell[][] grid;
  Cell goal;
  
  AStar(Cell[][] cells, Cell t_goal, Cell t_spawn){
    grid = cells;
    open.add(t_spawn);
    
    goal = t_goal;
    
    current = open.get(0);
      
    possiblePath = true;
  }
  
  Cell findLowestF(){
    Cell lowestF = null;
    for(Cell node: open){
      if(lowestF == null || node.f < lowestF.f) {
        lowestF = node;
      }
    }
    return lowestF;
  }
  
  boolean in(ArrayList<Cell> list, Cell target) {
    for(Cell cell: list) {
      if(cell == target) {
        return true;
      }
    }
    return false;
  }
  
  void pathfind(){
    if(goal != current && open.size() > 0){
      closed.add(current);
      open.remove(current);

      current.scanned = true;
      
      for(Cell neighbour : current.neighbours){
          if((in(open, neighbour) || neighbour.g > current.g + 1 || neighbour.g == -1) && !neighbour.isWall) {
            neighbour.g = current.g + 1;
            neighbour.f = neighbour.g + neighbour.getH();
              
            neighbour.parent = current;
              
            if(!in(open, neighbour)) {
              open.add(neighbour);
                
            }
          }
        }
      }
      
    current = findLowestF();
    
    if(goal == current) {
      Cell reTrace = current;
      pathFound = true;
      while(true){
        path.add(0, reTrace);
        reTrace.activated = true;
        reTrace.display();
        if(reTrace.parent.isSpawn) {
          break;
        }
        reTrace = reTrace.parent;
      }
    }

    if(open.size() == 0) {
      pathFound = false;
      possiblePath = false;
      
      print("Path not Found");
    }
  }
}
