final String SERVER_IP = "10.56.101.108";
final int PORT = 2324;

void send(String m) {
  udp.send(m, SERVER_IP, 2323);
}

void receive(byte[] _data, String ip, int port) {
  String message = new String(_data);
  String[] others = message.split("@");
  for(int i = 0; i < others.length; i++){
    String pos = others[i].substring(1, others[i].indexOf("]"));
    String oIP = others[i].substring(others[i].indexOf("]"), others[i].length());
    if(players.containsKey(oIP)){
      players.get(oIP).updatePos(pos);
    }else{
      players.put(oIP, new PlayerOther(pos));
    }
  }
  //DECODE positions
}
