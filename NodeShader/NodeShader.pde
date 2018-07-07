RootComponent r;
Node n1, n2, n3;

void setup(){
  size(640, 480);
  frameRate(60.0f);
  
  r = new RootComponent();
  n1 = (Node)r.add(new Node("Node1", 100, 100));
  n2 = (Node)r.add(new Node("Node2", 400, 150));
  n3 = (Node)r.add(new Node("Node3", 200, 20));
  n1.inputs.add(new NodeParam("in1"));
  n1.inputs.add(new NodeParam("in2"));
  n1.inputs.add(new NodeParam("in3"));
  n1.outputs.add(new NodeParam("out1"));
  n1.outputs.add(new NodeParam("out2"));
  n2.inputs.add(new NodeParam("in1"));
  n2.outputs.add(new NodeParam("out1"));
  n2.outputs.add(new NodeParam("out2"));
  n3.inputs.add(new NodeParam("in1"));
  n3.inputs.add(new NodeParam("in2"));
  n3.outputs.add(new NodeParam("out1"));
  n3.outputs.add(new NodeParam("out2"));
}

void draw(){
  background(240.0f, 240.0f, 240.0f, 255.0f);
  r.update();
  r.draw();
}

void mouseWheel(MouseEvent event){
  r.setZoom(event.getCount());
}