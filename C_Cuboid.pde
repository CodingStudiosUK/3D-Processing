class Cuboid extends MasterGeometry{

  Cuboid(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2);
  }

  void run(){
  }

  void display(){
    fill(255, 2);
    stroke(250);
    cuboid(pos,size);
  }

}
