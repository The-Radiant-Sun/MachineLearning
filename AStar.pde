/* Generates the most optimal path between the spawn and the goal, logs a failure if it cannot */
class AStar{
  ArrayList<Cell> open; //List of unexplored cells
  ArrayList<Cell> closed; //List of explored cells
  
  ArrayList<Cell> path; //The found path
  
  boolean pathFound, possiblePath;
  
  Cell currentCell; //The cell it will read values from

  Cell[][] grid;
  Cell goal;
  
  /* Set initial variables for pathfinding */
  AStar(Cell[][] cells, Cell t_goal, Cell t_spawn){
    open = new ArrayList<Cell>();
    closed = new ArrayList<Cell>();
    path = new ArrayList<Cell>();
    
    grid = cells; //Updating with map values
    open.add(t_spawn);
    
    goal = t_goal;
    
    currentCell = open.get(0);
      
    possiblePath = true;
    pathFound = false;
  }
  
  /* Finding the most optimal next move */
  Cell findLowestF(){
    Cell lowestF = null;
    for(Cell node: open){
      //Compares the current values and saves which is lower
      if(lowestF == null || node.f < lowestF.f) {
        lowestF = node;
      }
    }
    return lowestF;
  }
  
  /* Shortened check if a cell is within a list of cells */
  boolean in(ArrayList<Cell> list, Cell target) {
    for(Cell cell: list) {
      if(cell == target) {
        return true;
      }
    }
    return false;
  }
  
  /* Use the f, g, and h values of each cell to find the most optimal path to the goal from the spawn, while logging significant events */
  void pathfind(){
    if(goal != currentCell && open.size() > 0){ //If there are still unexplored options
      closed.add(currentCell); //Explore the current cell
      open.remove(currentCell);

      currentCell.scanned = true; //Changing records
      
      for(Cell neighbour : currentCell.neighbours){ //For every neighboring cell
          if((neighbour.g > currentCell.g + 1 || neighbour.g == -1) && !neighbour.isWall) { //If they have a higher distance from the cell or are unexplored and not a wall
            neighbour.g = currentCell.g + 1; //Update their g value to the lower value, optimizing the path
            neighbour.f = neighbour.g + neighbour.getH(); //Update their f values
              
            neighbour.parent = currentCell; //Set that neighbour to be the child of the current cell
            
            //Add the new cell into the open list
            if(!in(open, neighbour)) {
              open.add(neighbour);
                
            }
          }
        }
      }
      
    currentCell = findLowestF(); //Change the current cell to the most optimal next path
    
    //Path found if at goal
    if(goal == currentCell) {
      Cell reTrace = currentCell;
      pathFound = true;
      
      print("Path found\n"); //Print for log
      
      //Display the most optimal path
      while(true){
        path.add(0, reTrace);
        reTrace.activated = true;
        reTrace.display();
        if(reTrace.parent.isSpawn) {
          break;
        }
        reTrace = reTrace.parent; //Iterate through all parents of the goal
      }
    }

    //If there are no unexplored options and the path is not complete, then change values
    if(open.size() == 0) {
      pathFound = false;
      possiblePath = false;
      
      print("Path not found\n"); //Print for log
    }
  }
}
