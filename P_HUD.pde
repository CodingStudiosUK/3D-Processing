class HUD {
  HashMap<String, HUDObject> items = new HashMap<String, HUDObject>();

  HUD(String HUDFile) {
    items = loadHUD(HUDFile);
  }

  void addItem(String id, HUDObject elem) {
    items.put(id, elem);
  }

  void updateItem(String id, Object val) {
    HUDObject e = items.get(id);
    e.update(val);
  }

  void display() {
    startDrawHud();
    for (HUDObject ho : items.values()) {
      ho.display();
    }
    text(players.size(), 10, 50);
    //Draw hud elements as 2D canvas
    endDrawHud();
  }
}
abstract class HUDObject<V> { //Parent class for HUD objects, sets up necessary methods/properties
  Vector pos;
  color colFill;
  color colStroke;

  HUDObject(float x, float y, color f, color s) {
    pos = new Vector(x*width, y*height);
    colFill = f;
    colStroke = s;
  }

  abstract void update(V v);
  abstract void display();
}

class HUDXhair extends HUDObject<Vector> {

  Vector size;

  HUDXhair(float x, float y, float w, float h, color s) {
    super(x, y, color(0, 0), s);
    this.size = new Vector(w, h);
  }

  void update(Vector siz) {
    size = siz;
  }

  void display() {
    strokeWeight(2);
    stroke(colStroke);
    line(width/2-size.x/2, height/2, width/2+size.x/2, height/2);
    line(width/2, height/2-size.y/2, width/2, height/2+size.y/2);
  }
}

class HUDBar extends HUDObject<Float> { //A health/ammo bar
  float value;
  Vector size;

  HUDBar(float x, float y, float w, float h, color c, color s) {
    super(x, y, c, s);
    size = new Vector(w, h);
  }

  void update(Float val) {
    value = (float)val;
  }

  void display() {
    noFill();
    stroke(colStroke);
    rect(pos.x, pos.y, size.x, size.y);
    fill(colFill);
    rect(pos.x-(1-value/2), pos.y, size.x*value, size.y);
  }
}

class HUDIcon extends HUDObject<PImage> { //For displaying icon images on the HUD (health/ammo icons)
  Vector size;
  PImage icon;

  HUDIcon(float x, float y, float w, float h) {
    super(x, y, DEFAULT_COLOR, DEFAULT_STROKE);
    size = new Vector(w, h);
  }
  HUDIcon(float x, float y, float w, float h, PImage ico) {
    super(x, y, DEFAULT_COLOR, DEFAULT_STROKE);
    size = new Vector(w, h);
    icon = ico;
  }

  void update(PImage p) {
    icon = p;
  }

  void display() {
    image(icon, pos.x, pos.y, size.x, size.y);
  }
}

class HUDText extends HUDObject<String> { //For displaying text to the HUD
  String text;
  float size;

  HUDText(float x, float y, float s, color c) {
    super(x, y, c, DEFAULT_STROKE);
    size = s;
  }

  void update(String t) {
    text = t;
  }

  void display() {
    fill(colFill);
    textSize(size);
    textAlign(LEFT, TOP);
    text(text, pos.x, pos.y);
  }
}
