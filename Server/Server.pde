import hypermedia.net.*;
import java.util.Arrays;
UDP udp;

String SERVER_IP = "10.56.101.108";
final int PORT = 2323;

HashMap<String, Player> players = new HashMap<String, Player>();

void setup(){
  size(400, 400);
  udp = new UDP(this, PORT);
  udp.listen(true);
  thread("netThread");
}

void draw(){
  background(0);
  fill(255);
  text(frameRate+"\n"+players.values().size(), 20, 20);
  for(Player p : players.values()){
    //println(p.id);
    p.display();
  }

}
int TICKRATE = 140;

void netThread(){
  while(true){
    send();
    delay(1000/TICKRATE);
  }
}
