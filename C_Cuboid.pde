class Cuboid extends MasterGeometry{

  Cuboid(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2);
  }

  void run(){ //For moving platforms and such, done in physics thread
  }

  void display(){
    fill(col);
    stroke(stroke);
    strokeWeight(1);
    cuboid(pos,size);
  }

}

class CuboidMoving extends Cuboid{

  PVector posCenter;
  int offset = int(random(0,360));
  float distX, distY, distZ;

  CuboidMoving(float x1, float y1, float z1, float x2, float y2, float z2, float _distX, float _distY, float _distZ){
    super(x1, y1, z1, x2, y2, z2);
    posCenter = pos.copy();
    distX = _distX;
    distY = _distY;
    distZ = _distZ;
  }
  void run(){
    PVector traction = PVector.sub(player.pos, pos);
    pos.x = posCenter.x+sin(radians(frameCount+offset))*distX;
    pos.y = posCenter.y+sin(radians(frameCount+offset))*distY;
    pos.z = posCenter.z+cos(radians(frameCount+offset))*distZ;
    if (isTouching(player) != TOUCH_NOT){
      player.pos = PVector.add(pos,traction);
    }
  }

}
