RootComponent r;
NodeShaderManagement shaderManage;

void setup(){
  size(640, 480, P2D);
  frameRate(60.0f);
  
  r = new RootComponent();
  shaderManage = new NodeShaderManagement(r, this, 640, 480);
}

void draw(){
  background(240.0f, 240.0f, 240.0f, 255.0f);
  r.update();
  r.draw();
}

void mouseWheel(MouseEvent event){
  r.setZoom(event.getCount());
}