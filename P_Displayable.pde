class Model implements Displayable {

  PShape obj, tri, quad;
  Vector rot;
  float scale;

  Model(String objName, float rotX, float rotY, float rotZ, float scale) {
    println(rotX, rotY, rotZ, scale);
    obj = loadShape(objName);
  }

  Model(String objName, String texName) {
    obj = loadShape(objName);
    useTexture(texName);
  }

  Model(String objName, String texName, float s) {
    this(objName, texName);
    scale = s;
  }

  void useTexture(String texName) {

    PImage tex = loadImage(texName);
    noTint();

    tri  = createShape();
    tri.beginShape(TRIANGLES);
    tri.noStroke();
    tri.texture(tex);
    tri.textureMode(NORMAL);

    quad = createShape();
    quad.beginShape(QUADS);
    quad.noStroke();
    quad.texture(tex);
    quad.textureMode(NORMAL);

    for (int i=0; i < obj.getChildCount (); i++) {
      if (obj.getChild(i).getVertexCount() ==3) {
        for (int j=0; j<obj.getChild (i).getVertexCount(); j++) {
          PVector p = obj.getChild(i).getVertex(j);
          PVector n = obj.getChild(i).getNormal(j);
          float u = obj.getChild(i).getTextureU(j);
          float v = obj.getChild(i).getTextureV(j);
          tri.normal(n.x, n.y, n.z);
          tri.vertex(p.x, p.y, p.z, u, v);
        }
      } else if (obj.getChild(i).getVertexCount() ==4) {
        for (int j=0; j<obj.getChild (i).getVertexCount(); j++) {
          PVector p = obj.getChild(i).getVertex(j);
          PVector n = obj.getChild(i).getNormal(j);
          float u = obj.getChild(i).getTextureU(j);
          float v = obj.getChild(i).getTextureV(j);
          quad.normal(n.x, n.y, n.z);
          quad.vertex(p.x, p.y, p.z, u, v);
        }
      }
    }

    tri.endShape();
    quad.endShape();
  }

  void display(Vector pos, Vector size, float ang) {
    fill(255);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateZ(PI);
    rotateY(radians(ang));
    scale(scale);
    if (tri == null) {
      shape(obj); //IF using mtl file
    } else {
      shape(tri);
      shape(quad);
    }
    popMatrix();
  }
  void display2(Vector pos, float angX, float angY) {
    fill(255);
    pushMatrix();
    translate(pos.x, pos.y-20, pos.z);
    rotateZ(radians(90+angY)*abs(cos(radians(angX))));
    rotateX(radians(90+angY)*abs(sin(radians(angX))));
    rotateY(-radians(angX));
    scale(scale);
    if (tri == null) {
      shape(obj); //IF using mtl file
    } else {
      shape(tri);
      shape(quad);
    }
    popMatrix();
  }
}

class Cuboid implements Displayable {

  color col = DEFAULT_COLOR;
  color stroke = DEFAULT_STROKE;

  Cuboid(color _col, color _stroke) {
    col = _col;
    stroke = _stroke;
  }

  void display(Vector pos, Vector size, float ang) {
    // discard ang
    display2(pos, size);
  }
  void display2(Vector pos, Vector size) {

    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    box(size.x, size.y, size.z);
    popMatrix();
  }
}

interface Displayable {
  void display(Vector pos, Vector size, float ang);
}
