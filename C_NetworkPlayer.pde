class PlayerOther extends Player { //Class for other players on the server

  Cuboid cuboid = new Cuboid(color(255, 1), color(0, 0, 230, 100));
  Vector center = new Vector(0, 0, 0);
  boolean bullet = false;
  int id;

  PlayerOther(Vector pos, Vector center, boolean bullet, int id) {
    super(0, 0, 0, PLAYER_WIDTH, PLAYER_HEIGHT, PLAYER_DEPTH);
    update(pos, center, bullet);
    this.id = id;
    //shape = new Model("models/ct/COUNTER-TERRORIST_GIGN.obj", "models/ct/GIGN_DMBASE2.png");
    shape = new Model("models/player/coco/Coco.obj", "models/player/coco/Coco.png", 1.5);
  }
  /*Position, direction and bullets*/
  void update(Vector pos, Vector center, boolean bullet) {
    this.pos = pos;
    this.center = center;
    this.bullet = bullet;
  }

  void display() { //Draws the other players TODO: Give each player a colour and nametag
    noFill();
    stroke(0, 0, 200, 100);
    cuboid.display(pos, size, 0);
    Vector modelPos = new Vector(pos.x, getBottom(), pos.z);
    shape.display(modelPos, size, center.headingH()-90);
  }
}
