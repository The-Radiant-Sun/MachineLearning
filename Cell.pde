class Cell{
  float trueX, trueY;
  int gridX, gridY;

  float cellWidth, cellHeight;
  boolean isWall, isGoal, isSpawn;
  
  float[] goalPos;
  
  float g = -1;
  float h = -1;
  
  float f;
  
  Cell parent;
  ArrayList<Cell> neighbours = new ArrayList<Cell>();
  
  boolean activated, scanned;
  
  boolean botsSpawned, occupied;
  
  boolean wallClick, goalClick, spawnClick;
  
  ArrayList<Bot> bots;
  
  Cell(float t_trueX, float t_trueY, int t_gridX, int t_gridY, float t_cellWidth, float t_cellHeight, boolean t_isWall, float[] t_spawnPos, float[] t_goalPos){
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
    
    scanned = false;
    
    wallClick = true;
    goalClick = false;
    spawnClick = false;
    
    botsSpawned = false;
    occupied = false;
    
    bots = new ArrayList<Bot>();
    
    if(isSpawn) {
      occupied = true;
      g = 0;
    }
  }
  
  float getH() {
    if(h == -1){
      h = abs(goalPos[0] - gridX) + abs(goalPos[1] - gridY);
      if((goalPos[0] != gridX && gridY > goalPos[1]) || (gridY < goalPos[1] && gridX != goalPos[0])) {
        h--;
      }
      if((abs(gridX - goalPos[0]) == 1 && gridY < goalPos[1] && goalPos[0] % 2 == 1)){
        h++;
      }
    }
    
    return h;
  }
  
  void changeColour(int v1, int v2, int v3) {
    fill(v1, v2, v3);
    stroke(v1, v2, v3);
  }
  
  void changeClick() {
      goalClick = false;
      spawnClick = false;
      wallClick = true;
  }
  
  void changeClick(boolean goal) {
    if(goal) {
      isGoal = false;
      goalClick = true;
      spawnClick = false;
      wallClick = false;
    } else {
      isSpawn = false;
      goalClick = false;
      spawnClick = true;
      wallClick = false;
    }
  }
  
  boolean isClicked() {
    return (mousePressed && (mouseX < trueX + cellWidth && mouseX > trueX - cellWidth) && (mouseY < trueY + cellHeight && mouseY > trueY - cellHeight));
  }
  
  void display() {
    if(isClicked()) {
      if(wallClick) {
        isWall = !isWall;
      } else if(goalClick) {
        isGoal = !isGoal;
      } else if(spawnClick) {
        isSpawn = !isSpawn;
      }
      delay(50);
    }
    
    if(isWall) {
      changeColour(0, 0, 0);
    } else if(isGoal) {
      changeColour(255, 0, 0);
    } else if(isSpawn) {
      changeColour(0, 0, 255);
    } else if (activated) {
      changeColour(0, 255, 0);
    } else if (occupied){
      changeColour(125, 125, 125);
    } else if(scanned) {
      changeColour(round(255 * g / 100) + 50, round(255 * h / 100) + 50, round(255 * f / 100) + 50);
    } else {
      changeColour(255, 255, 255);
    }
    
    for(Cell neighbour : neighbours) {
      if((neighbour.occupied || occupied) && botsSpawned) {
        occupied = false;
        
        for(Bot bot : bots) {
          if((bot.position.x < trueX + cellWidth && bot.position.x > trueX - cellWidth) && (bot.position.y < trueY + cellHeight && bot.position.y > trueY - cellHeight)) {
            if(!occupied) {
               occupied = true;
            }
            
            bot.travelled.add(this);
          }
        }
      }
    }
    
    hexagon(trueX, trueY, cellWidth * 4 / 3, cellHeight);
  }
  
  void hexagon(float x, float y, float w, float h) {
    beginShape();
    for (float i = 0; i < 6; i ++) {
      float a = PI / 180 * 60  * i;
      float sx = x + cos(a) * w;
      float sy = y + sin(a) * h;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}
