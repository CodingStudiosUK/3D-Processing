final int FIRE_RATE = 6;

class Gun{
  Displayable model;
  Vector pos;
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();

  int timeout = 0;
  boolean shoot = false;

  Gun(float x, float y, float z) {
    pos = new Vector(x, y, z);
    model = new Model("models/weapons/ak47/ak47.obj", "models/weapons/ak47/ak47.jpg", 0.2);
  }

  void run() {
    if (mousePressed && timeout==0) {
      shoot();
    }
    if (timeout > 0) --timeout;
    for (int i = 0; i < bullets.size(); ++i){
      bullets.get(i).run();
      if (!bullets.get(i).alive) {
        bullets.remove(i);
        --i;
      }
    }
  }

  void updatePos(Vector pos) {
    this.pos = pos.copy();//new Vector(pos.x+(PLAYER_WIDTH*0.6*sin(dir[0])), pos.y-10, pos.z+10/*+(PLAYER_DEPTH*0.6*cos(dir[0]))*/);
  }

  void display() {
    float dirX = player.cam.center.headingH();
    float dirY = player.cam.center.headingV();
    ((Model)model).display(pos, pos, dirX);
    //new Vector(100, -50, 0)
    for(int i = 0; i < bullets.size(); i++){
      bullets.get(i).display();
    }
  }

  String toString(){
    String ret = shoot?"1]":"0]";
    shoot = false;
    return ret;
  }

  void shoot() {
    bullets.add(new Bullet(player.cam.eye, player.cam.center));
    timeout = 120/FIRE_RATE;
    shoot = true;
  }
}

final int MAX_DIST = 1000; //units

class Bullet extends MasterEntity{
  int life = 0;

  Bullet(Vector _pos, Vector _vel){
    super(0, 0, 0, 0, 0, 0, 0);
    vel = _vel.copy().setMag(50);
    pos = _pos.copy();
    size = new Vector(4, 4, 4);
  }

  void run(){
    pos.add(vel);
    life += vel.mag();
    if(life >= MAX_DIST){
      alive = false;
    }
  }

  void display(){
    fill(255, 153, 40);
    noStroke();
    spheroid(pos, new Vector(PVector.mult(size.toPV(), 0.5)));
  }
}

void spheroid(Vector pos, Vector size) {
  pushMatrix();
  translate(pos.x, pos.y, pos.z);
  sphere(size.x);
  popMatrix();
}
