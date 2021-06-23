import java.util.*;

int XNumber = 25;
int YNumber = 25;

float obstacleSaturation = 4;

boolean startPath;

boolean spawnedBots;

float botSize = 10;
float botNumber = 0;

float maxSpeed = 10;

Map map;
AStar bestPath;
ArrayList<Bot> bots;

void setup(){
  fullScreen();
  map = new Map(XNumber, YNumber, obstacleSaturation);
  
  bots = new ArrayList<Bot>();
  
  startPath = false;
  spawnedBots = false;
  
  for(int x = 0; x < XNumber; x++){
    for(int y = 0; y < YNumber; y++){
      Cell cell = map.cells[x][y];
      cell.display();
    }
  }
  
  bestPath = new AStar(map.cells, map.goal, map.spawn);
  
}

boolean pressed(String c) {
  return (keyPressed && (key == c.toLowerCase().charAt(0) || key == c.toUpperCase().charAt(0)));
}

void draw(){
  if(pressed("p")) {
    bestPath = new AStar(map.cells, map.goal, map.spawn);
    startPath = true;
  } else if(pressed("r")) {
    setup();
  } else if(pressed("c")) {
    for(int x = 0; x < XNumber; x++) {
      for(int y = 0; y < YNumber; y++) {
        map.cells[x][y].isWall = false;
        map.walls[x][y] = false;
      }
    }
  } else if(pressed("g")) {
    for(int x = 0; x < XNumber; x++) {
      for(int y = 0; y < YNumber; y++) {
        map.cells[x][y].changeClick(true);
        }
      }
  } else if(pressed("s")) {
    for(int x = 0; x < XNumber; x++) {
      for(int y = 0; y < YNumber; y++) {
        map.cells[x][y].changeClick(false);
        }
      }
  } else if(pressed("w")) {
    for(int x = 0; x < XNumber; x++) {
      for(int y = 0; y < YNumber; y++) {
        map.cells[x][y].changeClick();
        }
      }
  }
  
  if(!bestPath.pathFound && startPath && bestPath.possiblePath) {
    bestPath.pathfind();
  }
  
  if(!bestPath.possiblePath) {
    setup();
    startPath = true;
  }
  
  if(bestPath.pathFound && !spawnedBots) {
    spawnedBots = !spawnedBots;
    print("Spawned bots\n");
    
    for(int i = 0; i < botNumber; i++) {
      bots.add(new Bot(map.goal, map.spawn, maxSpeed, botSize));
    }
  }
  
  for(int x = 0; x < XNumber; x++) {
    for(int y = 0; y < YNumber; y++) {
      Cell cell = map.cells[x][y];
      cell.bots = bots;
      cell.display();
      
      if(cell.isGoal) {
        map.goal = cell;
      } else if (cell.isSpawn) {
        map.spawn = cell;
      }
    }
  }
  
  for(Bot bot: bots){
    bot.Display();
  }
}
