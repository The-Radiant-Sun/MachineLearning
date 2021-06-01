class Map{
  int cellXNumbers, cellYNumbers;
  float cellWidth, cellHeight;
  Cell[][] cells;
  
  Map(int XNumber, int YNumber){
    cellXNumbers = XNumber;
    cellYNumbers = YNumber;
    cellWidth = width/cellXNumbers;
    cellHeight = height/cellYNumbers;
    
    cells = new Cell[cellXNumbers][cellYNumbers];
    
    for(int x = 0; x < cellXNumbers; x++){
      for(int y = 0; y < cellYNumbers; y++){
        cells[x][y] = new Cell(width/cellXNumbers * x, height/cellYNumbers * y, cellWidth, cellHeight, false);
      }
    }
  }
}
