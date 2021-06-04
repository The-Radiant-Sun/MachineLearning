class AStar{
  ArrayList<Cell> open = new ArrayList<Cell>();
  ArrayList<Cell> closed = new ArrayList<Cell>();
  
  ArrayList<Cell> path = newArrayList<Cell>();

  Cell[][] grid;
  Cell goal;
  
  AStar(Cell[][] cells, Cell t_goal, Cell t_spawn){
    grid = cells;
    open.add(t_spawn);
    
    goal = t_goal;
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
    Cell current = open.get(0);
    ArrayList<Cell> neighbours = new ArrayList<Cell>();
    
    while(goal != current && open.size() > 0){
      closed.add(current);
      
      for(int x = -1; x < 2; x++) {
        for(int y = -1; y < 2; y++) {
          Cell cell = grid[x][y]
          
          if(!cell.isWall || in(closed, cell) || (x == 0 && y == 0)) {
            continue;
          }
          
          if((in(open, cell) || cell.g > current.g + 1) && !cell.isWall && (x == 0 && y == 0)) {
            cell.g = current.g + 1;
          }
        }
      }
      
      current = findLowestF();
    }
    
    while(current.parent != null){
      path.add(0, current);
      current.activate();
      current = current.parent;
    }
  }
}
