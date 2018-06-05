void setup() {
  fullScreen(P3D);
}
void draw() {
  background(0);
  lightSpheroid(mouseX, mouseY, 200, 100);
  for (int i = 0; i < 9; ++i) {
    cuboid(100*i, 300, 0, 100, 100, 100);
  }
}

void lightSpheroid(float x, float y, float z, float r) {
  ambientLight(5, 40, 5, x, y, z);
  pointLight(20, 20, 255, x, y, z);
  spheroid(x,y,z,r);
}

void spheroid(float x, float y, float z, float r) {
  pushMatrix();
  translate(x, y, z);
  sphere(r);
  popMatrix();
}

void cuboid(float x, float y, float z, float w, float h, float d) {
  pushMatrix();
  translate(x, y, z);
  box(w, h, d);
  popMatrix();
}
