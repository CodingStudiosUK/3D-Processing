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
  //spotLight(255, 255, 255, -100, -800, -100, 1, 1, 1, 120, 500);
  //directionalLight(255, 255, 255, 1, 1, 2);
  ambientLight(255, 255, 255, 0, 0, 0);
}

color getJSONColor(JSONObject o){
  return color(o.getInt("r"), o.getInt("g"), o.getInt("b"));
}

float getX(JSONObject o){
  return o.getFloat("x");
}
float getY(JSONObject o){
  return o.getFloat("y");
}
float getZ(JSONObject o){
  return o.getFloat("z");
}

HashMap<String, HUDObject> loadHUD(String filename){
  HashMap<String, HUDObject> elems = new HashMap<String, HUDObject>();
  JSONArray arr = loadJSONArray(filename+".json");
  for(int i = 0; i < arr.size(); i++){
    JSONObject obj = arr.getJSONObject(i);
    String id = obj.getString("name");
    HUDObject e;
    JSONObject pos = obj.getJSONObject("position");
    JSONObject col = obj.getJSONObject("color");
    JSONObject fill, stroke, size;
    switch(obj.getString("type")){
      case "text":
        fill = col.getJSONObject("fill");
        e = new HUDText(getX(pos), getY(pos), obj.getInt("size"),
          getJSONColor(fill));
        break;
      case "bar":
        fill = col.getJSONObject("fill");
        stroke = col.getJSONObject("stroke");
        size = obj.getJSONObject("size");
        e = new HUDBar(getX(pos), getY(pos), getX(size), getY(size),
          getJSONColor(fill), getJSONColor(stroke));
        break;
      case "xhair": //TODO: Use a seperate config file for crosshair
        stroke = col.getJSONObject("stroke");
        size = obj.getJSONObject("size");
        e = new HUDXhair(getX(pos), getY(pos), getX(size), getY(size),
          getJSONColor(stroke));
        break;
      case "icon":
        String file = obj.getString("file");
        size = obj.getJSONObject("size");
        e = new HUDIcon(getX(pos), getY(pos), getX(size), getY(size), loadImage(file));
        break;
      default:
        println("Invalid HUD item: "+obj.getString("type"));
        continue;
    }
    elems.put(id, e);
  }
  return elems;
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
    color col = getJSONColor(colours);
    Cuboid c;
    if(obj.getString("type").equals("CuboidMoving")){
      JSONObject dist = obj.getJSONObject("distance");
      c = new CuboidMoving(one.getInt("x"), one.getInt("y"), one.getInt("z"), two.getInt("x"), two.getInt("y"), two.getInt("z"),
       dist.getInt("x"), dist.getInt("y"), dist.getInt("z"));
    }else{
      c = new Cuboid(one.getInt("x"), one.getInt("y"), one.getInt("z"), two.getInt("x"), two.getInt("y"), two.getInt("z"));
    }
    c.setColor(col);
    al.add(c);
  }
  return al;
}

float[] getAng(PVector pos, PVector center){
  PVector diff = PVector.sub(pos, center);
  float[] angs = {atan2(diff.x, diff.z)+PI, asin(diff.y/RADIUS)};
  return angs;
}
