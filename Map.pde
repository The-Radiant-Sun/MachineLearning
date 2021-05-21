class Map{
  int cellXNumbers, cellYNumbers;
  Cell[][] cells;
  
  Map(int XNumber, int YNumber){
    cellXNumbers = XNumber;
    cellYNumbers = YNumber;
    
    cells = new Cell[cellXNumbers][cellYNumbers];
    
    for(int x = 0; x < cellXNumbers; x++){
      for(int y = 0; y < cellYNumbers; y++){
        cells[x][y] = new Cell(width/cellXNumbers * x, height/cellYNumbers * y, width/cellXNumbers, height/cellYNumbers);
      }
    }
  }
}
