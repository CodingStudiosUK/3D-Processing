class Player{
  PVector pos;
  PVector center;
  color col;
  int id;
  boolean bullet = false;

  int kills = 23, deaths = 42;

  Player(PVector pos, PVector center, boolean bullet, int id){
    update(pos, center, bullet);
    this.id = id;
    col = color(random(100, 255), random(100, 255), random(100, 255));
  }

  void update(PVector pos, PVector center, boolean bullet){
    this.pos = pos;
    this.center = center;
    this.bullet = bullet;
  }

  void buffer(){
    buffer.startObject(0, id);
    buffer.addVal(pos);
    buffer.addVal(center);
    buffer.addVal(bullet);
    buffer.addVal(kills);
    buffer.addVal(deaths);
    buffer.endObject();
  }

  void display(){
    fill(col);
    noStroke();
    ellipse(map(pos.x, -2048, 2048, 0, width), map(pos.z, -2048, 2048, 0, height), 20, 20);
    stroke(255);
  }
}
