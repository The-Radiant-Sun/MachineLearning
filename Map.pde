class Map{
  int cellXNumbers, cellYNumbers;
  float cellWidth, cellHeight, obstacleChance;
  
  Cell[][] cells;
  
  boolean isWall, isOccupied, isGoal;

  boolean[][] walls;
  int[] goal = new int[2];
  int[] spawn = new int[2];
  
  Map(int XNumber, int YNumber, float obstacleSaturation){
    cellXNumbers = XNumber;
    cellYNumbers = YNumber;
    cellWidth = width/cellXNumbers;
    cellHeight = height/cellYNumbers;
    
    obstacleChance = 1 / obstacleSaturation;
    
    cells = new Cell[cellXNumbers][cellYNumbers];
    walls = new boolean[cellXNumbers][cellYNumbers];

    goal[0] = width / cellXNumbers * int(random(cellXNumbers - 1));
    goal[1] = height / cellYNumbers * int(random(cellYNumbers - 1));
    
    spawn[0] = width / cellXNumbers * int(random(cellXNumbers - 1));
    spawn[1] = height / cellYNumbers * int(random(cellYNumbers - 1));
    
    for(int x = 0; x < cellXNumbers; x++){
      for(int y = 0; y < cellYNumbers; y++){
        if(random(1) < obstacleChance && !comparePos(x, y, goal) && !comparePos(x, y, spawn)) {
          isWall = true;
        } else {
          isWall = false;
        }

        cells[x][y] = new Cell(width/cellXNumbers * x, height/cellYNumbers * y, cellWidth, cellHeight, isWall, isOccupied, spawn, goal);
        walls[x][y] = isWall;
      }
    }
  }
  
  boolean comparePos(int x, int y, int[] end) {
    return (x == end[0] && y == end[1]);
  }
}
