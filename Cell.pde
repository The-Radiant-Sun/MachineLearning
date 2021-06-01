class Cell{
  float x, y;
  float w, h;
  boolean b;
  
  Cell(float t_x, float t_y, float t_w, float t_h, boolean t_b){
    x = t_x;
    y = t_y;
    w = t_w;
    h = t_h;
    b = t_b;
  }
  
  void display(){
    if(this.b){
      fill(0);
    } else {
      fill(255);
    }
    rect(this.x, this.y, this.x + this.w, this.y + this.h);
  }
}
