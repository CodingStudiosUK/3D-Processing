String readable(PVector p){
  return round(p.x)+" . "+round(p.y)+" . "+round(p.z);
}

void startDrawHud(){ //Sets of camera/lighting for HUD
  camera();
  noLights();
  hint(DISABLE_DEPTH_TEST); //Makes sure HUD elements are ALWAYS in front
  //frustum(-10, 0, 0, 10, 10, 10000);
}

void endDrawHud(){ //Reenabled depth
  hint(ENABLE_DEPTH_TEST);
}

void config(){ //Sets of parameters before the program starts running
  try { //Setup Java robot to keep mouse in the center of the screen
   robot = new Robot();
  }
  catch (AWTException e) {
   e.printStackTrace();
  }
  noCursor(); //Hide the mouse cursor
  setKeys(); //Inits all of the keys TODO: (MOVE TO A CONFIG FILE)
}

void initNet(){ //Configures UDP stuff (and more in the future)
  udp = new UDP(this,REC_PORT);
  udp.log(false);
  udp.listen(true);
}

void setLights(){
  background(10); //Lighting and graphics stuff
  spotLight(255, 255, 255, -100, -800, -100, 1, 1, 1, 120, 500);
  directionalLight(255, 255, 255, 1, 1, 2);
  ambientLight(100, 100, 100, 0, 0, 0);
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
    JSONObject colours = obj.getJSONObject("color");
    color col = color(colours.getInt("r"), colours.getInt("g"), colours.getInt("b"));
    Cuboid c = new Cuboid(one.getInt("x"), one.getInt("y"), one.getInt("z"), two.getInt("x"), two.getInt("y"), two.getInt("z"));
    c.setColor(col);
    al.add(c);
  }
  return al;
}
