class Grid {
  
  int w, h;
  
  boolean[][] obstacles;
  private int[][] rColor;
  private int[][] gColor;
  private int[][] bColor;
  
  Vector2Int start;
  Vector2Int end;
  
  public Grid(int w, int h, Long seed) {
    this.w = w;
    this.h = h;
    obstacles = new boolean[w][h];
    rColor = new int[w][h];
    gColor = new int[w][h];
    bColor = new int[w][h];
    noiseSeed(seed);
    GenerateGrid();
  }
  
  public Grid(int w, int h, boolean[][] obstacles, int[][] rColor, int[][] gColor, int[][] bColor, Vector2Int start, Vector2Int end) {
    this.w = w;
    this.h = h;
    this.obstacles = new boolean[w][h];
    this.rColor = new int[w][h];
    this.gColor = new int[w][h];
    this.bColor = new int[w][h];
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        this.obstacles[x][y] = obstacles[x][y];
        this.rColor[x][y] = rColor[x][y];
        this.gColor[x][y] = gColor[x][y];
        this.bColor[x][y] = bColor[x][y];
      }
    }
    this.start = start;
    this.end = end;
  }
  
  public Grid Clone() {
    return new Grid(w, h, obstacles, rColor, gColor, bColor, start, end);
  }
  
  public void DrawGrid(Vector2Float pos, Vector2Float wh) {
    Vector2Float squareDims = new Vector2Float(wh.x / w, wh.y / h);
    for(int y = 0; y < h; y++) {
      for(int x = 0; x < w; x++) {
        if ((x == start.x && y == start.y) || (x == end.x && y == end.y)) {
          rColor[x][y] = 0;
          gColor[x][y] = 255;
          bColor[x][y] = 80;
        }
        fill(rColor[x][y], gColor[x][y], bColor[x][y]);
        noStroke();
        rect(squareDims.x * x + pos.x, squareDims.y * y + pos.y, squareDims.x, squareDims.y);
        if (obstacles[x][y]) {
          Vector2Float squarePos = new Vector2Float(squareDims.x * x + pos.x + squareDims.x / 2, squareDims.y * y + pos.y + squareDims.y / 2);
          
          stroke(40);
          strokeWeight(squareDims.x < squareDims.y ? squareDims.x : squareDims.y);
          point(squarePos.x, squarePos.y);
          
        }
      }
    }
  }
  
  public boolean IsObstacle(int x, int y) {
    if (x < 0 || x >= w || y < 0 || y >= h) return true;
    return obstacles[x][y];
  }
  
  public boolean IsObstacle(Vector2Int p) {
    return IsObstacle(p.x, p.y);
  }
  
  public void SetObstacle(Vector2Int pos, boolean obstacle) {
    obstacles[pos.x][pos.y] = obstacle;
  }
  
  public void SetColor(Vector2Int pos, int r, int g, int b) {
    rColor[pos.x][pos.y] = r;
    gColor[pos.x][pos.y] = g;
    bColor[pos.x][pos.y] = b;
  }
  
  private void GenerateGrid() {
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        obstacles[x][y] = noise(x / 10.0, y / 10.0) < 0.4;
        SetColor(new Vector2Int(x, y), 255, 255, 255);
      }
    }
    
    float rotation = 0;
    while (start == null || end == null) {
      Vector2Int p2 = new Vector2Int(round(cos(rotation) * w / 2 + w / 2), round(sin(rotation) * h / 2 + h / 2));
      Vector2Int p1 = new Vector2Int(round(cos(rotation + PI) * w / 2 + w / 2), round(sin(rotation + PI) * h / 2 + h / 2));
      if (!IsObstacle(p1) && !IsObstacle(p2)) {
        start = p1;
        end = p2;
      } else {
        rotation += PI / 16;
      }
      
      if (rotation >= PI * 2) {
        start = new Vector2Int(0, 0);
        end = new Vector2Int(w - 1, h - 1);
      }
    }
  }
}
