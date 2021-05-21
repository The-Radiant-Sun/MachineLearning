int XNumber = 25;
int YNumber = 25;
Map map;

void setup(){
  fullScreen();
  map = new Map(XNumber, YNumber);
}


void draw(){
  for(int x = 0; x < XNumber; x++){
    for(int y = 0; y < YNumber; y++){
      Cell cell = map.cells[x][y];
      cell.display();
    }
  }
}
