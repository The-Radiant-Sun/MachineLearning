class Map{
  int cellXNumbers, cellYNumbers;
  float cellWidth, cellHeight, obstacleChance;
  
  Cell[][] cells;

  boolean[][] walls;
  Cell goal;
  Cell spawn;
  
  Map(int XNumber, int YNumber, float obstacleSaturation){
    boolean isWall, isGoal, isSpawn;
    float[] goalPos, spawnPos;
    
    cellXNumbers = XNumber;
    cellYNumbers = YNumber;
    cellWidth = (width / 4 * 3) / cellXNumbers / 4 * 3;
    cellHeight = (height / 4 * 3) / cellYNumbers / 4 * 3;
    
    obstacleChance = 1 / obstacleSaturation;
    
    cells = new Cell[cellXNumbers][cellYNumbers];
    walls = new boolean[cellXNumbers][cellYNumbers];
    
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
        
        float trueX = x * (width / 4 * 3) / cellXNumbers + x * cellWidth / 5 * 2 + width / 32;
        float trueY = y * (height / 4 * 3) / cellYNumbers + y * cellHeight / 5 * 2 + height / 32;
        
        if(x % 2 == 1) {
          trueY += (height / 4 * 3) * 0.65 / cellYNumbers;
        }
        
        cells[x][y] = new Cell(trueX, trueY, x, y, cellWidth, cellHeight, isWall, spawnPos, goalPos);
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
