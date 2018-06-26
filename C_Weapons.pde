abstract class Weapon{
  //https://gamedev.stackexchange.com/questions/159347
  Model model;
  PVector pos;

  Weapon(float x, float y, float z){
    pos = new PVector(x, y, z);
  }

  abstract void run();
  abstract void display();

}

abstract class RangedWeapon extends Weapon{
  final int MAX_AMMO;
  int ammo;

  RangedWeapon(float x, float y, float z, int am){
    super(x,y,z);
    MAX_AMMO = am;
    ammo = MAX_AMMO;
  }

  abstract void shoot();
}

class AK47 extends RangedWeapon{

  AK47(float x, float y, float z){
    super(x, y, z, 30);

    model = new Model("models/ct/COUNTER-TERRORIST_GIGN.obj","models/ct/GIGN_DMBASE2.png");
  }

  void run(){
    if(mousePressed){
      shoot();
    }
  }

  void display(){
    //model.display(pos, 6, );
  }

  void shoot(){
    if (ammo > 0){
      println("*BANG*");
      --ammo;
    } else {
      println("*click*");
    }
  }
}

abstract class MeleeWeapon extends Weapon{
  MeleeWeapon(float x, float y, float z){
    super(x,y,z);
  }
}
