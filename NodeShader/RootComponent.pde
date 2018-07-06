import java.util.List;

final class RootComponent extends Component{
  public boolean pmousePressed = false;
  private int dragStartMouseX, dragStartMouseY;
  public RootComponent(){
    super(0, 0, width, height);
    name = "Root";
    setup();
  }
  public void update(){
    sendMouseEvent();
    super.update_sub();
  }
  public void draw(){draw_sub();};
  private void sendMouseEvent(){
    if ((!mousePressed) && dragFlag){
      childs.get(0).mouseEvent("UP", mouseX - (int)childs.get(0).x, mouseY - (int)childs.get(0).y, 0, 0);
      if(clickFlag) childs.get(0).mouseEvent("CLICK", mouseX - (int)childs.get(0).x, mouseY - (int)childs.get(0).y, 0, 0);
      dragFlag = false;
      clickFlag = false;
    }
    if(dragFlag){
      childs.get(0).mouseEvent("HIT", mouseX - (int)childs.get(0).x, mouseY - (int)childs.get(0).y, 0, 0);
      if(mouseX != pmouseX || mouseY != pmouseY){
        childs.get(0).mouseEvent("DRAG", mouseX - (int)childs.get(0).x, mouseY - (int)childs.get(0).y, dragStartMouseX - (int)childs.get(0).x, dragStartMouseY - (int)childs.get(0).y);
        clickFlag = false;
      }
    }
    else{
      for(Component c : childs){
        if (c.checkHit(mouseX, mouseY)){
          c.mouseEvent("HIT", mouseX - (int)c.x, mouseY - (int)c.y, 0, 0);
          if(mouseX != pmouseX || mouseY != pmouseY){
            c.mouseEvent("MOVE", mouseX - (int)c.x, mouseY - (int)c.y, 0, 0);
          }
          if(mousePressed && !pmousePressed){
            activeChilds(c);
            c.mouseEvent("DOWN", mouseX - (int)c.x, mouseY - (int)c.y, 0, 0);
            dragStartMouseX = mouseX; dragStartMouseY = mouseY;
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