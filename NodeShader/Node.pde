class Node extends SwingComponent {
  public float paramSize = 14.0f, paramGap = 6.0f;
  public NodeParams inputs, outputs;

  public Node(String tmp_name, int tmp_x, int tmp_y) {
    super(tmp_x, tmp_y, 0, 0);
    name = tmp_name;
    inputs = new NodeParams((int)(0.0f - paramSize / 2.0f), 0, paramSize, paramGap, true);
    outputs = new NodeParams((int)(w - paramSize / 2.0f), 0, paramSize, paramGap, false);
    add(inputs); add(outputs);
  }
  public void update(){
    min_w = 200.0f;
    min_h = max(inputs.h, outputs.h);
    super.update();
  }
  public void draw(){
    inputs.x = 0.0f - paramSize / 2.0f; inputs.y = 0.0f;
    outputs.x = w - paramSize / 2.0f; outputs.y = 0.0f;
    super.draw();
  }
}

class NodeParams extends Component {
  public boolean isInput;
  public float size, gap;
  
  public NodeParams(int tmp_x, int tmp_y, float tmp_size, float tmp_gap, boolean tmp_in) {
    super(tmp_x, tmp_y, (int)ceil(tmp_size), (int)ceil(tmp_gap));
    size = tmp_size;
    gap = tmp_gap;
    isInput = tmp_in;
    name = isInput?"Input":"Output";
  }
  public Component add(Component child){
    if(!(child instanceof NodeParam)) return null;
    ((NodeParam)child).setup(0, (int)h ,size, isInput);
    h += size + gap;
    return super.add(child);
  }
  public void mouseEvent(String type, int tmp_x, int tmp_y, int start_x, int start_y) {
    mouseEventToChild(type, tmp_x, tmp_y, start_x, start_y);
  }
}

class NodeParam extends Component {
  public NodeParam output = null;
  public PVector vector;
  public boolean isInput;
  public float size;

  public NodeParam(String tmp_name) {
    super(0, 0, 0, 0);
    name = tmp_name;
  }
  public boolean canOutput(NodeParam p){
    return true;
  }
  public void setup(int tmp_x, int tmp_y, float tmp_size, boolean tmp_in) {
    x = tmp_x;
    y = tmp_y;
    size = tmp_size;
    w = h = size;
    isInput = tmp_in;
  }
  public void update() {
    if (output != null) {
      vector = output.getGrobalPos(0.0f, 0.0f);
      vector.sub(getGrobalPos(0.0f, 0.0f));
      vector.add(new PVector(output.isInput?0.0f:output.size, output.size / 2.0f));
    }
  }
  public void draw() {
    strokeWeight(2.0f);
    stroke(30.0f, 30.0f, 30.0f, 255.0f);
    fill(240.0f, 240.0f, 240.0f, 255.0f);
    ellipse(size / 2.0f, size / 2.0f, size, size);
    fill(30.0f, 30.0f, 30.0f, 255.0f);
    textSize(size * 1.5f);
    textAlign(isInput?LEFT:RIGHT, CENTER);
    text(name, isInput?(size+3.0f):(-3.0f), size / 2.0f);
    strokeWeight(2.0f);
    stroke(30.0f, 30.0f, 30.0f, 255.0f);
    if(vector!=null) {
      if(isInput) bezier(0.0f, size / 2.0f, vector.x, vector.y, 0.5f);
      else bezier(vector.x, vector.y, size, size / 2.0f, 0.5f);
    }
  }
  private void bezier(float x1, float y1, float x2, float y2, float p) {
    int div = 32;
    p *= abs(x2 - x1);
    for (int i = 0; i < div; i++) {
      float f1 = (float)i / (float)div;
      float f2 = f1 + (1.0f / (float)div);
      line(
        pow(1.0f - f1, 3.0)*x1 + 3.0f*pow(1.0f - f1, 2.0)*pow(f1, 1.0)*(x1 - p) + 3.0f*pow(1.0f - f1, 1.0)*pow(f1, 2.0)*(x2 + p) + pow(f1, 3.0)*x2, 
        pow(1.0f - f1, 3.0)*y1 + 3.0f*pow(1.0f - f1, 2.0)*pow(f1, 1.0)*y1 + 3.0f*pow(1.0f - f1, 1.0)*pow(f1, 2.0)*y2 + pow(f1, 3.0)*y2, 
        pow(1.0f - f2, 3.0)*x1 + 3.0f*pow(1.0f - f2, 2.0)*pow(f2, 1.0)*(x1 - p) + 3.0f*pow(1.0f - f2, 1.0)*pow(f2, 2.0)*(x2 + p) + pow(f2, 3.0)*x2, 
        pow(1.0f - f2, 3.0)*y1 + 3.0f*pow(1.0f - f2, 2.0)*pow(f2, 1.0)*y1 + 3.0f*pow(1.0f - f2, 1.0)*pow(f2, 2.0)*y2 + pow(f2, 3.0)*y2
        );
    }
  }
  public void mouseEvent(String type, int tmp_x, int tmp_y, int start_x, int start_y) {
    if (isInput) {
      if (type == "UP" && output == null) vector = null;
      if (type == "DRAG") {
        vector = new PVector(tmp_x, tmp_y);
        PVector grobalMouse = getGrobalPos(vector.x, vector.y);
        Component hit = getRootComponent().getHit((int)grobalMouse.x, (int)grobalMouse.y);
        output = null;
        if(hit instanceof NodeParam) output = (NodeParam)hit; else return;
        if((output == this) || (output.isInput)){
          output = null;
          return;
        }
        output = canOutput(output)?output:null;
      }
    }
    else{
      if (type == "UP"){
        vector = null;
        if (output != null){
          output.output = this;
          output = null;
        }
      }
      if (type == "DRAG") {
        vector = new PVector(tmp_x, tmp_y);
        PVector grobalMouse = getGrobalPos(vector.x, vector.y);
        Component hit = getRootComponent().getHit((int)grobalMouse.x, (int)grobalMouse.y);
        output = null;
        if(hit instanceof NodeParam) output = (NodeParam)hit; else return;
        if((output == this) || (!output.isInput)){
          output = null;
          return;
        }
        output = output.canOutput(this)?output:null;
      }
    }
  }
}