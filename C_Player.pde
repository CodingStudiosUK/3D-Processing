final int PLAYER_VELOCITY_TERMINAL = 25;

class Player extends MasterEntity{

  final float JUMP_VEL = 10;

  final float MAX_SPEED = 8;//TODO:temp
  final float ACC = 0.002, DECC = 1;
  final float INITIAL_SPEED = 0.4;
  float jumpSpeed = 0;
  Camera cam;
  color col;

  HUD hud;

  Player(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2);
    vel = new PVector(0, 0, 0);
    dir = new PVector(0, -90);

    cam = new Camera();
    hud = new HUD();
    hud.addItem("fps", new HUDText(0, 0, 22, color(255)));
    hud.addItem("health", new HUDBar(65, height-55, 200, 50, color(200), color(0, 0, 255)));
    hud.addItem("healthIcon", new HUDIcon(10, height-55, 50, 50, loadImage("health.jpg")));
  }

  void move(){

    if (keysHold.get(keysName.get("up"))){
      ground = false;
      vel.y = -JUMP_VEL;
    }
    if (keysHold.get(keysName.get("down"))){
      vel.y = JUMP_VEL;
    }
    if(keysHold.get(keysName.get("jump")) && ground == true){
      vel.y -= JUMP_VEL;//jumpSpeed = JUMP_VEL;
      ground = false;

    }



    int moveDir = getMoveDirect();
    if (moveDir==-23){
      vel.set(0, vel.y, 0);
      return;
    }
    float move = degrees(new PVector(cam.center.x, cam.center.z).heading())+180+moveDir;
    move = (360+move)%360;

    PVector moveAccel = PVector.mult(PVector.fromAngle(radians(move-180)), constrain(new PVector(vel.x, vel.z).mag(), INITIAL_SPEED, MAX_SPEED));
    moveAccel.add(ACC, ACC);
    vel.add(moveAccel.x, 0, moveAccel.y);
    PVector velHor = new PVector(vel.x, vel.z);
    velHor.limit(MAX_SPEED);
    vel.x = velHor.x;
    vel.z = velHor.y;


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

  void physics(){
    if(!ground){
      vel.add(GRAVITY);
      vel.y = constrain(vel.y, -MAX_INT, PLAYER_VELOCITY_TERMINAL);
    }
    pos.add(vel);
  }

  void run(){



    if(keysPress.get(keysName.get("mouseLock"))){
      dir.x += (mouseX-width/2)*0.3;
      dir.y += (mouseY-height/2)*0.3;//*10/7;
      dir.y = constrain(dir.y, -89, 89);
      robot.mouseMove(displayWidth/2, displayHeight/2);
    }

    cam.changeDir(dir.x, dir.y);

    move();

    //send(String.valueOf(pos));
    //sendNEW(pos);
    hud.updateItem("fps", String.valueOf(frameRate));
    hud.updateItem("health", 0.6);
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
    hud.display(); //MUST be before camera update
    cam.display();

  }



 class Camera{

   final float RADIUS = 1000; // How far away the camera center is.
   PVector center;
   PVector eye;

   Camera(){
     changeDir(0, 0);
     eye = pos.copy();
   }

   void changeDir(float angRight, float angDown){
     float x = cos(radians(angRight));
     float z = sin(radians(angRight));
     float y = tan(radians(angDown));
     center = new PVector(x, y, z);
     center.mult(RADIUS);
   }

    void display(){
      eye.x = lerp(eye.x, pos.x, 0.5);
      eye.y = lerp(eye.y, pos.y, 0.5);
      eye.z = lerp(eye.z, pos.z, 0.5);
      //camera(pos.x, pos.y, MAGIC+pos.z, pos.x+view.x, pos.y+view.y, pos.z+view.z, 0, 1, 0);
      perspective(radians(60),(float)width/(float)height,10,10000);
      camera(eye.x, eye.y-size.y/2+PLAYER_EYE_OFFSET, eye.z, eye.x+center.x, eye.y+center.y, eye.z+center.z, 0, 1, 0);
    }

  }
}

class PlayerOther extends Player{

  PlayerOther(String d){
    super(0, 0, 0, PLAYER_WIDTH, PLAYER_HEIGHT, PLAYER_DEPTH);
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
    pos.set(p[0], p[1]-PLAYER_HEIGHT/2+PLAYER_EYE_OFFSET, p[2]);
  }

  void display(){
    fill(0,0,200);
    cuboid(pos,size);
  }

}
