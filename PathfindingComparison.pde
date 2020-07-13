Vector2Int windowRatio = new Vector2Int(1, 1);
int windowSpacing = 10;

Vector2Int gridSize = new Vector2Int(120, 120);

boolean started = false;;
Long offset = 0L;

int loops = 10;

static int baseSpeed = 10;
static int speed = baseSpeed;
static int waitTime = 20;
static int timer = waitTime;
static int completedCount;

WindowManager wm;

void setup() {
  background(150);
  size(2000, 2000);
  
  Pathfinder[] pathfinders = { new AStar(), new AStarGreedy(), new BiAStar(), new Dijkstra() };
  
  wm = new WindowManager();
  wm.CreateWindows(pathfinders.length, windowRatio, windowSpacing, pathfinders);
  
  Grid grid = new Grid(gridSize.x, gridSize.y, offset);
  wm.SetGrid(grid);
  wm.Start();
}

void draw() {
  if (completedCount == wm.count) {
    if (timer > 0) {
      timer--;
    } else {
      offset++;
      /*
      if (offset == loops) {
        noLoop();
        return;
      }
      */
      started = false;
      completedCount = 0;
      speed = baseSpeed;
      timer = waitTime;
      Grid grid = new Grid(gridSize.x, gridSize.y, offset);
      wm.SetGrid(grid);
      wm.Start();
    }
  } else if (!started) {
    if (timer > 0) {
      timer--;
    } else {
      started = true;
      timer = waitTime;
    }
  } else {
    wm.Update();
  }
  //saveFrame("sketch/#######.png");
}
