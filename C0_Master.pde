final int TOUCH_NOT = -1,
  TOUCH_LEFT = 0,
  TOUCH_RIGHT = 1,
  TOUCH_FRONT = 2,
  TOUCH_BACK = 3,
  TOUCH_TOP = 4,
  TOUCH_BOTTOM = 5;
final color DEFAULT_COLOR = color(255, 2);
final color DEFAULT_STROKE = color(255);

abstract class MasterObject{

  PVector pos, size;
  int collision = -1;
  color col = DEFAULT_COLOR;
  color stroke = DEFAULT_STROKE;

  MasterObject(float x1, float y1, float z1, float x2, float y2, float z2, int type){
    switch (type){
    case CORNERS:
      PVector[] t = posSizeFromCorners(x1, y1, z1, x2, y2, z2);
      pos = t[0].copy();
      size = t[1].copy();
      break;
    case CENTER:
    default:
      pos = new PVector(x1,y1,z1);
      size = new PVector(x2,y2,z2);
      break;
    }
  }

  void setColor(color c, color s){
    col = c;
    stroke = s;
  }

  void setColor(color c){
    col = c;
  }

  @Override
  String toString(){
    return pos.toString();
  }

  abstract void run();
  abstract void display();

  abstract void collide(MasterObject mo);

  float getLeft(){
    return pos.x-size.x/2;
  }
  float getRight(){
    return pos.x+size.x/2;
  }

  float getFront(){
    return pos.z-size.z/2;
  }
  float getBack(){
    return pos.z+size.z/2;
  }

  float getTop(){
    return pos.y-size.y/2;
  }
  float getBottom(){
    return pos.y+size.y/2;
  }

  int isTouching(MasterObject mo){
    if(mo != null && mo != this
    && mo.getRight() > getLeft() && mo.getLeft() < getRight() //Other object is above
    && mo.getFront() < getBack() && mo.getBack() > getFront()
    && mo.getBottom() > getTop() && mo.getTop() < getBottom()){
      if(mo.pos.y < getTop()){
        return TOUCH_TOP;
      }else if(mo.pos.y > getBottom()){
        return TOUCH_BOTTOM;
      }else {
        float angO = atan2(mo.pos.z-pos.z, mo.pos.x-pos.x);
        float angTR = atan2(getFront()-pos.z, getRight()-pos.x);
        float angBR = atan2(getBack()-pos.z, getRight()-pos.x);
        float angTL = atan2(getFront()-pos.z, getLeft()-pos.x);
        float angBL = atan2(getBack()-pos.z, getLeft()-pos.x);
        if (angO >= angTL && angO <= angTR) return TOUCH_FRONT;
        else if (angO >= angBR && angO <= angBL) return TOUCH_BACK;
        else if (angO >= angTR && angO <= angBR) return TOUCH_RIGHT;
        else return TOUCH_LEFT;
      }
    }
    return TOUCH_NOT;
  }


}

abstract class MasterGeometry extends MasterObject{

  MasterGeometry(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2, CORNERS);
  }
  MasterGeometry(float x1, float y1, float z1, float x2, float y2, float z2, int type){
    super(x1, y1, z1, x2, y2, z2, type);
  }

  void collide(MasterObject mo){
    int x = isTouching(mo);
    //println(x);
    if(mo instanceof Player){
      ((Player)mo).collideWith(x, this);
    }
  }

}

abstract class MasterEntity extends MasterObject{

  PVector vel, dir;
  boolean ground = true;


  MasterEntity(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2, CENTER);
  }
  MasterEntity(float x1, float y1, float z1, float x2, float y2, float z2, int type){
    super(x1, y1, z1, x2, y2, z2, type);
  }

  void collide(MasterObject mo){
    if (isTouching(mo) > -1){
      //--player.health; etc
    }
  }

}
