class SwingComponent extends DefaultComponent {
  public PVector accelerator, velocity, target;

  public SwingComponent(float tmp_x, float tmp_y, float tmp_w, float tmp_h){
    super(tmp_x, tmp_y, tmp_w, tmp_h);
    name = "Swing Node";
  }
  @Override
  public void setup() {
    accelerator = new PVector(0.0f, 0.0f);
    velocity = new PVector(0.0f, 0.0f);
    target = new PVector(x, y);
    add(new SwingResizeBox());
  }
  @Override
  public void update() {
    velocity.mult(0.88f);
    accelerator = target.copy();
    accelerator.sub(new PVector(x, y));
    accelerator.mult(0.1f);
    velocity.add(accelerator);
    x += velocity.x;
    y += velocity.y;
  }
  @Override
  public void mouseEvent(String type, float tmp_x, float tmp_y, float start_x, float start_y) {
    if (mouseEventToChild(type, tmp_x, tmp_y, start_x, start_y)) return;
    switch(type) {
    case "HIT":
      break;
    case "DOWN":
      dragStartCompX = target.x;
      dragStartCompY = target.y;
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
  @Override
  public void setup() {
    w = h = 20.0f;
    x = parent.w - w;
    y = parent.h - h;
    accelerator = new PVector(0.0f, 0.0f);
    velocity = new PVector(0.0f, 0.0f);
    target = new PVector(x, y);
  }
  @Override
  public void update() {
    velocity.mult(0.88f);
    accelerator = target.copy();
    accelerator.sub(new PVector(x, y));
    accelerator.mult(0.1f);
    velocity.add(accelerator);
    x += velocity.x;
    y += velocity.y;
    target.x = max(0.0f, target.x);
    target.y = max(0.0f, target.y);
    target.x = max(parent.min_w - w, target.x);
    target.y = max(parent.min_h, target.y);
    parent.w = x + w;
    parent.h = y + h;
  }
  @Override
  public void mouseEvent(String type, float tmp_x, float tmp_y, float start_x, float start_y) {
    if (mouseEventToChild(type, tmp_x, tmp_y, start_x, start_y)) return;
    switch(type) {
    case "HIT":
      break;
    case "DOWN":
      dragStartCompX = target.x;
      dragStartCompY = target.y;
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