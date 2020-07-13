class Dijkstra extends Pathfinder {
  
  private ArrayList<Vector2Int> openSet;
  private Vector2Int[][] cameFrom;
  private float[][] gScore;
  private float[][] fScore;
  private boolean[][] closed;
  
  public Dijkstra() {
    super("Dijkstra", "Searches every possible path. Does not need location of end point and generates 100% most optimal path but is extremely slow");
    
    
  }
  
  public void Begin() {
    openSet = new ArrayList<Vector2Int>();
    openSet.add(w.grid.start);
    cameFrom = new Vector2Int[w.grid.w][w.grid.h];
    gScore = new float[w.grid.w][w.grid.h];
    fScore = new float[w.grid.w][w.grid.h];
    closed = new boolean[w.grid.w][w.grid.h];
    
  }
  
  
  public void Step() {
    
    if (openSet.size() == 0) {
      completed = true;
      state = PathfinderState.NOSOLUTION;
      return;
    }
    
    Vector2Int current = GetLowestF();
    pathsToDraw.add(GetPath(current));
    currentPath = GetPath(current);
    
    if (current.equals(w.grid.end)) {
      completed = true;
      state = PathfinderState.FINISH;
      endPath = GetPath(current);
      return;
    }
    
    openSet.remove(current);
    closed[current.x][current.y] = true;
    
    ArrayList<Vector2Int> neighbors = GetNeighbors(current);
    for (Vector2Int neighbor : neighbors) {
      float tempG = gScore[current.x][current.y] + current.Dist(neighbor);
      
      boolean newPath = false;
      if (openSet.contains(neighbor)) {
        if (tempG < gScore[neighbor.x][neighbor.y]) {
          gScore[neighbor.x][neighbor.y] = tempG;
          newPath = true;
        }
      } else {
        gScore[neighbor.x][neighbor.y] = tempG;
        newPath = true;
        openSet.add(neighbor);
      }
      
      if (newPath) {
        fScore[neighbor.x][neighbor.y] = gScore[neighbor.x][neighbor.y];
        cameFrom[neighbor.x][neighbor.y] = current;
      }
    }
  }
  
  public void Draw() {
    for (int y = 0; y < w.grid.h; y++) {
      for (int x = 0; x < w.grid.w; x++) {
        if (closed[x][y]) w.grid.SetColor(new Vector2Int(x, y), 255, 200, 200);
      }
    }
    for (Vector2Int pos : openSet) {
      w.grid.SetColor(pos, 200, 255, 200);
    }
  }
  
  private float H(Vector2Int pos) {
    float a = max(abs(pos.x - w.grid.end.x), abs(pos.y - w.grid.end.y));
    float b = min(abs(pos.x - w.grid.end.x), abs(pos.y - w.grid.end.y));
    return (a - b) + sqrt(2) * b;
  }
  
  private ArrayList<Vector2Int> GetNeighbors(Vector2Int pos) {
    ArrayList<Vector2Int> neighbors = new ArrayList<Vector2Int>();
    for (int y = pos.y - 1; y <= pos.y + 1; y++) {
      for (int x = pos.x - 1; x <= pos.x + 1; x++) {
        if (!(x == pos.x && y == pos.y) && !(w.grid.IsObstacle(new Vector2Int(x, y))) && !(closed[x][y])) {
          neighbors.add(new Vector2Int(x, y));
        }
      }
    }
    return neighbors;
  }
  
  private Vector2Int GetLowestF() {
    int index = 0;
    for (int i = 0; i < openSet.size(); i++) {
      if (fScore[openSet.get(i).x][openSet.get(i).y] < fScore[openSet.get(index).x][openSet.get(index).y]) {
        index = i;
      } else if (fScore[openSet.get(i).x][openSet.get(i).y] == fScore[openSet.get(index).x][openSet.get(index).y]) {
        if (H(openSet.get(i)) < H(openSet.get(index))) {
          index = i;
        }
      }
    }
    return openSet.get(index);
  }
  
  private Path GetPath(Vector2Int pos) {
    Path path = new Path();
    path.Add(pos);
    while (true) {
      if (path.GetEnd().equals(w.grid.start)) break;
      path.Add(cameFrom[path.GetEnd().x][path.GetEnd().y]);
    }
    return path;
  }
  
  
}
