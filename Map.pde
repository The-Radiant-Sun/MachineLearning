class Map{
  int cellXNumbers, cellYNumbers;
  float cellWidth, cellHeight, obstacleChance;
  
  Cell[][] cells;

  boolean[][] walls;
  Cell goal;
  Cell spawn;
  
  Map(int XNumber, int YNumber, float obstacleSaturation){
    boolean isWall, isOccupied, isGoal, isSpawn;
    float[] goalPos, spawnPos;
    
    cellXNumbers = XNumber;
    cellYNumbers = YNumber;
    cellWidth = width/cellXNumbers;
    cellHeight = height/cellYNumbers;
    
    obstacleChance = 1 / obstacleSaturation;
    
    cells = new Cell[cellXNumbers][cellYNumbers];
    walls = new boolean[cellXNumbers][cellYNumbers];
    
    isOccupied = false;
    
    goalPos = new float[2];
    spawnPos = new float[2];

    goalPos[0] = round(random(cellXNumbers - 1));
    goalPos[1] = round(random(cellYNumbers - 1));
    
    spawnPos[0] = round(random(cellXNumbers - 1));
    spawnPos[1] = round(random(cellYNumbers - 1));
    
    for(int x = 0; x < cellXNumbers; x++){
      for(int y = 0; y < cellYNumbers; y++){
        isGoal = comparePos(x, y, goalPos);
        isSpawn = comparePos(x, y, spawnPos);
        
        if(random(1) < obstacleChance && !isGoal && !isSpawn) {
          isWall = true;
        } else {
          isWall = false;
        }

        cells[x][y] = new Cell(width/cellXNumbers * x, height/cellYNumbers * y, x, y, cellWidth, cellHeight, isWall, spawnPos, goalPos, isOccupied);
        walls[x][y] = isWall;
        
        if(isGoal) {
          goal = cells[x][y];
        } if(isSpawn) {
                 spawn = cells[x][y];
        }
      }
    }
  }
  
  boolean comparePos(float x, float y, float[] end) {
    return (x == end[0] && y == end[1]);
  }
}
