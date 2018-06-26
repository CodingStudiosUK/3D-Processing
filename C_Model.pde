class Model{

  PShape obj, tri, quad;

  Model(String objName, String texName){

    obj = loadShape(objName);
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

  void display(PVector pos, float scale, float[] angs){
    fill(255);
    pushMatrix();
    translate(pos.x,pos.y,pos.z);
    rotateZ(PI);
    rotateY(angs[1]);
    scale(scale);
    //shape(obj); //IF using mtl file
    shape(tri);
    shape(quad);
    popMatrix();
  }

}
