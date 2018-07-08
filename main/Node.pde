class Node extends SwingComponent {
  public float paramSize = 14.0f, paramGap = 6.0f;
  public NodeParams inputs, outputs;
  public boolean finishJob = false;

  public Node(String tmp_name, float tmp_x, float tmp_y) {
    super(tmp_x, tmp_y, 300.0f, 0.0f);
    name = tmp_name;
    inputs = new NodeParams((int)(0.0f - paramSize / 2.0f), 0, paramSize, paramGap, true, this);
    outputs = new NodeParams((int)(w - paramSize / 2.0f), 0, paramSize, paramGap, false, this);
    add(inputs); add(outputs);
  }
  public void job(){
    finishJob = true;
    for(Component c : inputs.childs){
      NodeParam p = ((NodeParam)c).output;
      if(p == null) continue;
      Node n = p.node;
      if(n == null) continue;
      if(!n.finishJob) n.job();
      ((NodeParam)c).job();
    }
  }
  public void reset(){
    finishJob = false;
    for(Component c : inputs.childs){
      NodeParam p = ((NodeParam)c).output;
      if(p == null) continue;
      Node n = p.node;
      if(n == null) continue;
      if(n.finishJob) n.reset();
      ((NodeParam)c).reset();
    }
  }
  @Override
  public void update(){
    min_w = inputs.w + outputs.w;
    min_h = max(inputs.h, outputs.h);
    super.update();
  }
  @Override
  public void draw(){
    inputs.x = 0.0f - paramSize / 2.0f; inputs.y = 0.0f;
    outputs.x = w - paramSize / 2.0f; outputs.y = 0.0f;
    super.draw();
  }
}

class NodeParams extends Component {
  public Node node = null;
  public boolean isInput;
  public float size, gap;
  
  public NodeParams(float tmp_x, float tmp_y, float tmp_size, float tmp_gap, boolean tmp_in, Node tmp_node) {
    super(tmp_x, tmp_y, tmp_size, tmp_gap);
    size = tmp_size;
    gap = tmp_gap;
    isInput = tmp_in;
    node = tmp_node;
    name = isInput?"Input":"Output";
  }
  @Override
  public Component add(Component child){
    if(!(child instanceof NodeParam)) return null;
    ((NodeParam)child).setup(0, (int)h ,size, isInput, node);
    h += size + gap;
    textSize(size * 1.5f);
    w = max(w, size + textWidth(child.name));
    return super.add(child);
  }
  @Override
  public boolean checkHit(float px, float py){
    for(Component c : childs){
      if(c.checkHit(px - x, py - y)) return true;
    }
    return false;
  }
}

class NodeParam extends Component {
  public Node node = null;
  public NodeParam output = null;
  public PVector vector;
  public boolean isInput;
  public float size;

  public NodeParam(String tmp_name) {
    super(0.0f, 0.0f, 0.0f, 0.0f);
    name = tmp_name;
  }
  public boolean canOutput(NodeParam p){
    return true;
  }
  public void job(){}
  public void reset(){}
  public void setup(int tmp_x, int tmp_y, float tmp_size, boolean tmp_in, Node tmp_node) {
    x = tmp_x;
    y = tmp_y;
    size = tmp_size;
    w = h = size;
    isInput = tmp_in;
    node = tmp_node;
  }
  @Override
  public void update() {
    if (output != null) {
      vector = output.getGrobalPos(0.0f, 0.0f);
      vector.sub(getGrobalPos(0.0f, 0.0f));
      vector.add(new PVector(output.isInput?0.0f:output.size, output.size / 2.0f));
    }
  }
  @Override
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
  @Override
  public void mouseEvent(String type, float tmp_x, float tmp_y, float start_x, float start_y) {
    if (isInput) {
      if (type.equals("UP") && output == null) vector = null;
      if (type.equals("DRAG")) {
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
      if (type.equals("UP")){
        vector = null;
        if (output != null){
          output.output = this;
          output = null;
        }
      }
      if (type.equals("DRAG")) {
        vector = new PVector(tmp_x, tmp_y);
        PVector grobalMouse = getGrobalPos(vector.x, vector.y);
        Component hit = getRootComponent().getHit(grobalMouse.x, grobalMouse.y);
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