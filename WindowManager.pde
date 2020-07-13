public class WindowManager {
  int count;
  Vector2Int ratio;
  float spacing;
  
  Vector2Int tableDimensions;
  Vector2Float windowDimensions;
  
  Window[] windows;
  Pathfinder[] pathfinders;
  
  public void CreateWindows(int count, Vector2Int ratio, float spacing, Pathfinder[] pathfinders) {
    this.count = count;
    this.ratio = ratio;
    this.spacing = spacing;
    
    windows = new Window[count];
    
    CalculateDimensions();
    
    for (int i = 0; i < count; i++) {
      Vector2Float pos = new Vector2Float((i % tableDimensions.x) * (windowDimensions.x + windowSpacing) + windowSpacing / 2, (i / tableDimensions.x) * (windowDimensions.y + windowSpacing) + windowSpacing / 2);
      windows[i] = new Window(i, pos, windowDimensions, pathfinders[i]);
    }
  }
  
  private void CalculateDimensions() {
    Vector2Int reducedScreenRatio = Utils.GetRatio(new Vector2Float(width / ratio.x, height / ratio.y));
    
    float x = sqrt((float)(count * reducedScreenRatio.x) / reducedScreenRatio.y);
    float y = count / x;
    
    int xint = ceil(x);
    int yint = ceil(y);
    
    if (floor(y) >= (float)count / ceil(x) && ceil(y) >= (float)count / floor(x)) {
      if (floor(x) * ceil(y) - count < ceil(x) * floor(y) - count) {
        xint = floor(x);
      } else {
        yint = floor(y);
      }
    } else if (floor(y) >= (float)count / ceil(x)) {
      yint = floor(y);
    } else if (ceil(y) >= (float)count / floor(x)) {
      xint = floor(x);
    }
    
    tableDimensions = new Vector2Int(xint, yint);
    
    if ((float)tableDimensions.y / tableDimensions.x < (float)reducedScreenRatio.y / reducedScreenRatio.x) {
      windowDimensions = new Vector2Float((width / tableDimensions.x) - spacing, (width / tableDimensions.x) * ((float)ratio.y / ratio.x) - spacing);
    } else {
      windowDimensions = new Vector2Float((height / tableDimensions.y) * ((float)ratio.x / ratio.y) - spacing, (height / tableDimensions.y) - spacing);
    }
    
  }
  
  public void Start() {
    for (Window window : windows) window.Start();
  }
  
  public void Update() {
    for (Window window : windows) window.Update();
  }
  
  public void SetGrid(Grid grid) {
    for (Window window : windows) window.grid = grid.Clone();
  }
}
