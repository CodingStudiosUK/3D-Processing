/*Object types:
 - PLAYER
 - ITEM
 - ENTITY (interactables)
 - META (metadata)
 */
 
void loadIP() {
  String[] s = loadStrings("data/ipConf.txt");
  SERVER_IP = s[1];
  CLIENT_PORT = int(s[0]);
  SERVER_PORT = int(s[2]);
}

public class Buffer {

  UDP udp;
  String buffer = "";

  Buffer() {
    udp = new UDP(this, CLIENT_PORT);
    udp.listen(true);
  }

  void addVal(Vector pv) {
    buffer += pv.x+","+pv.y+","+pv.z+"]";
  }

  void addVal(Object o) { //Tries to use standard toString() method.
    buffer += o.toString()+"]";
  }

  void addVal(ArrayList ar) { //Iterates and adds each object!
    for (int i = 0; i < ar.size(); i++) {
      addVal((Object)ar.get(i));
    }
  }

  void addVal(int i) {
    buffer += i+"]";
  }

  void addVal(String s) {
    buffer += s+"]";
  }

  void addVal(boolean b) {
    buffer += (b?"1":"0")+"]";
  }

  void startObject(int type, int id) {
    buffer += id+","+type+"#";
  }

  void endObject() {
    buffer += "}";
  }

  String withoutObjectID(int id) {
    int oStart = int(buffer.indexOf(str(id)));
    int oEnd = int(buffer.substring(oStart, buffer.indexOf("}")));

    String before = buffer.substring(0, constrain(oStart-1, 0, MAX_INT)); //Only 1 client...
    String after = buffer.substring(oEnd, buffer.length()-1);
    //println(before+"@"+after);
    return before+after;
  }

  void flush() { //Sends data to clients
    //println("CLIENT TX: "+buffer);
    udp.send(buffer, SERVER_IP, SERVER_PORT); //Send the data to each client, filtering out their own data
    buffer = ""; //Gotta reset the buffer after each flush....
  }
  /*Example data:
   {1732,0#340.12,750.438]234.58,85.3]}
   1732 - serverside entity id (Also used for other items?)
   0 - Object type
   # - End of metadata
   340.12,750.438 - Position of entity
   ] - Seperator, each value is followed by this
   } - Object seperator
   */

  void receive(byte[] _data, String ip, int port) {
    String data = new String(_data);
    //println("CLIENT REC: "+data);
    String[] items = data.split("}");
    for (String item : items) {
      String[] props = item.substring(item.indexOf("#")+1, item.length()).split("]");
      String ids = getNetItemID(item);
      int id;
      if (ids.contains("y")) {
        player.id = int(ids.substring(1, ids.length()));
        continue;
      } else {
        id = int(ids);
      }
      if (players.containsKey(id)) {
        players.get(id).update(getVector(props[0]), getVector(props[1]), getBool(props[2]));
      } else { //New client connected
        players.put(id, new PlayerOther(getVector(props[0]), getVector(props[1]), getBool(props[2]), id));
      }
    }
  }

  String getNetItemID(String item) {
    // id="you" returns 0
    //println("ITEM: "+item);
    return item.substring(0, item.indexOf(",")); //Hardcoded = bad, use properties or JSON spec.
  }

  Vector getVector(String prop) {
    String[] elems = prop.split(",");
    return new Vector(float(elems[0]), float(elems[1]), float(elems[2]));
  }

  boolean getBool(String prop) {
    //println(prop);
    return prop.equals("1");
  }

  int newClientID() {
    int id;
    do {
      id = round(random(1000, 9999));
    } while (!validID(id));
    return id;
  }

  boolean validID(int id) {
    for (PlayerOther c : players.values()) {
      if (id == c.id) {
        return false;
      }
    }
    return true;
  }
}
