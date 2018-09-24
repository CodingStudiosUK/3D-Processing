String readable(Vector p) {
  return round(p.x)+" . "+round(p.y)+" . "+round(p.z);
}

void startDrawHud() { //Sets of camera/lighting for HUD
  camera();
  noLights();
  hint(DISABLE_DEPTH_TEST); //Makes sure HUD elements are ALWAYS in front
  //frustum(-10, 0, 0, 10, 10, 10000);
}

void endDrawHud() { //Reenabled depth
  hint(ENABLE_DEPTH_TEST);
}

void config() { //Sets of parameters before the program starts running
  try { //Setup Java robot to keep mouse in the center of the screen
    robot = new Robot();
  }
  catch (AWTException e) {
    e.printStackTrace();
  }
  //noCursor(); //Hide the mouse cursor
}

void initNet() { //Configures UDP stuff (and more in the future)
  udp = new UDP(this, REC_PORT);
  udp.log(false);
  udp.listen(true);
}

void setLights() {
  background(200, 200, 255); //Lighting and graphics stuff
  //spotLight(255, 255, 255, -100, -800, -100, 1, 1, 1, 120, 500);
  //directionalLight(255, 255, 255, 1, 1, 2);
  ambientLight(255, 255, 255, 0, 0, 0);
}

Vector[] posSizeFromCorners(float x1, float y1, float z1, float x2, float y2, float z2) {
  Vector[] t = {new Vector(0, 0, 0), new Vector(0, 0, 0)};

  t[0].x = lerp(x1, x2, 0.5);
  t[0].y = lerp(y1, y2, 0.5);
  t[0].z = lerp(z1, z2, 0.5);

  t[1].x = abs(x2-x1);
  t[1].y = abs(y2-y1);
  t[1].z = abs(z2-z1);

  return t;
}

float[] getAng(Vector pos, Vector center) {
  Vector diff = pos.copy().sub(center);
  float[] angs = {degrees(atan2(diff.x, diff.z)+PI), degrees(asin(diff.y/CAM_RADIUS))};
  return angs;
}
