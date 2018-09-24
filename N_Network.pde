

void send(Player p) {
  String m = String.valueOf(p.pos)+String.valueOf(p.cam.center)+p.gun.toString();
  udp.send(m, SERVER_IP, SEND_PORT);
}

/*void sendNEW(Vector p) {
 int[] pos = {(int)p.x, (int)p.y, (int)p.z};
 byte[] outputBytes = new byte[pos.length * 4];

 for(int i = 0, k = 0; i < pos.length; i++) {
 int integerTemp = pos[i];
 for(int j = 0; j < 4; j++, k++) {
 outputBytes[k] = (byte)((integerTemp >> (8 * j)) & 0xFF);
 }
 }
 udp.send(outputBytes, SERVER_IP, SEND_PORT);
 }*/

void receive(byte[] _data, String ip, int port) {
  // [pos][center][bullet][bullet]...ip@
  String message = new String(_data);
  String[] others = message.split("@");
  serverFrames = int(others[others.length-1]);
  for (int i = 0; i < others.length-1; i++) { //The last elem is used for server sync data
    if (others[i].contains("you")) continue;
    String[] t = others[i].split("\\]");
    String playerIP = t[t.length-1];
    others[i] = others[i].substring(0, others[i].lastIndexOf("]")+1);
    if (players.containsKey(playerIP)) {
      players.get(playerIP).updatePos(others[i]);
    } else {
      players.put(playerIP, new PlayerOther(others[i]));
    }
  }
  //DECODE positions
}
