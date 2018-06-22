final int PLAYER_VELOCITY_TERMINAL = 25;

class Player extends MasterEntity{

  final float JUMP_VEL = 12;

  final float MAX_SPEED = 15;//TODO:temp
  final float ACC = 2, DECC = 4;
  final float INITIAL_SPEED = 0.4;
  Camera cam;
  color col;

  HUD hud;

  //Stats
  float health = 100;

  Player(float x1, float y1, float z1, float x2, float y2, float z2){ //Size and position params
    super(x1, y1, z1, x2, y2, z2);
    vel = new PVector(0, 0, 0); //Init player specific PVectors
    dir = new PVector(0, -90);

    cam = new Camera(); //Create camera and HUD
    hud = new HUD();
    hud.addItem("fps", new HUDText(0, 0, 22, color(255))); //Adds HUD element, move to config file
    hud.addItem("health", new HUDBar(65, height-55, 300, 50, color(200), color(0, 0, 255)));
    hud.addItem("healthIcon", new HUDIcon(10, height-55, 50, 50, loadImage("health.jpg")));
  }

  void move(){ //Adds movement acceleration when the player presses a key

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

    int moveDir = getMoveDirect(); //Gets the direction to move the player
    if (moveDir != -23){ //-23 means no keys are being pressed
      float move = degrees(new PVector(cam.center.x, cam.center.z).heading())+180+moveDir;
      move = (360+move)%360;

      PVector moveAccel = PVector.mult(PVector.fromAngle(radians(move-180)), constrain(new PVector(vel.x, vel.z).mag(), INITIAL_SPEED, MAX_SPEED));
      moveAccel.add(ACC*cos(moveAccel.heading()), ACC*sin(moveAccel.heading()));
      vel.add(moveAccel.x, 0, moveAccel.y);
      PVector velHor = new PVector(vel.x, vel.z);
      velHor.limit(MAX_SPEED);
      vel.x = velHor.x;
      vel.z = velHor.y;
    }


    ground = false;
    return;
  }

  boolean isMoving(){ //If any key is pressed, used for decceleration
    boolean w = keysHold.get(keysName.get("forward"));
    boolean s = keysHold.get(keysName.get("backward"));
    boolean a = keysHold.get(keysName.get("left"));
    boolean d = keysHold.get(keysName.get("right"));
    return w|a|s|d;
  }

  int getMoveDirect(){ //Calculates the direction to move in, -23 means don't move
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

  void collideWith(int x, MasterObject mo){ //Actions to perform if the player collides with an object
    switch(x){
      case TOUCH_BOTTOM:
        if (vel.y <= 0){
          pos.y = mo.getBottom()+size.y/2;
        }
        break;
      case TOUCH_TOP:
        if(vel.y >= 0){
          pos.y = mo.getTop()-size.y/2;
          ground = true;
        }
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

  void physics(){ //The physics method called by the physics thread.
    if(!ground){ //If in the sky
      vel.add(GRAVITY);
      vel.y = constrain(vel.y, -MAX_INT, PLAYER_VELOCITY_TERMINAL); //Stop the player accelerating constantly
    }
    if(!isMoving()){ //If not moving, deccelerate TODO: implement this mathematically
      if(vel.x <= -DECC-0.1){ //Deccelerates x and z, if vel < 4 then set to 0
        vel.add(DECC, 0, 0);
      }else if(vel.x >= DECC+0.1){
        vel.sub(DECC, 0, 0);
      }else{
        vel.x = 0;
      }
      if(vel.z <= -DECC-0.1){
        vel.add(0, 0, DECC);
      }else if(vel.z >= DECC+0.1){
        vel.sub(0, 0, DECC);
      }else{
        vel.z = 0;
      }
    }
    pos.add(vel); //Add velocity to position
  }

  void run(){ //Called evey frame
    if(keysPress.get(keysName.get("mouseLock"))){ //If mouseLOOK is on
      dir.x += (mouseX-width/2)*0.3; //Makes the camera rotate, TODO: use constant for sensitivity
      dir.y += (mouseY-height/2)*0.3;//*10/7;
      dir.y = constrain(dir.y, -89, 89);
      robot.mouseMove(displayWidth/2, displayHeight/2);
    }

    cam.changeDir(dir.x, dir.y); //changes the camera direction

    move(); //All the movement stuff

    send(String.valueOf(pos));
    //sendNEW(pos);
    hud.updateItem("fps", String.valueOf(frameRate)); //Updates HUD elements TODO: find better way/move to function
    hud.updateItem("health", health/100);
  }

  void display(){ //Draws HUD and camera
    hud.display(); //MUST be before camera update
    cam.display();

  }



 class Camera{ //The camera class, makes it easy to control a camera using direction

   final float RADIUS = 1000; // How far away the camera center is.
   PVector center;
   PVector eye;

   Camera(){
     changeDir(0, 0);
     eye = pos.copy();
   }

   void changeDir(float angRight, float angDown){ //Takes two angles and calculates a position for the camera
     float x = cos(radians(angRight));            //to look at
     float z = sin(radians(angRight));
     float y = tan(radians(angDown));
     center = new PVector(x, y, z);
     center.mult(RADIUS);
   }

    void display(){ //Sets the perspective and camera
      eye.x = lerp(eye.x, pos.x, 0.5);//Smooths movement using lerp, fixes jagginess from physics thread
      eye.y = lerp(eye.y, pos.y, 0.5);
      eye.z = lerp(eye.z, pos.z, 0.5);
      //camera(pos.x, pos.y, MAGIC+pos.z, pos.x+view.x, pos.y+view.y, pos.z+view.z, 0, 1, 0);
      perspective(radians(60),(float)width/(float)height,1,10000);
      camera(eye.x, eye.y-size.y/2+PLAYER_EYE_OFFSET, eye.z, eye.x+center.x, eye.y+center.y, eye.z+center.z, 0, 1, 0);
    }

  }
}

class PlayerOther extends Player{ //Class for other players on the server

  PlayerOther(String d){
    super(0, 0, 0, PLAYER_WIDTH, PLAYER_HEIGHT, PLAYER_DEPTH);
    updatePos(d);
  }

  void updatePos(String d){ //Takes a string from the server and gets the position
    String[] vals = d.split(",");
    for(int i = 0; i < vals.length; i++){
      vals[i] = vals[i].replace("[", "").replace(" ", "").replace("]", "");
    }
    float[] p = new float[3];
    for(int i = 0; i < vals.length; i++){
      p[i] = Float.parseFloat(vals[i]);
    }
    pos.set(p[0], p[1]-PLAYER_EYE_OFFSET, p[2]);
  }

  void display(){ //Draws the other players TODO: Give each player a colour and nametag
    fill(0,0,200);
    cuboid(pos,size);
  }

}
