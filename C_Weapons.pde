abstract class Weapon {
  Displayable model;
  Vector pos;

  Weapon(float x, float y, float z) {
    pos = new Vector(x, y, z);
  }

  abstract void run();
  abstract void display();
}

abstract class RangedWeapon extends Weapon {
  final int MAX_AMMO;
  int ammo;

  RangedWeapon(float x, float y, float z, int am) {
    super(x, y, z);
    MAX_AMMO = am;
    ammo = MAX_AMMO;
  }

  abstract void shoot();
}

class AK47 extends RangedWeapon {

  AK47(float x, float y, float z) {
    super(x, y, z, 30);

    model = new Model("models/weapons/ak47/ak47.obj", "models/weapons/ak47/ak47.jpg");
  }

  void run() {
    if (mousePressed) {
      shoot();
    }
  }

  void updatePos(Vector pos) {
    //float[] dir = getAng(pos, player.cam.center);

    this.pos = pos.copy();//new Vector(pos.x+(PLAYER_WIDTH*0.6*sin(dir[0])), pos.y-10, pos.z+10/*+(PLAYER_DEPTH*0.6*cos(dir[0]))*/);
  }

  void display() {
    float dir = player.cam.center.headingH();
    model.display(pos, pos,/*0.2,*/ dir);
  }

  void shoot() {
    if (ammo > 0) {
      //println("*BANG*");
      --ammo;
    } else {
      //println("*click*");
    }
  }
}

abstract class MeleeWeapon extends Weapon {
  MeleeWeapon(float x, float y, float z) {
    super(x, y, z);
  }
}
