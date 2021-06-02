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
    isOccupied = t_isOccupied;
    spawn = t_spawn;
    goal = t_goal;
    
    if (x == goal[0] && y == goal[1]) {
      isGoal = true;
      isWall = false;
    } else if (x == spawn[0] && y == spawn[1]) {
      isSpawn = true;
      isWall = false;
    } else {
      isGoal = false;
      isSpawn = false;

      isWall = t_isWall;
    }
    
    AStarValues();
  }
  
  void AStarValues() {
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
