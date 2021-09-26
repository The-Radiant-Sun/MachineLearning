import java.util.*;
PWindow win;

int xCellCount = 11 + 2;  //Number of cells across the X-Axis, add two for borders
int yCellCount = 11 + 2;  //Number of cells across the Y-Axis, add two for borders

float obstacleSaturation = -4;  //Inverse relationship to the number of generated obstacles

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
Bot speciesChampion;  //Opening a variable for each best bot in a species

boolean showBrain = false;  //Whether or not to show the brain
boolean showBestEachGen = false;  //To show the brains of the best generation
boolean showNothing = false;  //To show nothing at all

/* Ensures that the main settings are not called with each setup, and remains seperate from the base code */
public void settings() {
  fullScreen();  //Set display size to fullscreen
  win = new PWindow(bots);  //Allowing for a second window to generate
}

/* Runs for each new generation, ensuring random scenarios for each */
void setup(){
  map = new Map(xCellCount, yCellCount, obstacleSaturation);  //Generates the map
  
  startPath = false;  //Sets the pathfinding
  spawnedBots = false;  //Sets the spawning
  
  //For all positions in the map, spawn a cell
  for(int x = 0; x < xCellCount; x++){
    for(int y = 0; y < yCellCount; y++){
      Cell cell = map.cells[x][y];
      cell.display();
    }
  }
  
  bestPath = new AStar(map.cells, map.goal, map.spawn); //Feed the map values into the A* algorithm
  
  bots.updateValues(map.goal, map.spawn); //Updates the bots with the new map values
}

/* Shortening of a keypress recognition */
boolean pressed(String c) {
  return (keyPressed && (key == c.toLowerCase().charAt(0) || key == c.toUpperCase().charAt(0)));
}

/* Rendering and calling all single-frame calculations */
void draw(){
  background(0); //Setting the background colour as black
  
  if(pressed("p")) { //Start pathfinding if pressed 'p'
    bestPath = new AStar(map.cells, map.goal, map.spawn);
    startPath = true;
  } else if(pressed("r")) { //Reset if pressed r
    setup();
  } else if(pressed("c")) { //Clear the board of walls if pressed c or under 500 generations have run
    for(int x = 0; x < xCellCount; x++) {
      for(int y = 0; y < yCellCount; y++) {
        map.cells[x][y].isWall = false;
      }
    }
  } else if(pressed("g")) { //Change the goal position
    for(int x = 0; x < xCellCount; x++) {
      for(int y = 0; y < yCellCount; y++) {
        map.cells[x][y].changeClick(true);
        }
      }
  } else if(pressed("s")) { //Change the spawn position
    for(int x = 0; x < xCellCount; x++) {
      for(int y = 0; y < yCellCount; y++) {
        map.cells[x][y].changeClick(false);
        map.cells[x][y].occupied = false;
        }
      }
  } else if(pressed("w")) { //Change whether a cell is a wall or not
    for(int x = 0; x < xCellCount; x++) {
      for(int y = 0; y < yCellCount; y++) {
        map.cells[x][y].changeClick();
        }
      }
  }
  
  //If a path has not been found, the path should be started, and there is a possible path, pathfind through another frame
  if(!bestPath.pathFound && startPath && bestPath.possiblePath) {
    bestPath.pathfind();
  }
  
  //If there is no possible path, then reset and try pathfinding again
  if(!bestPath.possiblePath) {
    setup();
    startPath = true;
  }
  
  //If a path has been found and the bots have not been spawned
  if(bestPath.pathFound && !spawnedBots) {
    bots.spawn(); //Spawn all bots
    
    spawnedBots = true; //Status updates and changing records
    print("Spawned bots\n");
    
    //Inform all cells that the bots have been spawned
    for(int x = 0; x < xCellCount; x++) {
      for(int y = 0; y < yCellCount; y++) {
        map.cells[x][y].botsSpawned = true;
      }
    }
    
    time[0] = minute(); //Make a recording of the current time
    time[1] = second();
  }
  
  //For all cells in the map
  for(int x = 0; x < xCellCount; x++) {
    for(int y = 0; y < yCellCount; y++) {
      Cell cell = map.cells[x][y];
      
      //Update the cell with the current list of bots if they are spawned
      if(spawnedBots) {
        cell.bots = bots.bots;
      }
      
      cell.display(); //Render the cell state
      
      //Update map values
      if(cell.isGoal) {
        map.goal = cell;
      } else if (cell.isSpawn) {
        map.spawn = cell;
      }
    }
  }
  
  //If all the bots are dead or one minute has passed then reset and restart pathfinding
  if(spawnedBots && (bots.allDead || (minute() != time[0] && second() == time[1]))) {
    setup();
    bestPath = new AStar(map.cells, map.goal, map.spawn);
    startPath = true;
  }
  
  if(spawnedBots) {
    //Crash here <--
    bots.display(); //Render all bots
  }
}
