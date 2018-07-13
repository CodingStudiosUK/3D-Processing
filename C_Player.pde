class Player extends MasterEntity {

  final float JUMP_VEL = 12;

  final float MAX_SPEED = 15;//TODO:temp
  final float ACC = 1.6;
  final float INITIAL_SPEED = 0.0;

  Camera cam;
  color col;

  HUD hud;

  //Stats
  float health = 100;

  AK47 ak47;

  Player(float x1, float y1, float z1, float x2, float y2, float z2) { //Size and position params
    super(x1, y1, z1, x2, y2, z2);
    vel = new Vector(0, 0, 0); //Init player specific Vectors
    dir = new Vector(0, 90);

    cam = new Camera(dir, pos); //Create camera and HUD
    hud = new HUD("hud");
    // hud.addItem("fps", new HUDText(0, 0, 22, color(255))); //Adds HUD element, move to config file
    // hud.addItem("health", new HUDBar(65, height-55, 300, 50, color(200), color(0, 0, 255)));
    // hud.addItem("healthIcon", new HUDIcon(10, height-55, 50, 50, loadImage("health.jpg")));
    // hud.addItem("XHair", new HUDXhair(width/2, height/2, 50, 50, color(10, 255, 10)));

    ak47 = new AK47(pos.x, pos.y, pos.z);
  }

  void move() { //Adds movement acceleration when the player presses a key
    cam.moveTo(pos.copy());
    if (keys.getKey("up")) {
      ground = false;
      vel.y = -JUMP_VEL;
    }
    if (keys.getKey("down")) {
      vel.y = JUMP_VEL;
    }
    if (keys.getKey("jump") && ground == true) {
      vel.y -= JUMP_VEL;//jumpSpeed = JUMP_VEL;
      ground = false;
    }

    int moveDir = getMoveDirect(); //Gets the direction to move the player
    if (moveDir != -23) { //-23 means no keys are being pressed
      float move = cam.center.headingH()+moveDir;
      move = (360+move)%360;

      Vector moveAccel = new Vector(move).setMag(ACC);

      vel.add(moveAccel.x, 0, moveAccel.y);
      Vector velHor = new Vector(vel.x, vel.z);
      velHor.limit(MAX_SPEED);
      vel.x = velHor.x;
      vel.z = velHor.y;
    }


    ground = false;
    return;
  }

  boolean isMoving() { //If any key is pressed, used for decceleration
    boolean w = keys.getKey("forward");
    boolean s = keys.getKey("backward");
    boolean a = keys.getKey("left");
    boolean d = keys.getKey("right");
    return (w^s)|(a^d);
  }

  int getMoveDirect() { //Calculates the direction to move in, -23 means don't move
    boolean w = keys.getKey("forward");
    boolean s = keys.getKey("backward");
    boolean a = keys.getKey("left");
    boolean d = keys.getKey("right");

    int x, z;
    if (w^s) {
      if (w) {
        x = 0;
      } else {
        x = 180;
      }
    } else {
      x = -23;
    }

    if (a^d) {
      if (a) {
        z = 270;
      } else {
        z = 90;
      }
    } else {
      z = -23;
    }

    if (x==-23&&z==-23) {
      return -23;
    }

    if (z == -23) {
      return x;
    } else if (x==-23) {
      return z;
    } else {
      return int(lerp(x, w&a?180-z:z, 0.5));
    }
  }

  void collideWith(int x, MasterObject mo) { //Actions to perform if the player collides with an object
    switch(x) {
    case TOUCH_BOTTOM:
      if (vel.y <= 0) {
        pos.y = mo.getBottom()+size.y/2;
      }
      break;
    case TOUCH_TOP:
      if (vel.y >= 0) {
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

  void physics() { //The physics method called by the physics thread.
    if (!ground) { //If in the sky
      vel.add(GRAVITY);
      vel.y = constrain(vel.y, -MAX_INT, PLAYER_VELOCITY_TERMINAL); //Stop the player accelerating constantly
    }
    if (!isMoving()) { //If not moving, deccelerate TODO: implement this mathematically
      vel.set(0, vel.y, 0);
    }
    pos.add(vel); //Add velocity to position
  }

  void mouseCheck() {
    PointerInfo a = MouseInfo.getPointerInfo();
    Point m = a.getLocation();
    mx = (int)m.getX();
    my = (int)m.getY();
    if (!(abs(pmouseX-mouseX) == 0 && abs(pmouseY-mouseY) == 0)) {
      screenX = mx-mouseX;
      screenY = my-mouseY;
    }
    if (!keys.getKey("mouseLock")) { //If mouseLock is on
      dir.x += (mouseX-width/2)*MOUSE_SENSITIVITY; //Makes the camera rotate, TODO: use constant for sensitivity
      dir.y += (mouseY-height/2)*MOUSE_SENSITIVITY;//*10/7;
      dir.y = constrain(dir.y, -89, 89);
    }
    robot.mouseMove(int(screenX+width/2.0), int(screenY+height/2.0));
  }

  void run() { //Called evey frame
    mouseCheck();

    cam.changeDir(dir.x, dir.y); //changes the camera direction

    move(); //All the movement stuff

    send(this);
    //sendNEW(pos);
    hud.updateItem("fps", nfc(frameRate, 2)); //Updates HUD elements TODO: find better way/move to function
    hud.updateItem("health-bar", health/100);

    ak47.updatePos(pos);
    ak47.run();
  }

  void display() { //Draws HUD and camera
    hud.display(); //MUST be before camera update
    cam.display(size);
    ak47.display();
  }
}
