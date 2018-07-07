import java.io.File;
import java.io.FileFilter;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

class NodeShaderManagement{
  public Component root;
  public NativeGL n;
  public List<Component> node;
  public GLSLFilter glslFilter;
  
  public NodeShaderManagement(Component tmp_root, PApplet applet, int canvas_width, int canvas_height){
    root = tmp_root;
    n = new NativeGL(applet, canvas_width, canvas_height);
    File dir = new File(sketchPath(), "data");
    glslFilter = new GLSLFilter();
    List<File> glsl = Arrays.asList(dir.listFiles(glslFilter));
    node = new ArrayList<Component>();
    node.add(
      root.add(
        new OutNode(
          30 + node.size() * 80,
          30 + node.size() * 60,
          n
        )
      )
    );
    for(File f : glsl){
      node.add(
        root.add(
          new NodeShader(
            f,
            30 + node.size() * 80,
            30 + node.size() * 60,
            n
          )
        )
      );
    }
  }
  class GLSLFilter implements FileFilter{
    boolean accept(File pathname){
      return (
        pathname.isFile() &&
        pathname.canRead() &&
        pathname.getPath().endsWith(".glsl")
      );
    }
  }
}

class NodeShader extends Node{
  private File glslPath;
  private String glsl;
  public NativeGL n;
  public NativeShader shader;
  public PGraphics2D prev;
  
  public NodeShader(File tmp_glsl, float tmp_x, float tmp_y, NativeGL tmp_n){
    super(tmp_glsl.getName(), tmp_x, tmp_y);
    glslPath = tmp_glsl;
    n = tmp_n;
  }
  @Override
  public void job(){
    super.job();
    if(outputs == null) return;
    if(outputs.childs.size() != 1) return;
    NativeFrameBuffer fb = ((FrameBufferParam)outputs.childs.get(0)).frameBuffer;
    shader.beginDraw(fb.f);
    for(Component p : inputs.childs){
      if(!(p instanceof FrameBufferParam)) continue;
      if(((FrameBufferParam)p).frameBuffer == null) continue;
      shader.s.uniformTexture(p.name, ((FrameBufferParam)p).frameBuffer.f);
    }
    shader.s.uniform1f("time", (float)millis() / 1000.0f);
    shader.s.uniform2f("mouse", (float)mouseX / n.w, (float)mouseY / n.h);
    shader.s.uniform2f("resolution", n.w, n.h);
    shader.endDraw();
  }
  @Override
  public void setup(){
    super.setup();
    shader = new NativeShader(n, glslPath.getPath());
    loadShader();
    createFrameBufferParam();
    prev = (PGraphics2D)createGraphics((int)n.w, (int)n.h, P2D);
  }
  public void loadShader(){
    BufferedReader reader = createReader(glslPath.getPath());
    String str;
    while(true){
      try {
        str = reader.readLine();
        if(str == null) {
          break;
        }
      } catch (IOException e) {
        e.printStackTrace();
        break;
      }
      glsl += str + "\n";
    }
  }
  public void createFrameBufferParam(){
    Pattern p1 = Pattern.compile("(?<=uniform)\\s+[\\w]+\\s+[^;\\s]+\\s*(?=;)", Pattern.MULTILINE);
    Pattern p2 = Pattern.compile("\\w+\\s+\\w+");
    Matcher m1 = p1.matcher(glsl);
    Matcher m2;
    String[] match;
    while(m1.find()){
      m2 = p2.matcher(m1.group()); m2.find();
      match = m2.group().split("\\s+");
      if(match.length != 2) continue;
      if(match[0].equals("sampler2D")) inputs.add(new FrameBufferParam(match[1], n));
    }
    outputs.add(new FrameBufferParam("output", n));
  }
  @Override
  public void update(){
    super.update();
    min_h += w * n.h / n.w;
    n.copy.apply(((FrameBufferParam)outputs.childs.get(0)).frameBuffer.f, prev);
  }
  @Override
  public void draw(){
    super.draw();
    pushMatrix();
    scale(1.0, -1.0);
    noStroke();
    fill(255.0f, 255.0f, 255.0f, 255.0f);
    rect(0.0f, 0.0f - (h - 20.0f),w, w * n.h / n.w);
    image(prev, 0, 0 - ((int)h - 20),(int)w, (int)(w * n.h / n.w));
    popMatrix();
  }
}

class OutNode extends Node{
  NativeGL n;
  public OutNode(float tmp_x, float tmp_y, NativeGL tmp_n){
    super("output", tmp_x, tmp_y);
    n = tmp_n;
  }
  @Override
  public void setup(){
    super.setup();
    inputs.add(new FrameBufferParam("output", n));
  }
  @Override
  public void update(){
    super.update();
    reset();
    job();
  }
}

class FrameBufferParam extends NodeParam{
  public NativeGL n;
  public NativeFrameBuffer frameBuffer;
  
  public FrameBufferParam(String tmp_name, NativeGL tmp_n){
    super(tmp_name);
    n = tmp_n;
  }
  @Override
  public void setup(){
    if(!isInput) frameBuffer = new NativeFrameBuffer(n);
  }
  @Override
  public boolean canOutput(NodeParam p){
    return (p instanceof FrameBufferParam);
  }
  @Override
  public void job(){
    if((!isInput) || (output == null)) frameBuffer = null;
    else frameBuffer = ((FrameBufferParam)output).frameBuffer;
  }
  @Override
  public void reset(){
    frameBuffer = null;
  }
}