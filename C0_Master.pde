abstract class MasterObject{

  PVector pos, size;

  MasterObject(float x1, float y1, float z1, float x2, float y2, float z2){
    PVector[] t = posSizeFromCorners(x1, y1, z1, x2, y2, z2);
    pos = t[0].copy();
    size = t[1].copy();
  }

  @Override
  String toString(){
    return pos.toString();
  }

  abstract void run();
  abstract void display();

}

abstract class MasterGeometry extends MasterObject{
  MasterGeometry(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2);
  }
}

abstract class MasterEntity extends MasterObject{

  PVector vel;

  MasterEntity(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2);
  }

}
