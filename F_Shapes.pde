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

void TexturedCube(PImage tex) {
  beginShape(QUADS);
  texture(tex);

  // Given one texture and six faces, we can easily set up the uv coordinates
  // such that four of the faces tile "perfectly" along either u or v, but the other
  // two faces cannot be so aligned.  This code tiles "along" u, "around" the X/Z faces
  // and fudges the Y faces - the Y faces are arbitrarily aligned such that a
  // rotation along the X axis will put the "top" of either texture at the "top"
  // of the screen, but is not otherwised aligned with the X/Z faces. (This
  // just affects what type of symmetry is required if you need seamless
  // tiling all the way around the cube)

  // +Z "front" face
  vertex(-1, -1,  1, 0, 0);
  vertex( 1, -1,  1, 1, 0);
  vertex( 1,  1,  1, 1, 1);
  vertex(-1,  1,  1, 0, 1);

  // -Z "back" face
  vertex( 1, -1, -1, 0, 0);
  vertex(-1, -1, -1, 1, 0);
  vertex(-1,  1, -1, 1, 1);
  vertex( 1,  1, -1, 0, 1);

  // +Y "bottom" face
  vertex(-1,  1,  1, 0, 0);
  vertex( 1,  1,  1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex(-1,  1, -1, 0, 1);

  // -Y "top" face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1, -1,  1, 1, 1);
  vertex(-1, -1,  1, 0, 1);

  // +X "right" face
  vertex( 1, -1,  1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex( 1,  1,  1, 0, 1);

  // -X "left" face
  vertex(-1, -1, -1, 0, 0);
  vertex(-1, -1,  1, 1, 0);
  vertex(-1,  1,  1, 1, 1);
  vertex(-1,  1, -1, 0, 1);

  endShape();
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
