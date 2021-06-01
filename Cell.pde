class Cell{
  float x, y;
  float cellWidth, cellHeight;
  boolean isWall, isOccupied, isGoal;
  
  Cell(float t_x, float t_y, float t_cellWidth, float t_cellHeight, boolean t_isWall, boolean t_isOccupied, boolean t_isGoal){
    x = t_x;
    y = t_y;
    cellWidth = t_cellWidth;
    cellHeight = t_cellHeight;
    isWall = t_isWall;
    isOccupied = t_isOccupied;
    isGoal = t_isGoal;
  }
  
  void display(){
    if(this.isWall){
      fill(0);
    } else if(this.isOccupied) {
      fill(0, 128, 0);
    } else if(this.isGoal) {
      fill(255, 0, 0);
    } else {
      fill(255);
    }
    rect(this.x, this.y, this.x + this.cellWidth, this.y + this.cellHeight);
  }
}
