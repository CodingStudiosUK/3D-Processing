class PlayerOther extends Player { //Class for other players on the server

  Cuboid cuboid = new Cuboid(color(0, 0, 200, 100));
  Vector center = new Vector(0, 0, 0);
  boolean bullet = false;

  PlayerOther(String d) {
    super(0, 0, 0, PLAYER_WIDTH, PLAYER_HEIGHT, PLAYER_DEPTH);
    updatePos(d);
    //shape = new Model("models/ct/COUNTER-TERRORIST_GIGN.obj", "models/ct/GIGN_DMBASE2.png");
    shape = new Model("models/player/coco/Coco.obj","models/player/coco/Coco.png");
  }
              /*Position, direction and bullets*/
  void updatePos(String d){
    String[] sections = d.split("\\]");
    //println(sections);
    pos = fromStr(sections[0]);
    center = fromStr(sections[1]);
    try{
      bullet = sections[2].equals("1")?true:false;
    }catch(IndexOutOfBoundsException e){
    }
  }

  Vector fromStr(String d){
    String[] vals = d.split(",");
    for(int i = 0; i < vals.length; i++){
      vals[i] = vals[i].replace("[", "").replace(" ", "").replace("]", "");
    }
    float[] p = new float[3];
    for(int i = 0; i < vals.length; i++){
      p[i] = Float.parseFloat(vals[i]);
    }
    return new Vector(p[0], p[1], p[2]);
  }

  void OLDupdatePos(String d1, String d2, String d3 ) { //Takes a string from the server and gets the position
    String[] vals = d1.split(",");
    for (int i = 0; i < vals.length; i++) {
      vals[i] = vals[i].replace("[", "").replace(" ", "").replace("]", "");
    }
    float[] p = new float[3];
    for (int i = 0; i < vals.length; i++) {
      p[i] = Float.parseFloat(vals[i]);
    }
    pos.set(p[0], p[1]-PLAYER_EYE_OFFSET, p[2]);

    vals = d2.split(",");
    for (int i = 0; i < vals.length; i++) {
      vals[i] = vals[i].replace("[", "").replace(" ", "").replace("]", "");
    }
    p = new float[3];
    for (int i = 0; i < vals.length; i++) {
      p[i] = Float.parseFloat(vals[i]);
    }
    center.set(p[0], p[1], p[2]);


  }

  void display() { //Draws the other players TODO: Give each player a colour and nametag
    //noFill();
    //stroke(0, 0, 200);
    cuboid.display(pos, size, 0);
    Vector modelPos = new Vector(pos.x, getBottom(), pos.z);
    shape.display(modelPos, size, center.headingH());
  }
}
