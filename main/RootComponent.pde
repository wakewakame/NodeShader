import java.util.List;

final class RootComponent extends Component{
  public boolean pmousePressed = false;
  private float dragStartMouseX, dragStartMouseY;
  public PVector original, mouse, pmouse;
  public float zoom = 1.0f, wheel = 0.0f;
  
  public RootComponent(){
    super(0, 0, width, height);
    name = "Root";
    original = new PVector(0.0f, 0.0f);
    mouse = new PVector(0.0f, 0.0f);
    pmouse = mouse.copy();
    setup();
  }
  @Override
  public void update(){
    pmouse = mouse.copy();
    mouse.x = (mouseX - original.x) / zoom;
    mouse.y = (mouseY - original.y) / zoom;
    sendMouseEvent();
    super.update_sub();
  }
  @Override
  public void draw(){
    pushMatrix();
    translate(original.x, original.y);
    scale(zoom);
    draw_sub();
    popMatrix();
  };
  void setZoom(float tmp_wheel){
    wheel -= tmp_wheel;
    float post_zoom = exp(wheel * 0.1f);
    original.x = mouseX + (original.x - mouseX) * (post_zoom / zoom);
    original.y = mouseY + (original.y - mouseY) * (post_zoom / zoom);
    zoom = post_zoom;
  }
  private void sendMouseEvent(){
    if ((!mousePressed) && dragFlag){
      childs.get(0).mouseEvent("UP", mouse.x - childs.get(0).x, mouse.y - childs.get(0).y, 0, 0);
      if(clickFlag) childs.get(0).mouseEvent("CLICK", mouse.x - childs.get(0).x, mouse.y - childs.get(0).y, 0, 0);
      dragFlag = false;
      clickFlag = false;
    }
    if(dragFlag){
      childs.get(0).mouseEvent("HIT", mouse.x - childs.get(0).x, mouse.y - childs.get(0).y, 0, 0);
      if(mouse.x != pmouse.x || mouse.y != pmouse.y){
        childs.get(0).mouseEvent("DRAG", mouse.x - childs.get(0).x, mouse.y - childs.get(0).y, dragStartMouseX - childs.get(0).x, dragStartMouseY - childs.get(0).y);
        clickFlag = false;
      }
    }
    else{
      for(Component c : childs){
        if (c.checkHit(mouse.x, mouse.y)){
          c.mouseEvent("HIT", mouse.x - c.x, mouse.y - c.y, 0, 0);
          if(mouse.x != pmouse.x || mouse.y != pmouse.y){
            c.mouseEvent("MOVE", mouse.x - c.x, mouse.y - c.y, 0, 0);
          }
          if(mousePressed && !pmousePressed){
            activeChilds(c);
            c.mouseEvent("DOWN", mouse.x - c.x, mouse.y - c.y, 0, 0);
            dragStartMouseX = mouse.x; dragStartMouseY = mouse.y;
            dragFlag = true;
            clickFlag = true;
          }
          break;
        }
        c.update();
      }
    }
    pmousePressed = mousePressed;
  }
}