 class Map{
  int cellXNumbers, cellYNumbers;
  float cellWidth, cellHeight, obstacleChance;
  
  Cell[][] cells;
  
  Cell goal;
  Cell spawn;
  
  Map(int XNumber, int YNumber, float obstacleSaturation){
    /* Initializer */
    boolean isWall, isGoal, isSpawn;
    float[] goalPos, spawnPos;
    
    cellXNumbers = XNumber;
    cellYNumbers = YNumber;
    cellWidth = width / XNumber;
    cellHeight = height / YNumber;
    
    obstacleChance = 1 / obstacleSaturation;
    
    cells = new Cell[cellXNumbers][cellYNumbers];
    
    goalPos = new float[2];
    spawnPos = new float[2];
    
    goalPos[0] = 0;
    goalPos[1] = 0;
    
    spawnPos[0] = 0;
    spawnPos[1] = 0;
    
    /* While the goal and the spawn are within 10 units of each other, find new locations */
    while(abs(goalPos[0] - spawnPos[0]) < 10 || abs(goalPos[1] - spawnPos[1]) < 10) {
      goalPos[0] = round(random(1, cellXNumbers - 2));
      goalPos[1] = round(random(1, cellYNumbers - 2));
      
      spawnPos[0] = round(random(1, cellXNumbers - 2));
      spawnPos[1] = round(random(1, cellYNumbers - 2));
    }
    
    /* Assign values for all cells within grid size */
    for(int x = 0; x < cellXNumbers; x++){
      for(int y = 0; y < cellYNumbers; y++){
        isGoal = comparePos(x, y, goalPos);
        isSpawn = comparePos(x, y, spawnPos);
        
        if(!isGoal && !isSpawn && (random(1) < obstacleChance || (x == 0 || x == cellXNumbers - 1) || (y == 0 || y == cellYNumbers - 1))) {
          isWall = true; //Only allow cell to be a wall if it is not the goal or spawn
        } else {
          isWall = false;
        }
        
        float trueX = x * cellWidth; //Recording the actual coordinates
        float trueY = y * cellHeight;
        
        if(x % 2 == 1) {
          trueY += cellHeight / 2;
        }
        
        cells[x][y] = new Cell(trueX, trueY, x, y, cellWidth, cellHeight, isWall, spawnPos, goalPos); //Populate position with Cell object
        
        if(isGoal) {
          goal = cells[x][y]; //Record goal and spawn positions seperately
        } if(isSpawn) {
          spawn = cells[x][y];
        }
      }
    }
    
    /* Link the cells together as neighbors */
    for(int x = 0; x < cellXNumbers; x++){
      for(int y = 0; y < cellYNumbers; y++){
        Cell current = cells[x][y];

        for(int n_x = -1; n_x < 2; n_x++) {
          for(int n_y = ((n_x == 0) ? -1 : ((current.gridX % 2 == 0) ? -1 : 0)); n_y < ((n_x == 0) ? 2 : ((current.gridX % 2 == 0) ? 1 : 2)); n_y++) {
            int newX = n_x + current.gridX;
            int newY = n_y + current.gridY;
            
            if((newX == current.gridX && newY == current.gridY) || (newX < 0 || newY < 0 || newX >= cells.length || newY >= cells[cells.length - 1].length)) {
              continue;
            }
            
            current.neighbours.add(cells[newX][newY]); //Connect the cells together
          }
        }
      }
    }
  }
  
  boolean comparePos(float x, float y, float[] end) {
    return (x == end[0] && y == end[1]);
  }
}
