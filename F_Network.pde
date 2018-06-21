final String SERVER_IP = "169.254.198.17";
final int SEND_PORT = 2323;
final int REC_PORT = 2324;

void send(String m) {
  udp.send(m, "127.0.0.1", SEND_PORT);
}

void sendNEW(PVector p) {
  int[] pos = {(int)p.x, (int)p.y, (int)p.z};
  byte[] outputBytes = new byte[pos.length * 4];

  for(int i = 0, k = 0; i < pos.length; i++) {
      int integerTemp = pos[i];
      for(int j = 0; j < 4; j++, k++) {
          outputBytes[k] = (byte)((integerTemp >> (8 * j)) & 0xFF);
      }
  }
  udp.send(outputBytes, SERVER_IP, SEND_PORT);
}

void receive(byte[] _data, String ip, int port) {
  String message = new String(_data);
  String[] others = message.split("@");
  for(int i = 0; i < others.length; i++){
    if(others[i].contains("you")) continue;
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
