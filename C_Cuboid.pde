class Cuboid extends MasterGeometry{

  Cuboid(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2);
  }

  void run(){ //For moving platforms and such, done in physics thread
  }

  void display(){
    fill(col);
    stroke(stroke);
    cuboid(pos,size);
  }

}
