class PlayerOther extends Player { //Class for other players on the server

  //Model model;
  Cuboid cuboid = new Cuboid(color(0, 0, 200, 100));
  Vector center = new Vector(0, 0, 0);

  PlayerOther(String d1, String d2) {
    super(0, 0, 0, PLAYER_WIDTH, PLAYER_HEIGHT, PLAYER_DEPTH);
    updatePos(d1, d2);
    shape = new Model("models/ct/COUNTER-TERRORIST_GIGN.obj", "models/ct/GIGN_DMBASE2.png");
    //model = new Model("models/coco/Coco.obj","models/coco/Coco.png");
  }

  void updatePos(String d1, String d2) { //Takes a string from the server and gets the position
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
