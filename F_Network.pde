final String SERVER_IP = "10.56.101.108";
final int SEND_PORT = 2323;
final int REC_PORT = 2324;

/*TODO:
 * Add rotation networking
 */

void send(Player p) {
  String m = String.valueOf(p.pos)+String.valueOf(p.cam.center);
  println(m);
  udp.send(m, SERVER_IP, SEND_PORT);
}

/*void sendNEW(PVector p) {
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
  // [pos][center]ip@
  String message = new String(_data);
  String[] others = message.split("@");
  serverFrames = int(others[others.length-1]);
  for(int i = 0; i < others.length-1; i++){ //The last elem is used for server sync data
    if(others[i].contains("you")) continue;
    String[] player = others[i].split("\\]");
    if(players.containsKey(player[2])){
      players.get(player[2]).updatePos(player[0], player[1]);
    }else{
      players.put(player[2], new PlayerOther(player[0], player[1]));
    }
  }
  //DECODE positions
}
