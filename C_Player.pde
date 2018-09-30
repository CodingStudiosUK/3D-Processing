class Player extends MasterEntity {

  final float JUMP_VEL = 5;

  final float MAX_SPEED = 4;//TODO:temp
  final float ACC = 1;
  final float INITIAL_SPEED = 0.05;

  Camera cam;
  color col;

  HUD hud;

  int id;

  //Stats
  float health = 100;
  int deaths = 0;

  Gun gun;

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

    gun = new Gun(pos.x, pos.y, pos.z);
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
      if(getXZ(vel).mag() <= 0){
        Vector t = new Vector(move).setMag(INITIAL_SPEED);
        vel.add(t.x, vel.y, t.y);
      }

      Vector moveAccel = new Vector(move).setMag(
        map(getXZ(vel).mag(), 0, MAX_SPEED*3, 0, ACC));

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
        vel.y = 0;
      }
      break;
    case TOUCH_TOP:
      if (vel.y >= 0) {
        pos.y = mo.getTop()-size.y/2;
        ground = true;
        vel.y = 0;
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
      Vector vh = getXZ(vel).setMag(ACC*2);
      vh.mult(map(sqrt(getXZ(vel).mag()), 0, sq(MAX_SPEED), 0, 2));
      vel.sub(vh.x, 0, vh.y);
    }
    pos.add(vel); //Add velocity to position


    //sendNEW(pos);

    //if(gun.bullets.size() > 0){

    //}
    gun.run();

    collide();
  }

  void movement(){ //Called by movment thread, for user input related movement
    mouseCheck();
    move(); //All the movement stuff
    gun.updatePos(pos);
  }

  void mouseCheck() {
    PointerInfo a = MouseInfo.getPointerInfo();
    mouse = a.getLocation();
    if (!(abs(pmouse.x-mouseX) == 0 && abs(pmouse.y-mouseY) == 0)) {
      screen.x = mouse.x-mouseX;
      screen.y = mouse.y-mouseY;
      println("MOUSE-------------: "+mouse.x+" : "+mouse.y);

      if (!keys.getKey("mouseLock")) { //If mouseLock is on
        dir.x += (mouse.x-(screen.x+width/2))*MOUSE_SENSITIVITY; //Makes the camera rotate, TODO: use constant for sensitivity
        dir.y += (mouse.y-(screen.y+height/2))*MOUSE_SENSITIVITY;//*10/7;
        dir.y = constrain(dir.y, -89, 89);
        robot.mouseMove(screen.x+width/2, screen.y+height/2);
      }
    }
    pmouse.x = mouse.x;
    pmouse.y = mouse.x;
    mouseX = screen.x+width/2; //Should prevent any glitches as mouseX is updated by processing at the beginning of every frame
    mouseY = screen.y+height/2;

    cam.changeDir(dir.x, dir.y); //changes the camera direction
  }

  void run() { //Called by main thread evey frame


    if(health <= 0){
      deaths++;
      health = 100;
      pos.set(0, -100, 0);
    }

    hud.updateItem("fps", nfc(frameRate, 2)+"\n"+pos.toString()); //Updates HUD elements TODO: find better way/move to function
    hud.updateItem("health-bar", health/100);

  }

  void buffer(){
    buffer.startObject(0, id);
    buffer.addVal(pos);
    buffer.addVal(cam.center);
    buffer.addVal(gun.shoot);
    buffer.endObject();
  }

  void collide(){
    try{
      for(Integer k : players.keySet()){
        if(players.get(k).bullet){
          hit(players.get(k).pos, players.get(k).center.normalise());
        }
      }
    }catch(Exception e){
      e.printStackTrace();
    }
  }

  boolean hit(Vector pos, Vector dir){
    for (int i = 1; i < 4096; i++){
      for(int j = 0; j < map.geometry.size(); j++){
        if(map.geometry.get(j).collide(pos)){
          return true;
        }
      }
      if(this.collide(pos)){
        health -= 5;
        return true;
      }
      pos.add(dir);
    }
    return false;
  }

  void display() { //Draws HUD and camera
    hud.display(); //MUST be before camera update
    cam.display(size);
    gun.display();
  }
}
