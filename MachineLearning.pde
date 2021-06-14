int XNumber = 25;
int YNumber = 25;
;
float obstacleSaturation = 4;

boolean startPath;

Map map;
AStar bestPath;

void setup(){
  fullScreen();
  map = new Map(XNumber, YNumber, obstacleSaturation);
  
  startPath = false;
  
  for(int x = 0; x < XNumber; x++){
    for(int y = 0; y < YNumber; y++){
      Cell cell = map.cells[x][y];
      cell.display();
    }
  }
  
  bestPath = new AStar(map.cells, map.goal, map.spawn);
}


void draw(){
  if(keyPressed) {
    if(key == 'p' || key == 'P') {
      startPath = true;
    }
    if(key == 'r' || key == 'R') {
      setup();
    }
    if(key == 'c' || key == 'C') {
      for(int x = 0; x < XNumber; x++) {
        for(int y = 0; y < YNumber; y++) {
          map.cells[x][y].isWall = false;
          map.walls[x][y] = false;
        }
      }
    }
  }
  
  if(!bestPath.pathFound && startPath && bestPath.possiblePath) {
    bestPath.pathfind();
  }
  
  for(int x = 0; x < XNumber; x++) {
    for(int y = 0; y < YNumber; y++) {
      Cell cell = map.cells[x][y];
      cell.display();
    }
  }
}
