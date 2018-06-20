import java.awt.Robot;
import java.awt.AWTException;
import hypermedia.net.*;

final boolean FULLSCREEN = true;

ArrayList<MasterObject> level;
Player player;
HashMap<String, PlayerOther> players = new HashMap<String, PlayerOther>();
final PVector GRAVITY = new PVector(0, 8);

Robot robot;

UDP udp;

void settings(){
  if (FULLSCREEN) {
    fullScreen(P3D);
  }
  else {
    size(1280,600,P3D);
  }
}

void setup() {
  try {
   robot = new Robot();
 }
 catch (AWTException e) {
   e.printStackTrace();
 }

  level = loadLevel("l0m0");
  noCursor();
  setKeys();
  player = new Player(0,-60,0,40,80,40);

  textSize(50);
  textAlign(CENTER, CENTER);

  udp = new UDP(this,PORT);
  udp.listen(true);
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
  frustum(-10, 10, -7, 7, 10, 10000);
  player.run();
  for (MasterObject mo : level){
    mo.collide(player);
  }

  background(10);
  ambientLight(255, 255, 255, 0, 0, 0);
  player.display();
  for (MasterObject mo : level){
    mo.display();
  }
  for(Player p : players.values()){
    p.display();
  }

  debug();
  //println("----------------");
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
