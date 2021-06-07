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
      
      for(int x = -1; x < 2; x++) {
        for(int y = ((current.gridX % 2 == 0) ? -1 : ((x == 0) ? -1 : 0)); y < ((x == 0) ? 2 : ((current.gridX % 2 == 0) ? 1 : 2)); y++) {
          
          int newX = x + current.gridX;
          int newY = y + current.gridY;
          
          if(!(newX < 0 || newY < 0 || newX >= grid.length || newY >= grid[grid.length - 1].length)){
            Cell cell = grid[newX][newY];
            
            if((in(open, cell) || cell.g > current.g + 1 || cell.g == -1) && !cell.isWall && !(x == 0 && y == 0)) {
              cell.g = current.g + 1;
              cell.f = cell.g + cell.getH();
              
              cell.parent = current;
              
              if(!in(open, cell)) {
                open.add(cell);
                
              }
            }
          }
        }
      }
      
      current = findLowestF();
    }
    
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
