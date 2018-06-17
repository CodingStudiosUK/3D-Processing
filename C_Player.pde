class Player extends MasterEntity{

  final float MAX_SPEED = 10;//TODO:temp
  final float ACC = 1.6;
  final float INITIAL_SPEED = 0.5;
  Camera cam;

  Player(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2);
    vel = new PVector(0, 0, 0);
    dir = new PVector(0, 90);

    cam = new Camera(pos);
  }

  void move(){


    if (keysHold.get(keysName.get("up"))){
      pos.y -= MAX_SPEED*0.8;
    }
    if (keysHold.get(keysName.get("down"))){
      pos.y += MAX_SPEED*0.8;
    }

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
      vel.setMag(0);
      return;
    }
    float move = degrees(new PVector(cam.center.x, cam.center.z).heading())+180;
    if (z == -23){
      move += x;
    } else if (x==-23){
      move += z;
    } else {
      move += lerp(x,w&a?-z+180:z,0.5);
    }
    move = (360+move)%360;

    vel = PVector.mult(PVector.fromAngle(radians(move-180)), constrain(vel.mag(), INITIAL_SPEED, MAX_SPEED));
    vel.mult(ACC);
    vel.limit(MAX_SPEED);
    pos.add(vel.x, 0, vel.y);




  }

  void collideWith(int x, MasterObject mo){
    println(x);
    switch(x){
      case 5:
        break;
      case 4:
        pos.sub(GRAVITY);
      case 3:
        break;
      case 2:
        break;
      case 1:
        break;
      case 0:
        break;
      case -1:
        break;
    }
  }

  void run(){

    dir.x += (mouseX-width/2)*0.3;
    dir.y += (mouseY-height/2)*0.3;
    dir.y = constrain(dir.y, -89, 89);

    robot.mouseMove(displayWidth/2, displayHeight/2);

    cam.changeDir(dir.x, dir.y);

    move();
    pos.add(GRAVITY);
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

}

 class Camera{

   final float RADIUS = 1000; // How far away the camera center is.
   PVector eye, center;

   Camera(PVector pos){
     eye = pos;
     changeDir(0, 90);
   }

   void changeDir(float angRight, float angDown){
     float x = cos(radians(angRight))*RADIUS;
     float z = sin(radians(angRight))*RADIUS/*+RADIUS/2*/;
     float y = tan(radians(angDown))*RADIUS;
     center = new PVector(x, y, z);
     //center.setMag(RADIUS);
   }

   void display(){
    //camera(pos.x, pos.y, MAGIC+pos.z, pos.x+view.x, pos.y+view.y, pos.z+view.z, 0, 1, 0);
    camera(eye.x, eye.y, eye.z, eye.x+center.x, eye.y+center.y, eye.z+center.z, 0, 1, 0);
  }

}
