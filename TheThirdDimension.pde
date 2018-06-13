import java.awt.Robot;
import java.awt.AWTException;

final float MAGIC = (height/2.0) / tan(PI*30.0 / 180.0);

ArrayList<MasterObject> level;
Player player;

Robot robot;

void setup() {
  //size(1280, 720, P3D);
  fullScreen(P3D);
  try {
   robot = new Robot();
 }
 catch (AWTException e) {
   e.printStackTrace();
 }

  level = loadLevel("l0m0");
  noCursor();
  setKeys();
  player = new Player(0,0,0,width,height,0);

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
  background(10);
  ambientLight(255, 255, 255, 0, 0, 0);
  player.run();
  for (MasterObject mo : level){
    mo.display();
  }
  //player.display();
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
  println();
}

void mousePressed(){
  level.add(new Cuboid(player.pos.x+player.view.x-10, player.pos.y+player.view.y-10, player.pos.z+player.view.z-10,
    player.pos.x+player.view.x+10, player.pos.y+player.view.y+10, player.pos.z+player.view.z+10));
}
