import java.util.*;

int XNumber = 25 + 2;
int YNumber = 25 + 2;

float obstacleSaturation = 4;

boolean startPath;

boolean spawnedBots;

float botSize = 10;
int botNumber = 1000;

Map map;
AStar bestPath;

NEAT bots = new NEAT(botSize, botNumber);

int nextConnectionNo = 1000;

int[] time = new int[2];

boolean showBest = false;
boolean runBest = false;

boolean runThroughSpecies;
int upToSpecies;
Bot speciesChampion;

boolean showBrain = false;
boolean showBestEachGen = false;
boolean showNothing = false;

void setup(){
  fullScreen();
  
  map = new Map(XNumber, YNumber, obstacleSaturation);
  
  startPath = false;
  spawnedBots = false;
  
  for(int x = 0; x < XNumber; x++){
    for(int y = 0; y < YNumber; y++){
      Cell cell = map.cells[x][y];
      cell.display();
    }
  }
  
  bestPath = new AStar(map.cells, map.goal, map.spawn);
  
  bots.updateValues(map.goal, map.spawn);
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
    bots.spawn();
    
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
      
      if(spawnedBots) {
        cell.bots = bots.bots;
      }
      
      cell.display();
      
      if(cell.isGoal) {
        map.goal = cell;
      } else if (cell.isSpawn) {
        map.spawn = cell;
      }
    }
  }
  
  if(spawnedBots && (bots.allDead || (minute() != time[0] && second() == time[1]))) {
    setup();
    bestPath = new AStar(map.cells, map.goal, map.spawn);
    startPath = true;
  }
  
  if(spawnedBots) {
    bots.display();
  }
}
