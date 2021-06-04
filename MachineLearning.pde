int XNumber = 25;
int YNumber = 25;
float obstacleSaturation = 3;

Map map;
AStar bestPath;

void setup(){
  fullScreen();
  map = new Map(XNumber, YNumber, obstacleSaturation);
  
  for(int x = 0; x < XNumber; x++){
    for(int y = 0; y < YNumber; y++){
      Cell cell = map.cells[x][y];
      cell.display();
    }
  }
  
  bestPath = new AStar(map.cells, map.goal, map.spawn);
}


void draw(){
  bestPath.pathfind();
  
  for(int x = 0; x < XNumber; x++){
    for(int y = 0; y < YNumber; y++){
      Cell cell = map.cells[x][y];
      cell.display();
    }
  }
}
