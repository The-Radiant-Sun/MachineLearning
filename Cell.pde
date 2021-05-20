class Cell{
  float x, y;
  float w, h;
  
  Cell(float t_x, float t_y, float t_w, float t_h){
    x = t_x;
    y = t_y;
    w = t_w;
    h = t_h;
  }
  
  void display(){
    rect(this.x, this.y, this.x + this.w, this.y + this.h);
  }
}
