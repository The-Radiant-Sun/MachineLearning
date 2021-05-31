class Cell{
  float x, y;
  float w, h;
  
  Cell(float t_x, float t_y, float t_w, float t_h){
    x = t_x;
    y = t_y;
    w = t_w;
    h = t_h;
  }
  
  boolean isOver(){
    if(mouseX >= this.x && mouseX <= this.x + this.w && mouseY >= this.y && mouseY <= this.y + this.h) {
      return true;
    } else {
      return false;
    }
  }
  
  void display(){
    if(this.isOver()){
      fill(0);
    } else {
      fill(255);
    }
    rect(this.x, this.y, this.x + this.w, this.y + this.h);
  }
}
