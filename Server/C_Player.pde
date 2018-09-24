class Player{
  PVector pos;
  PVector center;
  color col;
  String id;
  ArrayList<PVector> bullets = new ArrayList<PVector>();

  Player(String d){
    pos = new PVector();
    update(d);

    col = color(random(100, 255), random(100, 255), random(100, 255));
  }

  void update(String d){
    String[] sections = d.split("\\]\\[");
    pos = fromStr(sections[0]);
    center = fromStr(sections[1]);
    bullets = new ArrayList<PVector>();
    for(int i = 2; i < sections.length; i++){
      bullets.add(fromStr(sections[i]));
    }
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
    String b = "";
    for(int i = 0; i < bullets.size(); i++){
      b += bullets.get(i).toString();
    }
    return String.valueOf(pos)+String.valueOf(center)+b;
  }

  void display(){
    fill(col);
    noStroke();
    ellipse(map(pos.x, -1000, 1000, 0, width), map(pos.z, -1000, 1000, 0, height), 20, 20);
    stroke(255);
    for(int i = 0; i < bullets.size(); i++){
      PVector b = bullets.get(i);
      ellipse(map(b.x, -1000, 1000, 0, width), map(b.z, -1000, 1000, 0, height), 5, 5);
    }
  }
}
