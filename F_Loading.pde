color getJSONColor(JSONObject o) {
  return color(o.getInt("r"), o.getInt("g"), o.getInt("b"), 255);
}

float getX(JSONObject o) {
  return o.getFloat("x");
}
float getY(JSONObject o) {
  return o.getFloat("y");
}
float getZ(JSONObject o) {
  return o.getFloat("z");
}

ArrayList<JSONObject> loadJSON(String filename) {
  ArrayList<JSONObject> objs = new ArrayList<JSONObject>();
  JSONArray arr = loadJSONArray(filename+".json");
  for (int i = 0; i < arr.size(); ++i) {
    objs.add(arr.getJSONObject(i));
  }
  return objs;
}

HashMap<String, HUDObject> loadHUD(String filename) {
  HashMap<String, HUDObject> elems = new HashMap<String, HUDObject>();
  JSONArray arr = loadJSONArray(filename+".json");
  for (int i = 0; i < arr.size(); i++) {
    JSONObject obj = arr.getJSONObject(i);
    String id = obj.getString("name");
    HUDObject e;
    JSONObject pos = obj.getJSONObject("position");
    JSONObject col = obj.getJSONObject("color");
    JSONObject fill, stroke, size;
    switch(obj.getString("type")) {
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

ArrayList<MasterObject> loadLevel(String filename) {
  ArrayList<MasterObject> al = new ArrayList<MasterObject>();
  JSONArray arr = loadJSONArray(filename+".json");
  for (int i = 0; i < arr.size(); ++i) {
    JSONObject obj = arr.getJSONObject(i);
    /* TODO:
     Each type of object should be created by a different function.*/
    JSONObject corners = obj.getJSONObject("corners");
    JSONObject one = corners.getJSONObject("one");
    JSONObject two = corners.getJSONObject("two");
    JSONObject colours = obj.getJSONObject("color");
    color col = getJSONColor(colours);
    Platform c;
    if (obj.getString("type").equals("CuboidMoving")) {
      JSONObject dist = obj.getJSONObject("distance");
      c = new PlatformMoving(one.getInt("x"), one.getInt("y"), one.getInt("z"), two.getInt("x"), two.getInt("y"), two.getInt("z"), 
        dist.getInt("x"), dist.getInt("y"), dist.getInt("z"), col);
    } else {
      c = new Platform(one.getInt("x"), one.getInt("y"), one.getInt("z"), two.getInt("x"), two.getInt("y"), two.getInt("z"), col);
    }
    al.add(c);
  }
  return al;
}

HashMap<String, Model> loadModels(String filename) {
  HashMap<String, Model> data = new HashMap<String, Model>();
  for (JSONObject obj : loadJSON(filename)) {
    String name = obj.getString("name");
    JSONArray rotA = obj.getJSONArray("rotation");
    float[] rot = new float[3];
    for (int i = 0; i < rotA.size(); i++) {
      rot[i] = float((int)rotA.get(i));
    }
    Model m = new Model(obj.getString("obj path"), 
      rot[0], rot[1], rot[2], 
      obj.getFloat("scale factor"));
    if (!obj.getBoolean("use mtl")) {
      m.useTexture(obj.getString("image path"));
    }
    data.put(name, m);
  }
  return data;
}

InputStorage loadKeys() { //Adds all the keys
  InputStorage keys = new InputStorage();
  for (JSONObject obj : loadJSON("keys")) {
    String alias = obj.getString("alias");
    char keyChar = obj.getString("key").charAt(0);
    switch(obj.getString("type")) {
    case "hold":
      keys.addHold(alias, keyChar);
      break;
    case "press":
      keys.addPress(alias, keyChar);
      break;
    default:
      println(alias);
      break;
    }
  }
  return keys;
}
