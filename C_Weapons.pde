final int FIRE_RATE = 5;

class Gun {
  Displayable model;
  Vector pos;
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();

  int timeout = 0;

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
      if (bullets.get(i).life >= MAX_DIST) {
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
    for(Bullet b : bullets){
      b.display();
    }
  }

  String toString(){
    String ret = "";
    for(Bullet b : bullets){
      ret += String.valueOf(b.pos);
    }
    return ret;
  }

  void shoot() {
    bullets.add(new Bullet(player.cam.eye, player.cam.center));
    timeout = 60/FIRE_RATE;
  }
}

final int MAX_DIST = 2048; //units

class Bullet{

  Vector pos, vel;
  int life = 0;

  Bullet(Vector _pos, Vector _vel){
    vel = _vel.copy().setMag(20);
    pos = _pos.copy();
  }

  void run(){
    pos.add(vel);
    life += vel.mag();
  }

  void display(){
    fill(255, 153, 40);
    if(life < 298){
      spheroid(pos, new Vector(1, 5, 5));
    }
  }
}

void spheroid(Vector pos, Vector size) {
  pushMatrix();
  translate(pos.x, pos.y, pos.z);
  sphere(size.x);
  popMatrix();
}
