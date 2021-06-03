class Map{
  int cellXNumbers, cellYNumbers;
  float cellWidth, cellHeight, obstacleChance;
  
  Cell[][] cells;

  boolean[][] walls;
  Cell goal;
  Cell spawn;
  
  Map(int XNumber, int YNumber, float obstacleSaturation){
    boolean isWall, isOccupied, isGoal, isSpawn;
    int[] goalPos, spawnPos;
    
    cellXNumbers = XNumber;
    cellYNumbers = YNumber;
    cellWidth = width/cellXNumbers;
    cellHeight = height/cellYNumbers;
    
    obstacleChance = 1 / obstacleSaturation;
    
    cells = new Cell[cellXNumbers][cellYNumbers];
    walls = new boolean[cellXNumbers][cellYNumbers];
    
    isOccupied = false;
    
    goalPos = new int[2];
    spawnPos = new int[2];

    goalPos[0] = width / cellXNumbers * int(random(cellXNumbers - 1));
    goalPos[1] = height / cellYNumbers * int(random(cellYNumbers - 1));
    
    spawnPos[0] = width / cellXNumbers * int(random(cellXNumbers - 1));
    spawnPos[1] = height / cellYNumbers * int(random(cellYNumbers - 1));
    
    for(int x = 0; x < cellXNumbers; x++){
      for(int y = 0; y < cellYNumbers; y++){
        isGoal = comparePos(x, y, goalPos);
        isSpawn = comparePos(x, y, spawnPos);
        
        if(random(1) < obstacleChance && !isGoal && !isSpawn) {
          isWall = true;
        } else {
          isWall = false;
        }

        cells[x][y] = new Cell(width/cellXNumbers * x, height/cellYNumbers * y, x, y, cellWidth, cellHeight, isWall, isSpawn, isGoal, isOccupied);
        walls[x][y] = isWall;
        
        if(isGoal) {
          goal = cells[x][y];
        } if(isSpawn) {
                 spawn = cells[x][y];
        }
      }
    }
  }
  
  boolean comparePos(int x, int y, int[] end) {
    return (x == end[0] && y == end[1]);
  }
}
