import hypermedia.net.*;
import java.util.Arrays;
UDP udp;

String SERVER_IP = "10.56.101.108";
final int PORT = 2323;

HashMap<String, Player> players = new HashMap<String, Player>();

void setup(){
  fullScreen(FX2D);//size(400, 400);
  udp = new UDP(this, PORT);
  udp.listen(true);
  frameRate(600);
}

void draw(){
  background(0);
  for(Player p : players.values()){
    //println(p.id);
    p.display();
  }
  send();
}
