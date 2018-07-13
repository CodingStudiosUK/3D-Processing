class Camera { //The camera class, makes it easy to control a camera using direction


  Vector center;
  Vector eye;

  Camera(Vector dir, Vector pos) {
    changeDir(dir.x, dir.y);
    eye = pos.copy();
  }

  void changeDir(float angRight, float angDown) { //Takes two angles and calculates a position for the camera
    float x = cos(radians(angRight));            //to look at
    float z = sin(radians(angRight));
    float y = tan(radians(angDown));
    center = new Vector(x, y, z);
    center.mult(CAM_RADIUS);
  }

  void moveTo(Vector pos) {
    eye = pos.copy();
    //eye.lerp(pos,0.5);//Smooths movement using lerp, fixes jagginess from physics thread
  }

  void display(Vector size) { //Sets the perspective and camera

    perspective(radians(60), (float)width/(float)height, 1, 10000);
    camera(eye.x, eye.y-size.y/2+PLAYER_EYE_OFFSET, eye.z, eye.x+center.x, eye.y+center.y, eye.z+center.z, 0, 1, 0);
  }
}
