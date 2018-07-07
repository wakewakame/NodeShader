class Component{
  public Component parent = null;
  public String name;
  public float x, y, w, h, min_w, min_h;
  public List<Component> childs;
  protected boolean dragFlag = false;
  protected boolean clickFlag = false;
  protected float dragStartCompX, dragStartCompY;
  
  public Component(float tmp_x, float tmp_y, float tmp_w, float tmp_h){
    x = tmp_x;
    y = tmp_y;
    w = tmp_w;
    h = tmp_h;
    min_w = 0.0f;
    min_h = 0.0f;
    name = "Empty";
    childs = new ArrayList<Component>();
  }
  public void setup(){}
  public void update(){}
  public final void update_sub(){
    w = max(min_w, w);
    h = max(min_h, h);
    for(int i = 0; i < childs.size(); i++){
      childs.get(i).update();
      childs.get(i).update_sub();
    }
  }
  public void draw(){};
  public final void draw_sub(){
    for(int i = childs.size() - 1; i >= 0; i--){
      pushMatrix();
      translate(childs.get(i).x, childs.get(i).y);
      childs.get(i).draw();
      childs.get(i).draw_sub();
      popMatrix();
    }
  }
  public Component add(Component child){
    childs.add(child);
    child.parent = this;
    child.setup();
    return child;
  }
  public void setMinSize(float tmp_min_w, float tmp_min_h){
    min_w = tmp_min_w;
    min_h = tmp_min_h;
  }
  public void mouseEvent(String type, float tmp_x, float tmp_y, float start_x, float start_y){
    if (mouseEventToChild(type, tmp_x, tmp_y, start_x, start_y)) return;
    switch(type){
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
  public boolean mouseEventToChild(String type, float tmp_x, float tmp_y, float start_x, float start_y){
    if (type.equals("UP") && (dragFlag || clickFlag)){
      childs.get(0).mouseEvent(type, tmp_x - childs.get(0).x, tmp_y - childs.get(0).y, start_x - childs.get(0).x, start_y - childs.get(0).y);
      dragFlag = false;
      clickFlag = false;
    }
    if(dragFlag) {
      childs.get(0).mouseEvent(type, tmp_x - childs.get(0).x, tmp_y - childs.get(0).y, start_x - childs.get(0).x, start_y - childs.get(0).y);
      return true;
    }
    else{
      for(Component c : childs){
        if (c.checkHit(tmp_x, tmp_y)){
          switch(type){
            case "DOWN":
              activeChilds(c);
              c.mouseEvent(type, tmp_x - c.x, tmp_y - c.y, start_x - c.x, start_y - c.y);
              dragFlag = true;
              clickFlag = true;
              break;
            case "UP":
            case "DRAG":
              break;
            default:
              c.mouseEvent(type, tmp_x - c.x, tmp_y - c.y, start_x - c.x, start_y - c.y);
              break;
          }
          return true;
        }
      }
    }
    return false;
  }
  public boolean checkHit(float px, float py){
    if (
      x < px &&
      y < py &&
      px < x + w &&
      py < y + h
    ) return true;
    for(Component c : childs){
      if(c.checkHit(px - x, py - y)) return true;
    }
    return false;
  }
  public final Component getHit(float px, float py){
    for(Component c : childs){
      if (c.checkHit(px, py)){
        return c.getHit(px - c.x, py - c.y);
      }
    }
    if (0.0f <= px && 0.0f <= py && px < w && py < h) return this;
    return null;
  }
  public final Component getRootComponent(){
    return (parent!=null)?parent.getRootComponent():this;
  }
  public final PVector getGrobalPos(float px, float py){
    if(parent == null) return new PVector(x + px, y + py);
    else return parent.getGrobalPos(x + px, y + py);
  }
  public final void activeChilds(Component c){
    int index = -1;
    for(int i = 0; i < childs.size(); i++){
      if(c == childs.get(i)) {
        index = i;
        break;
      }
    }
    if(index == -1) return;
    for(int i = 0; i < index; i++){
      swapChilds(index - i, index - i - 1);
    }
  }
  private final void swapChilds(int index1, int index2){
    Component tmp = childs.get(index1);
    childs.set(index1, childs.get(index2));
    childs.set(index2, tmp);
  }
}