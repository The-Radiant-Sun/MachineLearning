class Cell{
  float trueX, trueY;
  int gridX, gridY;
  
  PVector[] points;
  
  float[] constant;
  float[] multiple;

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
    
    points = new PVector[6];
    
    constant = new float[6];
    multiple = new float[6];
    
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
    
    hexagon(trueX, trueY, cellWidth * 4 / 3, cellHeight);
    
    collisionValues();
  }
  
  void hexagon(float x, float y, float w, float h) {
    beginShape();
    for (int i = 0; i < 6; i ++) {
      float a = PI / 180 * 60  * i;
      points[i] = new PVector(x + cos(a) * w, y + sin(a) * h);
      vertex(points[i].x, points[i].y);
    }
    endShape(CLOSE);
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
      occupied = false;
      
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
  
  void collisionValues() {
    int i;
    int j = 5;

    for(i = 0; i < 6; i++) {
      if(points[j].y == points[i].x) {
        constant[i] = points[i].x;
        multiple[i] = 0;
      } else {
        constant[i] = points[i].x - (points[i].y * points[j].x) / (points[j].y - points[i].y) + (points[i].y * points[i].x) / (points[j].y - points[i].y);
        multiple[i] = (points[j].x - points[i].x) / (points[j].y - points[i].y);
      }
      j = i;
    }
  }
  
  boolean collisionWith(PVector point) {
    int j = 5;
    boolean  collide = false;
  
    for (int i = 0; i < 6; i++) {
      if ((points[i].y < point.y && points[j].y >= point.y || points[j].y < point.y && points[i].y >= point.y)) {
        collide ^= (point.y * multiple[i] + constant[i] < point.x); }
      j = i;
    }
    return collide;
  }
  
  void display() {
    if(collisionWith(new PVector(mouseX, mouseY)) && mousePressed) {
      if(wallClick) {
        isWall = !isWall;
      } else if(goalClick) {
        isGoal = !isGoal;
        occupied = !occupied;
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
          if(collisionWith(bot.position) && bot.alive) {
            if(!occupied) {
               occupied = true;
            }
            
            bot.travelled.add(this);
          }
        }
      }
    }
    
    beginShape();
    for(PVector point : points) {
      vertex(point.x, point.y);
    }
    endShape();
  }
}
