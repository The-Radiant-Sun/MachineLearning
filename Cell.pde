class Cell{
  float trueX, trueY, gridX, gridY;
  float cellWidth, cellHeight;
  boolean isWall, isOccupied, isGoal, isSpawn;
  
  int[] spawn = new int[2];
  int[] goal = new int[2];
  
  float g; 
  float h;
  float f;
  
  Cell(float t_trueX, float t_trueY, float t_gridX, float t_gridY, float t_cellWidth, float t_cellHeight, boolean t_isWall, boolean t_isSpawn, boolean t_isGoal, boolean t_isOccupied){
    cellWidth = t_cellWidth;
    cellHeight = t_cellHeight;
    
    trueX = t_trueX;
    trueY = t_trueY;
    
    gridX = t_gridX;
    gridY = t_gridY;

    isSpawn = t_isSpawn;
    isGoal = t_isGoal;
    isWall = t_isWall;
    
    isOccupied = t_isOccupied;
    
    g = distanceTo(spawn);
    h = distanceTo(goal);
    f = g + h;
  }
  
  void display() {
    if(this.isWall){
      fill(0);
      stroke(0);
    } else if(this.isOccupied) {
      fill(0, 128, 0);
      stroke(0, 128, 0);
    } else if(this.isGoal) {
      fill(255, 0, 0);
      stroke(255, 0, 0);
    } else if(this.isSpawn) {
      fill(0, 0, 255);
      stroke(0, 0, 255);
    } else {
      fill(255);
      stroke(255);
    }

    rect(this.x, this.y, this.x + this.cellWidth, this.y + this.cellHeight);
  }
  
  float distanceTo(int[] end) {
    return abs(this.x - end[0]) + abs(this.y - end[1]);
  }
}
