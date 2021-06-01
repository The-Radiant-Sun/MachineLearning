class Cell{
  float x, y;
  float cellWidth, cellHeight;
  boolean isWall, isOccupied, isGoal, isSpawn;
  
  int[] spawn = new int[2];
  int[] goal = new int[2];
  
  float g; 
  float h;
  float f;
  
  Cell(float t_x, float t_y, float t_cellWidth, float t_cellHeight, boolean t_isWall, boolean t_isOccupied, int[] t_spawn, int[] t_goal){
    x = t_x;
    y = t_y;
    cellWidth = t_cellWidth;
    cellHeight = t_cellHeight;
    isWall = t_isWall;
    isOccupied = t_isOccupied;
    spawn = t_spawn;
    goal = t_goal;
    
    if (x == goal[0] && y == goal[1]) {
      isGoal = true;
    } else if (x == spawn[0] && y == spawn[1]) {
      isSpawn = true;
    } else {
      isGoal = false;
      isSpawn = false;
    }
  }
  
  void calculateAStar() {
    g = distance(spawn);
    h = distance(goal);
    f = g + h;
  }
  
  void display() {
    if(this.isWall){
      fill(0);
    } else if(this.isOccupied) {
      fill(0, 128, 0);
    } else if(this.isGoal) {
      fill(255, 0, 0);
    } else if(this.isSpawn) {
      fill(0, 0, 225);
    } else {
      fill(255);
    }
    rect(this.x, this.y, this.x + this.cellWidth, this.y + this.cellHeight);
  }
  
  float distance(int[] end) {
    return abs(x - end[0]) + abs(y - end[1]);
  }
}
