import java.util.*;
PWindow win;

int XNumber = 11 + 2;  //Number of cells across the X-Axis
int YNumber = 11 + 2;  //Number of cells across the Y-Axis

float obstacleSaturation = 4;  //Inverse relationship to the number of generated obstacles

boolean startPath;  //Tells the A* algorithm whether or not to start

boolean spawnedBots;  //Records whether the bots have been spawned in for this generation

float botSize = 10;  //The displayed size of the bots, this has no actual affect beyond visuals
int botNumber = 1000;  //The number of bots spawned in each generation

Map map;  //Retrieving the map class
AStar bestPath;  //Retrieving the A* algorithm

NEAT bots = new NEAT(botSize, botNumber);  //Inputting the base values into the bot class

int nextConnectionNo = 1000;  //Values for NEAT thought flow

int[] time = new int[2];  //Grabbing a base array for time storage

boolean showBest = false;  //Whether to show only the best of each generation
boolean runBest = false;  //Whether to display the best of each generation in one run

boolean runThroughSpecies;  //Whether to show all generations
int upToSpecies;  //When running through the species, how far to go
Bot speciesChampion;  //Opening a variable for each best bot

boolean showBrain = false;  //Whether or not to show the brain
boolean showBestEachGen = false;  //To show the brains of the best generation
boolean showNothing = false;  //To show nothing at all

public void settings() {
  /* Ensures that the main settings are not called with each setup, and remains seperate from the base code */
  
  fullScreen();  //Fullscreen display size
  win = new PWindow(bots);  //Allowing for a second window to generate
}

void setup(){
  /* Runs for each new generation, ensuring the same random scenario */
  
  map = new Map(XNumber, YNumber, obstacleSaturation);  //Generating the map
  
  startPath = false;  //Resetting the pathfinding
  spawnedBots = false;  //Resetting the spawning
  
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
  } else if(pressed("c") || bots.generation < 500) {
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
    //Crash here
    bots.display();
  }
}
