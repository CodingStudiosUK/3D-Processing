void spheroid(PVector pos, PVector size) {
  pushMatrix();
  translate(pos.x, pos.y, pos.z);
  sphere(size.x);
  popMatrix();
}

void cuboid(PVector pos, PVector size) {
  pushMatrix();
  translate(pos.x, pos.y, pos.z); ////hmmmmmmmmmmm
  box(size.x, size.y, size.z);
  popMatrix();
}


PVector[] posSizeFromCorners(float x1, float y1, float z1, float x2, float y2, float z2){
  PVector[] t = {new PVector(0,0,0), new PVector(0,0,0)};

  t[0].x = lerp(x1, x2, 0.5);
  t[0].y = lerp(y1, y2, 0.5);
  t[0].z = lerp(z1, z2, 0.5);

  t[1].x = abs(x2-x1);
  t[1].y = abs(y2-y1);
  t[1].z = abs(z2-z1);

  return t;
}
