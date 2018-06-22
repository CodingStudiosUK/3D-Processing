class HUD{
  HashMap<String, HUDObject> items = new HashMap<String, HUDObject>();

  HUD(){
  }

  void addItem(String id, HUDObject elem){
    items.put(id, elem);
  }

  void updateItem(String id, Object val){
    HUDObject e = items.get(id);
    e.update(val);
  }

  void display(){
    startDrawHud();
    for(HUDObject ho : items.values()){
      ho.display();
    }
    fill(0, 255, 0);
    text(String.valueOf(player.vel), 20, 150);
    //Draw hud elements as 2D canvas
    endDrawHud();
  }
}
abstract class HUDObject<V>{ //Parent class for HUD objects, sets up necessary methods/properties
  private V type;
  PVector pos;
  color colFill;
  color colStroke;

  HUDObject(int x, int y, color f, color s){
    pos = new PVector(x, y);
    colFill = f;
    colStroke = s;
  }

  abstract void update(V v);
  abstract void display();

  V getType(){
    return type;
  }

}

class HUDBar extends HUDObject<Float>{ //A health/ammo bar
  float value;
  PVector size;

  HUDBar(int x, int y, int w, int h, color c, color s){
    super(x, y, c, s);
    size = new PVector(w, h);
  }

  void update(Float val){
    value = (float)val;
  }

  void display(){
    noFill();
    stroke(colStroke);
    rect(pos.x, pos.y, size.x, size.y);
    fill(colFill);
    rect(pos.x-(1-value/2), pos.y, size.x*value, size.y);
  }
}

class HUDIcon extends HUDObject<PImage>{ //For displaying icon images on the HUD (health/ammo icons)
  PVector size;
  PImage icon;

  HUDIcon(int x, int y, int w, int h){
    super(x, y, DEFAULT_COLOR, DEFAULT_STROKE);
    size = new PVector(w, h);
  }
  HUDIcon(int x, int y, int w, int h, PImage ico){
    super(x, y, DEFAULT_COLOR, DEFAULT_STROKE);
    size = new PVector(w, h);
    icon = ico;
  }

  void update(PImage p){
    icon = p;
  }

  void display(){
    image(icon, pos.x, pos.y, size.x, size.y);
  }

}

class HUDText extends HUDObject<String>{ //For displaying text to the HUD
  String text;
  int size;

  HUDText(int x, int y, int s, color c){
    super(x, y, c, DEFAULT_STROKE);
    size = s;
  }

  void update(String t){
    text = t;
  }

  void display(){
    fill(colFill);
    textSize(size);
    textAlign(LEFT, TOP);
    text(text, pos.x, pos.y);
  }
}
