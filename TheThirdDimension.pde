import java.awt.Robot;
import java.awt.AWTException;

ArrayList<MasterObject> level;
Player player;
final PVector GRAVITY = new PVector(0, 4);

Robot robot;

void setup() {
  size(1280, 720, P3D);
  //fullScreen(P3D);
  try {
   robot = new Robot();
 }
 catch (AWTException e) {
   e.printStackTrace();
 }

  level = loadLevel("l0m0");
  noCursor();
  setKeys();
  player = new Player(0,-60,0,40,100,40);

  textSize(50);
  textAlign(CENTER, CENTER);
}

ArrayList<MasterObject> loadLevel(String filename){
  ArrayList<MasterObject> al = new ArrayList<MasterObject>();
  JSONArray arr = loadJSONArray(filename+".json");
  for (int i = 0; i < arr.size(); ++i){
    JSONObject obj = arr.getJSONObject(i);
    /* TODO:
    Each type of object should be created by a different function.*/
    JSONObject corners = obj.getJSONObject("corners");
    JSONObject one = corners.getJSONObject("one");
    JSONObject two = corners.getJSONObject("two");
    al.add(new Cuboid(one.getInt("x"), one.getInt("y"), one.getInt("z"), two.getInt("x"), two.getInt("y"), two.getInt("z")));
  }
  return al;
}

void draw() {
  player.run();

  background(10);
  ambientLight(255, 255, 255, 0, 0, 0);
  player.display();
    for (MasterObject mo : level){
    mo.display();
    mo.collide(player);
  }

  debug();
}

void debug(){

  if(keysPress.get(keysName.get("debug"))){
    // pushMatrix();
    // translate(player.pos.x+player.view.x,player.pos.y+player.view.y, player.pos.z+player.view.z);
    // float headX = PI-atan2(player.view.x, player.view.z);
    // print(degrees(headX)+" :: ");
    // float headY = cos(headX-HALF_PI);
    // print(degrees(headY)+" :: ");
    // rotateX(asin(headY));
    // rotateZ(acos(headY));
    // rotateY(headX);
    // box(20, 20, 20);
    // fill(255, 0, 0);
    // text(round(frameRate), 0, 0);
    // fill(255);
    // popMatrix();
  }
}

/*void mousePressed(){
  level.add(new Cuboid(player.pos.x+player.view.x-10, player.pos.y+player.view.y-10, player.pos.z+player.view.z-10,
    player.pos.x+player.view.x+10, player.pos.y+player.view.y+10, player.pos.z+player.view.z+10));
}*/
