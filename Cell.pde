class Cell{
  float trueX, trueY, gridX, gridY;
  float cellWidth, cellHeight;
  boolean isWall, isOccupied, isGoal, isSpawn;
  
  float[] goalPos;
  
  float g;
  float f;
  
  float h = -1;
  
  Cell parent = null;
  boolean activated;
  
  Cell(float t_trueX, float t_trueY, float t_gridX, float t_gridY, float t_cellWidth, float t_cellHeight, boolean t_isWall, float[] t_spawnPos, float[] t_goalPos, boolean t_isOccupied){
    cellWidth = t_cellWidth;
    cellHeight = t_cellHeight;
    
    trueX = t_trueX;
    trueY = t_trueY;
    
    gridX = t_gridX;
    gridY = t_gridY;
    
    goalPos = t_goalPos;

    isSpawn = (gridX == t_spawnPos[0] && gridY == t_spawnPos[1]);
    isGoal = (gridX == goalPos[0] && gridY == goalPos[1]);
    isWall = t_isWall;
    
    isOccupied = t_isOccupied;
    
    if(isSpawn) {
      g = 0;
    }
  }
  
  float getH(Cell goal) {
    if(h == -1){
      h = abs(gridX - goalPos[0]) + abs(gridY - goalPos[1]);
    }
    
    return h;
  }
  
  void activate() {
    activated = true;
  }
  
  void changeColour(int v1, int v2, int v3) {
    fill(v1, v2, v3);
    stroke(v1, v2, v3);
  }
  
  void display() {
    if(this.isWall){
      changeColour(0, 0, 0);
    } else if(this.isGoal) {
      changeColour(255, 0, 0);
    } else if(this.isSpawn) {
      changeColour(0, 0, 255);
    } else if(this.isOccupied) {
      changeColour(0, 128, 0);
    } else if (this.activated) {
      changeColour(0, 255, 0);
    } else {
      changeColour(255, 255, 255);
    }

    rect(this.trueX, this.trueY, this.trueX + this.cellWidth, this.trueY + this.cellHeight);
  }
}
