class AStar{
  ArrayList<Cell> open = new ArrayList<Cell>();
  ArrayList<Cell> closed = new ArrayList<Cell>();
  
  ArrayList<Cell> path = new ArrayList<Cell>();
  
  boolean pathFound;
  
  Cell current;

  Cell[][] grid;
  Cell goal;
  
  AStar(Cell[][] cells, Cell t_goal, Cell t_spawn){
    grid = cells;
    open.add(t_spawn);
    
    goal = t_goal;
    
    current = open.get(0);
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
        for(int y = -1; y < 2; y++) {
          int newX = x + current.gridX;
          int newY = y + current.gridY;
          
          if(newX < 0 || newY < 0 || newX > grid.length || newY > grid[grid.length - 1].length){
            continue;
          }
          
          Cell cell = grid[newX][newY];
          
          if((in(open, cell) || cell.g > current.g + 1 || cell.g == -1) && !cell.isWall && !(x == 0 && y == 0) && !((x == -1 || x == 1 ) && (y == -1 || y == 1))) {
            cell.g = current.g + 1;
            cell.f = cell.g + cell.getH();
            
            if(!in(open, cell)) {
              open.add(cell);
            }
          }
        }
      }
      
      current = findLowestF();
    }
    
    if(in(open, goal)) {
      pathFound = true;
      while(true){
        path.add(0, current);
        current.activate();
        if(current.parent == null) {
          break;
        }
        current = current.parent;
      }
    }
    
    if(open.size() == 0) {
      pathFound = false;
    }
  }
}
