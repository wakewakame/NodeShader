import processing.video.*;

RootComponent r;
NodeShaderManagement shaderManage;

Capture cam;

void setup(){
  size(640, 480, P2D);
  frameRate(60.0f);
  
  cam = new Capture(this, width, height, Capture.list()[1]);
  cam.start();
  
  r = new RootComponent();
  shaderManage = new NodeShaderManagement(r, this, 640, 480);
  r.add(new ImageNode(
    "camera",
      30 + r.childs.size() * 80,
      30 + r.childs.size() * 60,
      shaderManage.n, cam,
      true
  ));
}

void draw(){
  if (cam.available() == true) {
    cam.read();
  }
  background(240.0f, 240.0f, 240.0f, 255.0f);
  r.update();
  r.draw();
}

void mouseWheel(MouseEvent event){
  r.setZoom(event.getCount());
}