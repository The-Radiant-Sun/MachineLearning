import java.util.*;

int XNumber;
int YNumber;

float obstacleSaturation;

boolean startPath;

boolean spawnedBots;

float botSize;
float botNumber;

float deadBots;

Map map;
AStar bestPath;
ArrayList<Bot> bots;

int[] time;

void setup(){
  fullScreen();
  
  XNumber = 25 + 2;
  YNumber = 25 + 2;
  
  obstacleSaturation = 4;
  
  map = new Map(XNumber, YNumber, obstacleSaturation);
  
  bots = new ArrayList<Bot>();

  botSize = 10;
  botNumber = 1000;
  
  startPath = false;
  spawnedBots = false;
  
  time = new int[2];
  
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
  background(0);

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
        map.cells[x][y].occupied = false;
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
    for(int i = 0; i < botNumber; i++) {
      bots.add(new Bot(map.goal, map.spawn, botSize, XNumber * YNumber));
    }
    
    spawnedBots = true;
    print("Spawned bots\n");
    
    for(int x = 0; x < XNumber; x++) {
      for(int y = 0; y < YNumber; y++) {
        map.cells[x][y].botsSpawned = true;
      }
    }
    
    time[0] = minute();
    time[1] = second();
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
  
  deadBots = 0;

  for(Bot bot: bots){
    if(bot.alive) {
      bot.Display();
    } else {
      deadBots++;
    }
  }
  
  if((deadBots == botNumber || (minute() != time[0] && second() == time[1])) && spawnedBots) {
    setup();
    bestPath = new AStar(map.cells, map.goal, map.spawn);
    startPath = true;
  }
}
