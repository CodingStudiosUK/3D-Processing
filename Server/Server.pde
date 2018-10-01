import hypermedia.net.*;
import java.util.Arrays;

Buffer buffer;

HashMap<String, Player> players = new HashMap<String, Player>();

void setup(){
  size(400, 400);
  buffer = new Buffer();
  thread("netThread");
}

void draw(){
  background(0);
  fill(255);
  text(frameRate+"\n"+players.values().size(), 20, 20);
  for(String k : players.keySet()){
    players.get(k).display();
  }

}
int TICKRATE = 60;

void netThread(){
  while(true){
    for(String k : players.keySet()){
      players.get(k).buffer();
    }
    buffer.flush();
    delay(1000/TICKRATE);
  }
}
