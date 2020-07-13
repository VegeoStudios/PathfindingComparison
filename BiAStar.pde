class BiAStar extends Pathfinder {
  
  private ArrayList<Vector2Int> openSet1;
  private ArrayList<Vector2Int> openSet2;
  private Vector2Int[][] cameFrom1;
  private Vector2Int[][] cameFrom2;
  private float[][] gScore;
  private float[][] fScore;
  private boolean[][] closed;
  private boolean alternator;
  
  public BiAStar() {
    super("Bi-directional A*", "Uses A* pathfinding algorithm for both start-to-end and end-to-start. Semi-optimal in some cases but can determine if path is impossible faster than other algorithms.");
    
    
  }
  
  public void Begin() {
    openSet1 = new ArrayList<Vector2Int>();
    openSet1.add(w.grid.start);
    openSet2 = new ArrayList<Vector2Int>();
    openSet2.add(w.grid.end);
    cameFrom1 = new Vector2Int[w.grid.w][w.grid.h];
    cameFrom2 = new Vector2Int[w.grid.w][w.grid.h];
    gScore = new float[w.grid.w][w.grid.h];
    fScore = new float[w.grid.w][w.grid.h];
    closed = new boolean[w.grid.w][w.grid.h];
    alternator = true;
  }
  
  
  public void Step() {
    alternator = !alternator;
    if (openSet1.size() == 0 || openSet2.size() == 0) {
      completed = true;
      state = PathfinderState.NOSOLUTION;
      return;
    }
    
    ArrayList<Vector2Int> currentSet = alternator? openSet2 : openSet1;
    Vector2Int current = GetLowestF(currentSet);
    pathsToDraw.add(GetPath(current));
    currentPath = GetPath(current);
    
    if (alternator ? openSet1.contains(current) : openSet2.contains(current)) {
      completed = true;
      state = PathfinderState.FINISH;
      endPath = GetFullPath(current);
      return;
    }
    
    currentSet.remove(current);
    closed[current.x][current.y] = true;
    
    ArrayList<Vector2Int> neighbors = GetNeighbors(current);
    for (Vector2Int neighbor : neighbors) {
      float tempG = gScore[current.x][current.y] + current.Dist(neighbor);
      
      boolean newPath = false;
      if (currentSet.contains(neighbor)) {
        if (tempG < gScore[neighbor.x][neighbor.y]) {
          gScore[neighbor.x][neighbor.y] = tempG;
          newPath = true;
        }
      } else {
        gScore[neighbor.x][neighbor.y] = tempG;
        newPath = true;
        currentSet.add(neighbor);
      }
      
      if (newPath) {
        fScore[neighbor.x][neighbor.y] = gScore[neighbor.x][neighbor.y] + H(neighbor);
        Vector2Int[][] cameFrom = alternator ? cameFrom2 : cameFrom1;
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
    for (Vector2Int pos : openSet1) {
      w.grid.SetColor(pos, 200, 255, 200);
    }
    
    for (Vector2Int pos : openSet2) {
      w.grid.SetColor(pos, 200, 255, 200);
    }
  }
  
  private float H(Vector2Int pos) {
    Vector2Int dest = alternator ? w.grid.start : w.grid.end;
    float a = max(abs(pos.x - dest.x), abs(pos.y - dest.y));
    float b = min(abs(pos.x - dest.x), abs(pos.y - dest.y));
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
  
  private Vector2Int GetLowestF(ArrayList<Vector2Int> set) {
    int index = 0;
    for (int i = 0; i < set.size(); i++) {
      if (fScore[set.get(i).x][set.get(i).y] < fScore[set.get(index).x][set.get(index).y]) {
        index = i;
      } else if (fScore[set.get(i).x][set.get(i).y] == fScore[set.get(index).x][set.get(index).y]) {
        if (H(set.get(i)) < H(set.get(index))) {
          index = i;
        }
      }
    }
    return set.get(index);
  }
  
  private Path GetPath(Vector2Int pos) {
    Path path = new Path();
    path.Add(pos);
    Vector2Int[][] cameFrom = alternator ? cameFrom2 : cameFrom1;
    while (true) {
      if (path.GetEnd().equals(w.grid.end) || path.GetEnd().equals(w.grid.start)) break;
      path.Add(cameFrom[path.GetEnd().x][path.GetEnd().y]);
    }
    return path;
  }
  
  private Path GetFullPath(Vector2Int pos) {
    Path path = GetPath(pos);
    path.Reverse();
    Vector2Int[][] cameFrom = alternator ? cameFrom1 : cameFrom2;
    while (true) {
      if (path.GetEnd().equals(w.grid.start) || path.GetEnd().equals(w.grid.end)) break;
      path.Add(cameFrom[path.GetEnd().x][path.GetEnd().y]);
    }
    return path;
    
  }
}
