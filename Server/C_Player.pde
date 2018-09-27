class Player{
  PVector pos;
  PVector center;
  color col;
  String id;
  boolean bullet = false;

  Player(String d){
    pos = new PVector();
    update(d);

    col = color(random(100, 255), random(100, 255), random(100, 255));
  }

  void update(String d){
    String[] sections = d.split("\\]");
    pos = fromStr(sections[0]);
    center = fromStr(sections[1]);
    try{
      bullet = sections[2].equals("1")?true:false;
    }catch(IndexOutOfBoundsException e){

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
    return String.valueOf(pos)+String.valueOf(center)+(bullet?"1":"0")+"]";
  }

  void display(){
    fill(col);
    noStroke();
    ellipse(map(pos.x, -1000, 1000, 0, width), map(pos.z, -1000, 1000, 0, height), 20, 20);
    stroke(255);
  }
}
