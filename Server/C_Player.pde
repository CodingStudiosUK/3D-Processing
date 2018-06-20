class Player{
  PVector pos;
  color col;
  String id;
  
  Player(String d){
    pos = new PVector();
    updatePos(d);
    
    col = color(random(100, 255), random(100, 255), random(100, 255));
  }
  
  void updatePos(String d){
    String[] vals = d.split(",");
    for(String v : vals){
      v = v.replace("[", "");
    }
    float[] p = new float[3];
    for(int i = 0; i < d.length(); i++){
      p[i] = Float.parseFloat(vals[i]);
    }
    pos.set(p[0], p[1], p[2]);
  }
  
  String asString(){
    return String.valueOf(pos);
  }
  
  void display(){
    fill(col);
    ellipse(map(pos.x, -600, 600, 0, width), map(pos.z, -600, 600, 0, height), 20, 20);
  }
}
