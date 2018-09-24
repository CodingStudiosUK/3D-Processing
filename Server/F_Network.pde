void send() {
  String data = "";
  for (Player p : players.values()) {
    data += p.asString()+p.id+"@";
  }
  if (data.length() > 2) {
    data = data.substring(0, data.length()-1);
  }
  data += "@"+frameCount;
  //println(data);
  for (String ip : players.keySet()) {
    udp.send(data.replace(ip, "you"), ip, 2324);
  }
}

void receive( byte[] _data, String ip, int port ) {
  String data = new String(_data);
  if (players.containsKey(ip)) {
    players.get(ip).update(data);
  } else {
    players.put(ip, new Player(data));
    players.get(ip).id = ip;
  }
}
