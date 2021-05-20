void setup(){
  fullScreen();
  
}


void draw(){
  for(int x = 0; x < cellXNumbers; x++){
    for(int y = 0; y < cellYNumbers; y++){
      Cell cell = cells[x][y];
      cell.display();
    }
  }
}
