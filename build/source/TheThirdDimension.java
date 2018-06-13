import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.awt.Robot; 
import java.awt.AWTException; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class TheThirdDimension extends PApplet {




final float MAGIC = (height/2.0f) / tan(PI*30.0f / 180.0f);

ArrayList<MasterObject> level;
Player player;

Robot robot;

public void setup() {
  //size(1280, 720, P3D);
  
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

public ArrayList<MasterObject> loadLevel(String filename){
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

public void draw() {
  background(10);
  ambientLight(255, 255, 255, 0, 0, 0);
  player.run();
  for (MasterObject mo : level){
    mo.display();
  }
  //player.display();
  debug();
}

public void debug(){

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

public void mousePressed(){
  level.add(new Cuboid(player.pos.x+player.view.x-10, player.pos.y+player.view.y-10, player.pos.z+player.view.z-10,
    player.pos.x+player.view.x+10, player.pos.y+player.view.y+10, player.pos.z+player.view.z+10));
}
abstract class MasterObject{

  PVector pos, size;

  MasterObject(float x1, float y1, float z1, float x2, float y2, float z2){
    PVector[] t = posSizeFromCorners(x1, y1, z1, x2, y2, z2);
    pos = t[0].copy();
    size = t[1].copy();
  }

  public @Override
  String toString(){
    return pos.toString();
  }

  public abstract void run();
  public abstract void display();

}

abstract class MasterGeometry extends MasterObject{
  MasterGeometry(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2);
  }
}

abstract class MasterEntity extends MasterObject{

  PVector vel;

  MasterEntity(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2);
  }

}
class Cuboid extends MasterGeometry{

  Cuboid(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2);
  }

  public void run(){
  }

  public void display(){
    cuboid(pos,size);
  }

}
class Hud{
  PVector center;
  HashMap<String, HudElement> items;

  Hud(PVector pos){
    center = pos;
    items = new HashMap<String, HudElement>();
  }

  public void add(String id, HudElement e){
    items.put(id, e);
  }

  public void setText(String id, String t){
    //(HudText)(items.get(id)).setText(t);
  }

  public void display(){
    for(HudElement i : items.values()){
      i.display();
    }
  }


}

abstract class HudElement{
  PVector pos;

  public PVector to3D(int x, int y){
    return new PVector(x, y, 0);
  }
  public abstract void display();
}

class HudText extends HudElement{
  String value;
  int size;
  int col;

  HudText(String t, int x, int y, int size, int c){
    this.pos = to3D(x, y);
    value = String.valueOf(t);
    this.size = size;
    col = c;
  }

  public void setText(String t){
    value = t;
  }

  public void display(){
    fill(col);
    textSize(size);
    pushMatrix();
    // Maths starts
    translate(player.pos.x+player.view.x,player.pos.y+player.view.y, player.pos.z+player.view.z);
    float headX = PI-atan2(player.view.x, player.view.z);
    print(degrees(headX)+" :: ");
    float headY = cos(headX-HALF_PI);
    print(degrees(headY)+" :: ");
    rotateX(asin(headY));
    rotateZ(acos(headY));
    rotateY(headX);
    text(value, 0, 0);
    popMatrix();
  }
}
class Player extends MasterEntity{

  final float RADIUS = 200;
  float viewHor = 0, viewVer = 0;
  PVector view;
  Hud hud;

  Player(float x1, float y1, float z1, float x2, float y2, float z2){
    super(x1, y1, z1, x2, y2, z2);
    vel = new PVector(10,10,10);
    //view = new PVector(-width*0.5,-height*0.5);

    hud = new Hud(this.pos);
    hud.add("fps", new HudText(str(frameRate), 20, 20, 20, color(255, 0, 0)));
  }

  public void setView(){
    float x = cos(radians(viewHor))*RADIUS;
    float z = sin(radians(viewHor))*RADIUS+RADIUS/2;
    float y = cos(radians(viewVer))*RADIUS;
    view = new PVector(x, y, z);
    //view.setMag(RADIUS);
  }

  public void run(){
    hud.setText("fps", str(round(frameRate)));

    viewHor += (mouseX-width/2)*0.1f;//*width*0.1;
    viewVer += (mouseY-height/2)*0.1f;
    setView();
    //vel = v.copy();

    if (keysHold.get(keysName.get("left"))){
      pos.x -= vel.x;
    }
    if (keysHold.get(keysName.get("right"))){
      pos.x += vel.x;
    }
    if (keysHold.get(keysName.get("forward"))){
      pos.z -= vel.z;
    }
    if (keysHold.get(keysName.get("backward"))){
      pos.z += vel.z;
    }
    if (keysHold.get(keysName.get("up"))){
      pos.y -= vel.y;
    }
    if (keysHold.get(keysName.get("down"))){
      pos.y += vel.y;
    }


    robot.mouseMove(displayWidth/2, displayHeight/2);


    camera(pos.x, pos.y, MAGIC+pos.z, pos.x+view.x, pos.y+view.y, pos.z+view.z, 0, 1, 0);
  }

  public void display(){

  }

}
HashMap<Character, Boolean> keysHold = new HashMap<Character, Boolean>(),
  keysPress = new HashMap<Character, Boolean>();
HashMap<String, Character> keysName = new HashMap<String, Character>();

public void setKeys() {
  keysName.put("left", 'a');
  keysName.put("forward", 'w');
  keysName.put("right", 'd');
  keysName.put("backward", 's');
  keysName.put("up", 'q');
  keysName.put("down", 'z');
  keysName.put("rotleft", 'j');
  keysName.put("rotright", 'l');
  keysName.put("rotup", 'i');
  keysName.put("rotdown", 'k');

  keysName.put("debug", 'p');

  keysHold.put(keysName.get("forward"), false);
  keysHold.put(keysName.get("left"), false);
  keysHold.put(keysName.get("backward"), false);
  keysHold.put(keysName.get("right"), false);
  keysHold.put(keysName.get("up"), false);
  keysHold.put(keysName.get("down"), false);
  keysHold.put(keysName.get("rotleft"), false);
  keysHold.put(keysName.get("rotright"), false);
  keysHold.put(keysName.get("rotup"), false);
  keysHold.put(keysName.get("rotdown"), false);
  keysPress.put(keysName.get("debug"), true);
}

public void keyPressed() {
  key = Character.toLowerCase(key);
  if (keysHold.containsKey(key)) keysHold.put(key, true);
  if (keysPress.containsKey(key)) keysPress.put(key, !keysPress.get(key));
}

public void keyReleased() {
  key = Character.toLowerCase(key);
  if (keysHold.containsKey(key)) keysHold.put(key, false);
}

public void spheroid(PVector pos, PVector size) {
  pushMatrix();
  translate(pos.x, pos.y, pos.z);
  sphere(size.x);
  popMatrix();
}

public void cuboid(PVector pos, PVector size) {
  pushMatrix();
  translate(pos.x, pos.y, pos.z+50); ////hmmmmmmmmmmm
  box(size.x, size.y, size.z);
  popMatrix();
}


public PVector[] posSizeFromCorners(float x1, float y1, float z1, float x2, float y2, float z2){
  PVector[] t = {new PVector(0,0,0), new PVector(0,0,0)};

  t[0].x = lerp(x1, x2, 0.5f);
  t[0].y = lerp(y1, y2, 0.5f);
  t[0].z = lerp(z1, z2, 0.5f);

  t[1].x = abs(x2-x1);
  t[1].y = abs(y2-y1);
  t[1].z = abs(z2-z1);

  return t;
}
  public void settings() {  fullScreen(P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "TheThirdDimension" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
