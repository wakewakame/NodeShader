class DefaultComponent extends Component{
  public DefaultComponent(float tmp_x, float tmp_y, float tmp_w, float tmp_h){
    super(tmp_x, tmp_y, tmp_w, tmp_h);
    name = "Empty Node";
  }
  @Override
  public void setup(){
    add(new ResizeBox());
  }
  @Override
  public void update(){
    if(parent != null){
      x = max(0.0f, x);
      y = max(0.0f, y);
      x = min(x, parent.w - w);
      y = min(y, parent.h - h);
    }
  }
  @Override
  public void draw(){
    strokeWeight(2.0f);
    stroke(30.0f, 30.0f, 30.0f, 255.0f);
    fill(220.0f, 220.0f, 220.0f, 178.0f);
    rect(0.0f, 0.0f, w, h, 4.0f);
    fill(30.0f, 30.0f, 30.0f, 255.0f);
    textAlign(LEFT, BOTTOM);
    textSize(24.0f);
    text(name, 0, -2);
  }
}

class ResizeBox extends Component{
  public ResizeBox(){
    super(0.0f, 0.0f, 0.0f, 0.0f);
    name = "ResizeBox";
  }
  @Override
  public void setup(){
    w = h = 20.0f;
    x = parent.w - w;
    y = parent.h - h;
  }
  @Override
  public void update(){
    x = max(0.0f, x);
    y = max(0.0f, y);
    x = max(parent.min_w - w, x);
    y = max(parent.min_h, y);
    parent.w = x + w;
    parent.h = y + h;
  }
  @Override
  public void draw(){
    noFill();
    strokeWeight(2.0f);
    stroke(30.0f, 30.0f, 30.0f, 255.0f);
    line(w, 0.0f, 0.0f, h);
  }
  @Override
  public boolean checkHit(float px, float py){
    return
      super.checkHit(px, py) &&
      (py - y > w - (px - x));
  }
  @Override
  public void mouseEvent(String type, float tmp_x, float tmp_y, float start_x, float start_y){
    if (mouseEventToChild(type, tmp_x, tmp_y, start_x, start_y)) return;
    switch(type) {
    case "HIT":
      break;
    case "DOWN":
      dragStartCompX = x;
      dragStartCompY = y;
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