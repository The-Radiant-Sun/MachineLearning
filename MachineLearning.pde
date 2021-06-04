int XNumber = 40;
int YNumber = 40;
float obstacleSaturation = 4;

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
  if(!bestPath.pathFound){
    bestPath.pathfind();
  }
  
  for(int x = 0; x < XNumber; x++){
    for(int y = 0; y < YNumber; y++){
      Cell cell = map.cells[x][y];
      cell.display();
    }
  }
}
