class Player extends MasterEntity{

  final float RADIUS = 200;
  float viewHor = 0, viewVer = 0;
  float speed = 10;
  PVector view;
  Hud hud;

  Player(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2);
    vel = new PVector(10,10,10);
    //view = new PVector(-width*0.5,-height*0.5);

    hud = new Hud(this.pos);
    hud.add("fps", new HudText(str(frameRate), 20, 20, 20, color(255, 0, 0)));
  }

  void setView(){
    float x = cos(radians(viewHor))*RADIUS;
    float z = sin(radians(viewHor))*RADIUS+RADIUS/2;
    float y = cos(radians(viewVer))*RADIUS;
    view = new PVector(x, y, z);
    //view.setMag(RADIUS);
  }

  void run(){
    hud.setText("fps", str(round(frameRate)));

    viewHor += (mouseX-width/2)*0.1;//*width*0.1;
    viewVer += (mouseY-height/2)*0.1;
    setView();
    vel = PVector.fromAngle(new PVector(view.x, view.z).heading());
    //vel = v.copy();
    PVector frameVel = new PVector(0, 0, 0);
    PVector tv = new PVector(speed, 0);
    if (keysHold.get(keysName.get("left"))){
      tv = PVector.mult(PVector.fromAngle(vel.heading()-HALF_PI), speed);
      frameVel.add(new PVector(tv.x, 0, tv.y));
    }
    if (keysHold.get(keysName.get("right"))){
      tv = PVector.mult(PVector.fromAngle(vel.heading()+HALF_PI), speed);
      frameVel.add(new PVector(tv.x, 0, tv.y));
    }
    if (keysHold.get(keysName.get("forward"))){
      tv = PVector.mult(PVector.fromAngle(vel.heading()), speed);
      frameVel.add(new PVector(tv.x, 0, tv.y));
      frameVel.add(new PVector(vel.x, 0, vel.y));
    }
    if (keysHold.get(keysName.get("backward"))){
      tv = PVector.mult(PVector.fromAngle(vel.heading()-PI), speed);
      frameVel.add(new PVector(tv.x, 0, tv.y));
    }
    frameVel.limit(speed);
    pos.add(frameVel);
    if (keysHold.get(keysName.get("up"))){
      pos.y -= speed;
    }
    if (keysHold.get(keysName.get("down"))){
      pos.y += speed;
    }


    robot.mouseMove(displayWidth/2, displayHeight/2);


    camera(pos.x, pos.y, MAGIC+pos.z, pos.x+view.x, pos.y+view.y, pos.z+view.z, 0, 1, 0);
  }

  void display(){

  }

}
