/*Object types:
 - PLAYER
 - ITEM
 - ENTITY (interactables)
 - META (metadata)
 */

public class Buffer {

  final int PORT = 2324;

  UDP udp;
  String buffer = "";

  Buffer() {
    udp = new UDP(this, PORT);
    udp.listen(true);
  }

  void addVal(PVector pv) {
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
    //println("SERVER: sending"+buffer);
    println("SERVER: "+buffer);
    for (String k : players.keySet()) {
      udp.send(buffer.replace(str(players.get(k).id), "y"+str(players.get(k).id)), k, 2323); //Send the data to each client, filtering out their own data
    }
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

    String[] items = data.split("}");
    for (String item : items) {
      String[] props = item.substring(item.indexOf("#")+1, item.length()).split("]");
      if (players.containsKey(ip)) {
        players.get(ip).update(getVector(props[0]), getVector(props[1]), getBool(props[2]));
      } else { //New client connected
        players.put(ip, new Player(getVector(props[0]), getVector(props[1]), getBool(props[2]), newClientID()));
      }
    }
  }

  int getNetItemID(String item) {
    return int(item.substring(0, item.indexOf(","))); //Hardcoded = bad, use properties or JSON spec.
  }

  PVector getVector(String prop) {
    String[] elems = prop.split(",");
    return new PVector(float(elems[0]), float(elems[1]), float(elems[2]));
  }

  boolean getBool(String prop) {
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
    for (Player c : players.values()) {
      if (id == c.id) {
        return false;
      }
    }
    return true;
  }
}

void send() {
  /*String data = "";
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
   }*/
}

void receive( byte[] _data, String ip, int port ) {
  /*String data = new String(_data);
   if (players.containsKey(ip)) {
   players.get(ip).update(data);
   } else {
   players.put(ip, new Player(data));
   players.get(ip).id = ip;
   }*/
}
