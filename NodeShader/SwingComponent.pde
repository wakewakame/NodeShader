class SwingComponent extends DefaultComponent {
  public PVector accelerator, velocity, target;

  public SwingComponent(int tmp_x, int tmp_y, int tmp_w, int tmp_h){
    super(tmp_x, tmp_y, tmp_w, tmp_h);
    name = "Swing Node";
  }
  public void setup() {
    accelerator = new PVector(0.0f, 0.0f);
    velocity = new PVector(0.0f, 0.0f);
    target = new PVector(x, y);
    add(new SwingResizeBox());
  }
  public void update() {
    velocity.mult(0.88f);
    accelerator = target.copy();
    accelerator.sub(new PVector(x, y));
    accelerator.mult(0.1f);
    velocity.add(accelerator);
    x += velocity.x;
    y += velocity.y;
  }
  public void mouseEvent(String type, int tmp_x, int tmp_y, int start_x, int start_y) {
    if (mouseEventToChild(type, tmp_x, tmp_y, start_x, start_y)) return;
    switch(type) {
    case "HIT":
      break;
    case "DOWN":
      dragStartCompX = (int)target.x;
      dragStartCompY = (int)target.y;
      break;
    case "UP":
    
      break;
    case "CLICK":
      break;
    case "MOVE":
      break;
    case "DRAG":
      target.x = dragStartCompX + tmp_x - start_x;
      target.y = dragStartCompY + tmp_y - start_y;
      break;
    }
  }
}

class SwingResizeBox extends ResizeBox {
  public PVector accelerator, velocity, target;

  public SwingResizeBox(){
    name = "SwingResizeBox";
  }
  public void setup() {
    w = h = 20.0f;
    x = parent.w - w;
    y = parent.h - h;
    accelerator = new PVector(0.0f, 0.0f);
    velocity = new PVector(0.0f, 0.0f);
    target = new PVector(x, y);
  }
  public void update() {
    velocity.mult(0.88f);
    accelerator = target.copy();
    accelerator.sub(new PVector(x, y));
    accelerator.mult(0.1f);
    velocity.add(accelerator);
    x += velocity.x;
    y += velocity.y;
    if(target.x < 0.0f) target.x = 0.0f;
    if(target.y < 0.0f) target.y = 0.0f;
    if(target.x + w < parent.min_w) target.x = parent.min_w - w;
    if(target.y < parent.min_h) target.y = parent.min_h;
    parent.w = x + w;
    parent.h = y + h;
  }
  public void mouseEvent(String type, int tmp_x, int tmp_y, int start_x, int start_y) {
    if (mouseEventToChild(type, tmp_x, tmp_y, start_x, start_y)) return;
    switch(type) {
    case "HIT":
      break;
    case "DOWN":
      dragStartCompX = (int)target.x;
      dragStartCompY = (int)target.y;
      break;
    case "UP":
      
      break;
    case "CLICK":
      break;
    case "MOVE":
      break;
    case "DRAG":
      target.x = dragStartCompX + tmp_x - start_x;
      target.y = dragStartCompY + tmp_y - start_y;
      break;
    }
  }
}