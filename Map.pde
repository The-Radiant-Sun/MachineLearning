class Map{
  int cellXNumbers, cellYNumbers;
  float cellWidth, cellHeight, obstacleChance;
  
  Cell[][] cells;
  
  boolean isWall, isOccupied, isGoal;

  boolean[][] walls;
  int[] goal;
  
  Map(int XNumber, int YNumber, float obstacleSaturation){
    cellXNumbers = XNumber;
    cellYNumbers = YNumber;
    cellWidth = width/cellXNumbers;
    cellHeight = height/cellYNumbers;
    
    obstacleChance = 1 / obstacleSaturation;
    
    cells = new Cell[cellXNumbers][cellYNumbers];
    walls = new boolean[cellXNumbers][cellYNumbers];

    goal = new int[2];
    
    for(int x = 0; x < cellXNumbers; x++){
      for(int y = 0; y < cellYNumbers; y++){
        if(random(1) < obstacleChance) {
          isWall = true;
        } else {
          isWall = false;
        }

        cells[x][y] = new Cell(width/cellXNumbers * x, height/cellYNumbers * y, cellWidth, cellHeight, isWall, isOccupied, isGoal);
        walls[x][y] = isWall;
      }
    }
  }
}
