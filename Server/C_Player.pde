class Player{
  PVector pos;
  PVector center;
  color col;
  String id;
  
  Player(String d){
    pos = new PVector();
    update(d);
    
    col = color(random(100, 255), random(100, 255), random(100, 255));
  }
  
  void update(String d){
    String[] sections = d.split("\\]\\[");
    pos = fromStr(sections[0]);
    center = fromStr(sections[1]);
  }
  
  PVector fromStr(String d){
    String[] vals = d.split(",");
    for(int i = 0; i < vals.length; i++){
      vals[i] = vals[i].replace("[", "").replace(" ", "").replace("]", "");
    }
    float[] p = new float[3];
    for(int i = 0; i < vals.length; i++){
      p[i] = Float.parseFloat(vals[i]);
    }
    return new PVector(p[0], p[1], p[2]);
  }
  
  String asString(){
    return String.valueOf(pos)+String.valueOf(center);
  }
  
  void display(){
    fill(col);
    ellipse(map(pos.x, -1000, 1000, 0, width), map(pos.z, -1000, 1000, 0, height), 20, 20);
  }
}
