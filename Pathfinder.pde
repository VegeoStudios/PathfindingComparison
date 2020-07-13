enum PathfinderState {
  PROGRESS, FINISH, NOSOLUTION
}

public abstract class Pathfinder {
  
  String name;
  String description;
  Window w;
  
  int steps;
  float distance;
  boolean completed;
  
  Path currentPath;
  
  protected ArrayList<Path> pathsToDraw;
  protected Path endPath;
  
  protected PathfinderState state;
  
  private boolean speedIncreased;
  
  Pathfinder(String name, String description) {
    this.name = name;
    this.description = description;
  }
  
  void SetWindow(Window w) {
    this.w = w;
  }
  
  void Start() {
    steps = 0;
    completed = false;
    distance = 0;
    state = PathfinderState.PROGRESS;
    speedIncreased = false;
    Begin();
    DrawStats();
  }
  
  void Update() {
    if (completed) {
      if (!speedIncreased) {
        speedIncreased = true;
        PathfindingComparison.speed *= 2;
        PathfindingComparison.completedCount++;
      }
      return;
    }
    pathsToDraw = new ArrayList<Path>();
    for (int i = 0; i < PathfindingComparison.speed; i++) {
      Step();
      steps++;
      if (completed) break;
    }
    distance = state == PathfinderState.FINISH ? endPath.GetDistance() : currentPath.GetDistance();
    Draw();
    w.DrawGrid();
    DrawPaths();
    DrawStats();
  }
  
  private void DrawStats() {
    noStroke();
    fill(0, 0, 0, 200);
    w.Rect(5, 5, w.dimensions.x - 10, 80);
    fill(255);
    textSize(20);
    textAlign(LEFT, TOP);
    text("Name", w.pos.x + 15, w.pos.y + 10);
    textAlign(RIGHT, TOP);
    text("Distance", w.pos.x + w.dimensions.x - 15, w.pos.y + 10);
    textAlign(CENTER, TOP);
    text("Steps", w.pos.x + w.dimensions.x / 2, w.pos.y + 10);
    
    textSize(35);
    textAlign(LEFT, BOTTOM);
    text(name, w.pos.x + 15, w.pos.y + 75);
    textAlign(RIGHT, BOTTOM);
    text(distance, w.pos.x + w.dimensions.x - 15, w.pos.y + 75);
    switch (state) {
      case PROGRESS:
        fill(255);
        break;
      case FINISH:
        fill(0, 255, 0);
        break;
      case NOSOLUTION:
        fill(255, 0, 0);
    }
    textAlign(CENTER, BOTTOM);
    text(steps, w.pos.x + w.dimensions.x / 2, w.pos.y + 75);
    
    fill(0, 0, 0, 200);
    w.Rect(5, (w.dimensions.y - 10) / 4 * 3 + 5, (w.dimensions.x - 10) / 2, (w.dimensions.y - 10) / 4);
    fill(255);
    textSize(21);
    textAlign(LEFT, TOP);
    text(description, w.pos.x + 10, w.pos.y + (w.dimensions.y - 10) / 4 * 3 + 10, (w.dimensions.x - 10) / 2 - 5, (w.dimensions.y - 10) / 4 - 5);
  }
  
  private void DrawPaths() {
    switch (state) {
      case PROGRESS:
        for (Path path : pathsToDraw) {
          strokeWeight(2);
          stroke(0, 80, 255, 255 / pathsToDraw.size());
          path.DrawPath(w.pos, w.dimensions, new Vector2Int(w.grid.w, w.grid.h));
        }
        break;
      case FINISH:
        strokeWeight(5);
        stroke(0, 255, 0);
        endPath.DrawPath(w.pos, w.dimensions, new Vector2Int(w.grid.w, w.grid.h));
        break;
      case NOSOLUTION:
    }
  }
  
  protected abstract void Begin();
  protected abstract void Step();
  protected abstract void Draw();
  
}

class Path {
  
  ArrayList<Vector2Int> points;
  
  public Path() {
    points = new ArrayList<Vector2Int>();
  }
  
  public void Add(Vector2Int point) {
    points.add(point);
  }
  
  public Vector2Int GetEnd() {
    return points.get(points.size() - 1);
  }
  
  public float GetDistance() {
    float dist = 0;
    for (int i = 0; i < points.size() - 1; i++) {
      dist += points.get(i).Dist(points.get(i + 1));
    }
    return dist;
  }
  
  public void DrawPath(Vector2Float boundsPos, Vector2Float boundsDims, Vector2Int dims) {
    for (int i = 0; i < points.size() - 1; i++) {
      Vector2Float squareDims = new Vector2Float(boundsDims.x / dims.x, boundsDims.y / dims.y);
      line(squareDims.x * points.get(i).x + boundsPos.x + squareDims.x / 2, squareDims.y * points.get(i).y + boundsPos.y + squareDims.y / 2, squareDims.x * points.get(i + 1).x + boundsPos.x + squareDims.x / 2, squareDims.y * points.get(i + 1).y + boundsPos.y + squareDims.y / 2);
    }
  }
  
  public void Reverse() {
    ArrayList<Vector2Int> reversed = new ArrayList<Vector2Int>();
    for (int i = points.size() - 1; i >= 0; i--) {
      reversed.add(points.get(i));
    }
    points = reversed;
  }
}
