class Player extends MasterEntity{

  final float JUMP_VEL = GRAVITY.y*2;

  final float MAX_SPEED = 8;//TODO:temp
  final float ACC = 0.002, DECC = 0.6;
  final float INITIAL_SPEED = 0.4;
  float jumpSpeed = 0;
  Camera cam;

  Player(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2);
    vel = new PVector(0, 0, 0);
    dir = new PVector(0, 90);

    cam = new Camera();
  }

  /*void moveRP(){
    // Jumping.
    if (keysHold.get(keysName.get("jump")) && ground) {
      vel.y = -JUMP_VEL;
      ground = false;
    }
    // Running, or decelerating.
    int moveDir = getMoveDirect();
    if (moveDir == -23){
      speed -= 0.25;
    } else {
      speed += 0.25;
    }
    speed = constrain(speed,0,10);

    float move = (degrees(new PVector(cam.center.x, cam.center.z).heading())+540+moveDir)%360;
    PVector moveVel = new PVector(speed,0).rotate(radians(move));

    vel.x = moveVel.x;
    vel.z = moveVel.y;

    vel.add(GRAVITY);
    vel.y = constrain(vel.y,-JUMP_VEL,JUMP_VEL);

    pos.add(vel);
  }*/

  void move(){

    if (keysHold.get(keysName.get("up"))){
      pos.y -= MAX_SPEED*0.4;
      pos.sub(GRAVITY);
    }
    if (keysHold.get(keysName.get("down"))){
      pos.y += MAX_SPEED*0.4;
      pos.add(GRAVITY);
    }
    if(keysHold.get(keysName.get("jump")) && ground == true){
      jumpSpeed = JUMP_VEL;
      ground = false;

    }
    pos.y -= jumpSpeed;
    jumpSpeed = constrain(jumpSpeed-DECC, 0, JUMP_VEL);
    println(jumpSpeed);


    int moveDir = getMoveDirect();
    if (moveDir==-23){
      vel.mult(0);
      return;
    }
    float move = degrees(new PVector(cam.center.x, cam.center.z).heading())+180+moveDir;
    move = (360+move)%360;

    PVector moveVel = PVector.mult(PVector.fromAngle(radians(move-180)), constrain(vel.mag(), INITIAL_SPEED, MAX_SPEED));
    moveVel.add(ACC, 0, ACC);
    vel.add(moveVel.x, 0, moveVel.y);
    vel.limit(MAX_SPEED);

    pos.add(vel);
    ground = false;
  }

  int getMoveDirect(){
    boolean w = keysHold.get(keysName.get("forward"));
    boolean s = keysHold.get(keysName.get("backward"));
    boolean a = keysHold.get(keysName.get("left"));
    boolean d = keysHold.get(keysName.get("right"));

    int x, z;
    if (w^s){
      if (w){
        x = 0;
      } else {
        x = 180;
      }
    }else{
      x = -23;
    }

    if (a^d){
      if (a){
        z = 270;
      } else {
        z = 90;
      }
    }else{
      z = -23;
    }

    if (x==-23&&z==-23){
      return -23;
    }

    if (z == -23){
      return x;
    } else if (x==-23){
      return z;
    } else {
      return int(lerp(x,w&a?180-z:z,0.5));
    }
  }

  void collideWith(int x, MasterObject mo){
    if(x > -1 && x != 4) println(x);
    switch(x){
      case TOUCH_BOTTOM:
        pos.y = mo.getBottom()+size.y/2;
        break;
      case TOUCH_TOP:
        pos.y = mo.getTop()-size.y/2;
        ground = true;
        break;
      case TOUCH_BACK:
        pos.z = mo.getBack()+size.z/2;
        break;
      case TOUCH_FRONT:
        pos.z = mo.getFront()-size.z/2;
        break;
      case TOUCH_RIGHT:
        pos.x = mo.getRight()+size.x/2;
        break;
      case TOUCH_LEFT:
        pos.x = mo.getLeft()-size.x/2;
        break;
      case TOUCH_NOT:
      default:
        break;
    }
  }

  void run(){



    if(keysPress.get(keysName.get("mouseLock"))){
      dir.x += (mouseX-width/2)*0.3;
      dir.y += (mouseY-height/2)*0.3*10/7;
      dir.y = constrain(dir.y, -89, 89);
      robot.mouseMove(displayWidth/2, displayHeight/2);
    }

    cam.changeDir(dir.x, dir.y);

    move();
    pos.add(GRAVITY);
    send(String.valueOf(pos));
    //sendNEW(pos);
  }

  // void hud(){
    // fill(255, 0, 0);
    // textSize(6);
    // float pOffX = vel.x;
    // float pOffY = vel.y;
    // pushMatrix();
    // translate(pos.x+view.x, pos.y+constrain(view.y, -RADIUS, RADIUS), pos.z+view.z);
    // float rotY = atan2(view.x, view.z)+PI;
    // rotateY(rotY);
    // rotateX(atan2(RADIUS*1.5-abs(view.z)*abs(sin(rotY)), -view.y)+PI+HALF_PI);
    // //rotateZ(atan2(-abs(cos(rotY))*RADIUS, view.y)+HALF_PI);
    // text(readable(pos), 0, 0);
    // fill(255);
    // popMatrix();
  //}

  void display(){
    cam.display();
  }



 class Camera{

   final float RADIUS = 1000; // How far away the camera center is.
   PVector center;

   Camera(){
     changeDir(0, 90);
   }

   void changeDir(float angRight, float angDown){
     float x = cos(radians(angRight));
     float z = sin(radians(angRight));
     float y = tan(radians(angDown));
     center = new PVector(x, y, z);
     center.mult(RADIUS);
   }

    void display(){
     //camera(pos.x, pos.y, MAGIC+pos.z, pos.x+view.x, pos.y+view.y, pos.z+view.z, 0, 1, 0);
      camera(pos.x, getTop()+10, pos.z, pos.x+center.x, pos.y+center.y, pos.z+center.z, 0, 1, 0);
    }

  }
}

class PlayerOther extends Player{

  PlayerOther(String d){
    super(0, 0, 0, 40, 140, 40);
    updatePos(d);
  }

  void updatePos(String d){
    String[] vals = d.split(",");
    for(int i = 0; i < vals.length; i++){
      vals[i] = vals[i].replace("[", "").replace(" ", "").replace("]", "");
    }
    float[] p = new float[3];
    for(int i = 0; i < vals.length; i++){
      p[i] = Float.parseFloat(vals[i]);
    }
    if(dist(pos.x, pos.y, pos.z, p[0], p[1], p[2]) > 50){
      pos.set(p[0], p[1], p[2]);
    }
  }

  void display(){
    fill(0,0,200);
    cuboid(pos,size);
  }

}
