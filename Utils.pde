public static class Utils {
  public static Vector2Int GetRatio(Vector2Float dimensions) {
    int larger = dimensions.x > dimensions.y ? 0 : 1;
    int smaller = larger == 0 ? 1 : 0;
    
    while (true) {
      if (dimensions.x % 1 == 0 && dimensions.y % 1 == 0) {
        break;
      } else {
        dimensions.x *= 10;
        dimensions.y *= 10;
      }
    }
    
    int[] ratio = { (int)dimensions.x, (int)dimensions.y };
    
    int i = 1;
    while (true) {
      if (((float)ratio[smaller] / (float)ratio[larger]) * (float)i % 1f == 0) {
        ratio[smaller] = i * ratio[smaller] / ratio[larger];
        ratio[larger] = i;
        break;
      } else {
        i++;
      }
    }
    
    Vector2Int toreturn = new Vector2Int(ratio[0], ratio[1]);
    return toreturn;
  }
  
  public static Vector2Int GetRatio(Vector2Int dimensions) {
    return GetRatio(new Vector2Float(dimensions.x, dimensions.y));
  }
  
  public static int BinaryToInteger(String binary) {
    char[] numbers = binary.toCharArray();
    int result = 0;
    for(int i=numbers.length - 1; i>=0; i--)
        if(numbers[i]=='1')
            result += Math.pow(2, (numbers.length-i - 1));
    return result;
  }
}

public static class Vector2Int {
  public int x, y;
  
  public Vector2Int(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public static final Vector2Int zero = new Vector2Int(0, 0);
  public static final Vector2Int one = new Vector2Int(1, 1);
  
  public String toString() {
    return "(" + x + ", " + y + ")";
  }
  
  public float Dist(Vector2Float other) {
    return sqrt((float)sq(other.x - this.x) + (float)sq(other.y - this.y));
  }
  
  public float Dist(Vector2Int other) {
    return Dist(new Vector2Float(other.x, other.y));
  }
  
  public Vector2Float ToVector2Float() {
    return new Vector2Float(x, y);
  }
  
  @Override
  public boolean equals(Object object) {
    boolean isEqual = false;
    
    if (object != null && object instanceof Vector2Int) {
      isEqual = (this.x == ((Vector2Int)object).x) && (this.y == ((Vector2Int)object).y);
    }
    
    return isEqual;
  }
}

public static class Vector2Float {
  public float x, y;
  
  public Vector2Float(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public static final Vector2Float zero = new Vector2Float(0, 0);
  public static final Vector2Float one = new Vector2Float(1, 1);
  
  public String toString() {
    return "(" + x + ", " + y + ")";
  }
  
  public float Dist(Vector2Float other) {
    return sqrt(sq(other.x - this.x) + sq(other.y - this.y));
  }
  
  public float Dist(Vector2Int other) {
    return Dist(new Vector2Float(other.x, other.y));
  }
  
  public boolean equals(Vector2Float other) {
    return this.x == other.x && this.y == other.y;
  }
}
