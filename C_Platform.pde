class Platform extends MasterGeometry {

  Platform(float x1, float y1, float z1, float x2, float y2, float z2, color col) {
    super(x1, y1, z1, x2, y2, z2);
    shape = new Cuboid(col);
  }

  void run() { //For moving platforms and such, done in physics thread
  }

  void display() {
    strokeWeight(1);
    shape.display(pos, size, 0);
  }
}

class PlatformMoving extends Platform {

  Vector posCenter;
  float distX, distY, distZ;

  PlatformMoving(float x1, float y1, float z1, float x2, float y2, float z2, float _distX, float _distY, float _distZ, color col) {
    super(x1, y1, z1, x2, y2, z2, col);
    posCenter = pos.copy();
    distX = _distX;
    distY = _distY;
    distZ = _distZ;
  }
  void run() {
    Vector traction = player.pos.copy().sub(pos);
    pos.x = posCenter.x+sin(radians(serverFrames))*distX;
    pos.y = posCenter.y+sin(radians(serverFrames))*distY;
    pos.z = posCenter.z+cos(radians(serverFrames))*distZ;
    if (isTouching(player) != TOUCH_NOT) {
      player.pos = pos.copy().add(traction);
    }
  }
}
