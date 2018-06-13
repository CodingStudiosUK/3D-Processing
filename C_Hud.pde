class Hud{
  PVector center;
  HashMap<String, HudElement> items;

  Hud(PVector pos){
    center = pos;
    items = new HashMap<String, HudElement>();
  }

  void add(String id, HudElement e){
    items.put(id, e);
  }

  void setText(String id, String t){
    //(HudText)(items.get(id)).setText(t);
  }

  void display(){
    for(HudElement i : items.values()){
      i.display();
    }
  }


}

abstract class HudElement{
  PVector pos;

  PVector to3D(int x, int y){
    return new PVector(x, y, 0);
  }
  abstract void display();
}

class HudText extends HudElement{
  String value;
  int size;
  color col;

  HudText(String t, int x, int y, int size, color c){
    this.pos = to3D(x, y);
    value = String.valueOf(t);
    this.size = size;
    col = c;
  }

  void setText(String t){
    value = t;
  }

  void display(){
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
