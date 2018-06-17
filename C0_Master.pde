abstract class MasterObject{

  PVector pos, size;
  int collision = -1;

  MasterObject(float x1, float y1, float z1, float x2, float y2, float z2, int type){
    switch (type){
    case CORNERS:
      PVector[] t = posSizeFromCorners(x1, y1, z1, x2, y2, z2);
      pos = t[0].copy();
      size = t[1].copy();
      break;
    case CENTER:
    default:
      pos = new PVector(x1,y1,z1);
      size = new PVector(x2,y2,z2);
      break;
    }
  }

  @Override
  String toString(){
    return pos.toString();
  }

  abstract void run();
  abstract void display();

  abstract void collide(MasterObject mo);

  float getLeft(){
    return pos.x-size.x/2;
  }
  float getRight(){
    return pos.x+size.x/2;
  }

  float getFront(){
    return pos.z-size.z/2;
  }
  float getBack(){
    return pos.z+size.z/2;
  }

  float getTop(){
    return pos.y-size.y/2;
  }
  float getBottom(){
    return pos.y+size.y/2;
  }

  int isTouching(MasterObject mo){
    if(mo.getRight() > getLeft() && mo.getLeft() < getRight() //Other object is above
    && mo.getFront() < getBack() && mo.getBack() > getFront()
    && mo.getBottom() > getTop()){
      return 4;
    }
    return -1;
  }


}

abstract class MasterGeometry extends MasterObject{

  MasterGeometry(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2, CORNERS);
  }
  MasterGeometry(float x1, float y1, float z1, float x2, float y2, float z2, int type){
    super(x1, y1, z1, x2, y2, z2, type);
  }

  void collide(MasterObject mo){
    int x = isTouching(mo);
    if(mo instanceof Player){
      ((Player)mo).collideWith(x, this);
    }
  }

}

abstract class MasterEntity extends MasterObject{

  PVector vel, dir;

  MasterEntity(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2, CENTER);
  }
  MasterEntity(float x1, float y1, float z1, float x2, float y2, float z2, int type){
    super(x1, y1, z1, x2, y2, z2, type);
  }

  void collide(MasterObject mo){
    if (isTouching(mo) > -1){
      //--player.health; etc
    }
  }

}

// int isTouching(MasterObject mo){
//   int y = -1;
//   float d = 999999999;
//   if (mo == null || mo == this) {
//     return y;
//   }
//   //println(mo.getLeft()+" - "+getLeft());
//   int count = 0;
//   if(abs(mo.getRight()-getLeft()) < mo.size.x/2+size.x/2){
//     count++;
//     float f = abs(mo.getRight()-getLeft());
//     if(f < d){
//       d = f;
//       y = 0;
//     }
//   }
//   if(abs(mo.getLeft()-getRight()) < mo.size.x/2+size.x/2){
//     count++;
//     float f = abs(mo.getLeft()-getRight());
//     if(f < d){
//       d = f;
//       y = 1;
//     }
//   }
//   if(abs(mo.getBack()-getFront()) < mo.size.z/2+size.z/2){
//     count++;
//     float f = abs(mo.getBack()-getFront());
//     if(f < d){
//       d = f;
//       y = 2;
//     }
//   }
//   if(abs(mo.getFront()-getBack()) < mo.size.z/2+size.z/2){
//     count++;
//     float f = abs(mo.getFront()-getBack());
//     if(f < d){
//       d = f;
//       y = 3;
//     }
//   }
//   if(abs(mo.getBottom()-getTop()) < mo.size.y/2+size.y/2){
//     count++;
//     float f = abs(mo.getBottom()-getTop());
//     if(f < d){
//       d = f;
//       y = 4;
//     }
//   }
//   if(abs(mo.getTop()-getBottom()) < mo.size.y/2+size.y){
//     count++;
//     float f = abs(mo.getTop()-getBottom());
//     if(f < d){
//       d = f;
//       y = 5;
//     }
//   }
//   //println(y);
//   return count>4?y:-1;
//   /*y: (other object is on the yth edge)
//  -1 - Not touching
//   0 - Touching left
//   1 - Touching right
//   2 - Touching front
//   3 - Touching back
//   4 - Touching top
//   5 - Touching bottom
//   */
// }
