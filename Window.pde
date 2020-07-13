public class Window {
  int id;
  Vector2Float pos, dimensions;
  Pathfinder pathfinder;
  Grid grid;

  public Window(int id, Vector2Float pos, Vector2Float dimensions, Pathfinder pathfinder) {
    this.id = id;
    this.pos = pos;
    this.dimensions = dimensions;
    this.pathfinder = pathfinder;
    
    this.pathfinder.SetWindow(this);
  }
  
  public void Start() {
    Background(255);
    this.DrawGrid();
    pathfinder.Start();
  }
  
  public void Update() {
    pathfinder.Update();
  }
  
  public void Line(float x1, float y1, float x2, float y2) { line(pos.x + x1, pos.y + y1, pos.x + x2, pos.y + y2); }
  public void Line(Vector2Float p1, Vector2Float p2) { line(p1.x, p1.y, p2.x, p2.y); }
  public void Point(float x, float y) { point(pos.x + x, pos.y + y); }
  public void Point(Vector2Float p) { point(p.x, p.y); }
  public void Square(float x, float y, float extent) { square(pos.x + x, pos.y + y, extent); }
  public void Square(Vector2Float p, float extent) { square(p.x, p.y, extent); }
  public void Rect(float x, float y, float w, float h) { rect(pos.x + x, pos.y + y, w, h); }
  public void Background(int rgb) { noStroke(); fill(rgb); rect(pos.x, pos.y, dimensions.x, dimensions.y); }
  public void Background(int rgb, float alpha) { noStroke(); fill(rgb, alpha); rect(pos.x, pos.y, dimensions.x, dimensions.y); }
  public void Background(float gray) { noStroke(); fill(gray); rect(pos.x, pos.y, dimensions.x, dimensions.y); }
  public void Background(float gray, float alpha) { noStroke(); fill(gray, alpha); rect(pos.x, pos.y, dimensions.x, dimensions.y); }
  public void Background(float v1, float v2, float v3) { noStroke(); fill(v1, v2, v3); rect(pos.x, pos.y, dimensions.x, dimensions.y); }
  public void Background(float v1, float v2, float v3, float alpha) { noStroke(); fill(v1, v2, v3, alpha); rect(pos.x, pos.y, dimensions.x, dimensions.y); }
  public void Background(PImage image) { image(image, pos.x, pos.y, dimensions.x, dimensions.y); }
  
  public void DrawGrid() { grid.DrawGrid(pos, dimensions); }
  
}
