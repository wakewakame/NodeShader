class DefaultComponent extends Component{
  public DefaultComponent(int tmp_x, int tmp_y, int tmp_w, int tmp_h){
    super(tmp_x, tmp_y, tmp_w, tmp_h);
    name = "Empty Node";
  }
  public void setup(){
    add(new ResizeBox());
  }
  public void update(){
    if(parent != null){
      if(x < 0.0f) x = 0.0f;
      if(y < 0.0f) y = 0.0f;
      if(parent.w < x + w) x = parent.w - w;
      if(parent.h < y + h) y = parent.h - h;
    }
  }
  public void draw(){
    strokeWeight(2.0f);
    stroke(30.0f, 30.0f, 30.0f, 255.0f);
    fill(220.0f, 220.0f, 220.0f, 178.0f);
    rect(0, 0, w, h, 4.0f);
    fill(30.0f, 30.0f, 30.0f, 255.0f);
    textAlign(LEFT, BOTTOM);
    textSize(24.0f);
    text(name, 0, -2);
  }
}

class ResizeBox extends Component{
  public ResizeBox(){
    super(0, 0, 0, 0);
    name = "ResizeBox";
  }
  public void setup(){
    w = h = 20.0f;
    x = parent.w - w;
    y = parent.h - h;
  }
  public void update(){
    if(x < 0.0f) x = 0.0f;
    if(y < 0.0f) y = 0.0f;
    if(x + w < parent.min_w) x = parent.min_w - w;
    if(y < parent.min_h) y = parent.min_h;
    parent.w = x + w;
    parent.h = y + h;
  }
  public void draw(){
    noFill();
    strokeWeight(2.0f);
    stroke(30.0f, 30.0f, 30.0f, 255.0f);
    line(w, 0.0f, 0.0f, h);
  }
  public boolean checkHit(float px, float py){
    return
      super.checkHit(px, py) &&
      (py - y > w - (px - x));
  }
  public void mouseEvent(String type, int tmp_x, int tmp_y, int start_x, int start_y){
    if (mouseEventToChild(type, tmp_x, tmp_y, start_x, start_y)) return;
    switch(type) {
    case "HIT":
      break;
    case "DOWN":
      dragStartCompX = (int)x;
      dragStartCompY = (int)y;
      break;
    case "UP":
      
      break;
    case "CLICK":
      break;
    case "MOVE":
      break;
    case "DRAG":
      x = dragStartCompX + tmp_x - start_x;
      y = dragStartCompY + tmp_y - start_y;
      break;
    }
  }
}