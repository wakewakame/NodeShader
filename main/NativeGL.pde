import com.jogamp.opengl.GL;
import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.dwgl.DwGLSLProgram;
import com.thomasdiewald.pixelflow.java.dwgl.DwGLTexture;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.Copy;

class NativeGL {
  private PApplet papplet;
  public DwPixelFlow context;
  public PGraphics2D canvas;

  public NativeGL(PApplet tmp_papplet, int resolution_width, int resolution_height) {
    papplet = tmp_papplet;
    context = new DwPixelFlow(papplet);
    canvas = (PGraphics2D) createGraphics(resolution_width, resolution_height, P2D);
  }
  public NativeGL(PApplet tmp_papplet) {
    papplet = tmp_papplet;
    context = new DwPixelFlow(papplet);
    canvas = (PGraphics2D) createGraphics(papplet.width, papplet.height, P2D);
  }
  public void draw(int a, int b, int c, int d) {
    papplet.image(canvas, a, b, c, d);
  }
  public void draw(int a, int b) {
    draw(a, b, canvas.width, canvas.height);
  }
  public void draw() {
    draw(0, 0, canvas.width, canvas.height);
  }
  public int getGLTextureHandle(PGraphics2D tex) {
    int[] tmp_framebuffer = new int[1];
    int[] req = new int[1];
    context.gl.glGetIntegerv(GL.GL_FRAMEBUFFER_BINDING, tmp_framebuffer, 0);
    context.getGLTextureHandle(tex, req);
    context.gl.glBindFramebuffer(GL.GL_FRAMEBUFFER, tmp_framebuffer[0]);
    return req[0];
  }
  public int getGLTextureHandle(PGraphics3D tex) {
    int[] tmp_framebuffer = new int[1];
    int[] req = new int[1];
    context.gl.glGetIntegerv(GL.GL_FRAMEBUFFER_BINDING, tmp_framebuffer, 0);
    context.getGLTextureHandle(tex, req);
    context.gl.glBindFramebuffer(GL.GL_FRAMEBUFFER, tmp_framebuffer[0]);
    return req[0];
  }
};

public class NativeShader {
  private NativeGL n;
  public DwGLSLProgram s;
  public NativeShader(NativeGL tmp_n, String frag_path) {
    n = tmp_n;
    s = n.context.createShader(frag_path);
  }
  public NativeShader(NativeGL tmp_n, String vert_path, String frag_path) {
    n = tmp_n;
    s = n.context.createShader(vert_path, frag_path);
  }
  public void beginDraw(DwGLTexture frame_buffer) {
    n.context.begin();
    n.context.beginDraw(frame_buffer);
    s.begin();
  }
  public void beginDraw(PGraphics2D graphics) {
    n.context.begin();
    n.context.beginDraw(graphics);
    s.begin();
  }
  public void beginDraw(){
    beginDraw(n.canvas);
  }
  public void endDraw(){
    s.drawFullScreenQuad();
    s.end();
    n.context.endDraw();
    n.context.end();
  }
};

public class NativeFrameBuffer {
  private NativeGL n;
  public DwGLTexture f;

  public NativeFrameBuffer(NativeGL tmp_n, int w, int h) {
    n = tmp_n;
    f = new DwGLTexture();
    f.resize(n.context, GL.GL_RGBA32F, w, h, GL.GL_RGBA, GL.GL_FLOAT, GL.GL_NEAREST, GL.GL_REPEAT, 4, 1);
  }
  public NativeFrameBuffer(NativeGL tmp_n) {
    n = tmp_n;
    f = new DwGLTexture();
    f.resize(n.context, GL.GL_RGBA32F, n.canvas.width, n.canvas.height, GL.GL_RGBA, GL.GL_FLOAT, GL.GL_NEAREST, GL.GL_REPEAT, 4, 1);
  }
};