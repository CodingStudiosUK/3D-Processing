import hypermedia.net.*;
import java.util.Arrays;

Buffer buffer;

int CLIENT_PORT = 2323; // line 1
int SERVER_PORT = 2324; // line 3

HashMap<String, Player> players = new HashMap<String, Player>();

void setup() {
  size(400, 400);
  loadIP();
  buffer = new Buffer();
  thread("netThread");
}

void draw() {
  background(0);
  fill(255);
  text(frameRate+"\n"+players.values().size(), 20, 20);
  for (String k : players.keySet()) {
    players.get(k).display();
  }
}
int TICKRATE = 60;

void netThread() {
  while (true) {
    for (String k : players.keySet()) {
      players.get(k).buffer();
    }
    buffer.flush();
    delay(1000/TICKRATE);
  }
}
