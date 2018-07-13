class InputStorage {

  HashMap<Character, Boolean> keysHold = new HashMap<Character, Boolean>(), //For keys being held
    keysPress = new HashMap<Character, Boolean>(); //For keys being toggled
  HashMap<String, Character> keysName = new HashMap<String, Character>();

  InputStorage() {
  }

  void addHold(String s, char c) {
    keysName.put(s, c);
    keysHold.put(c, false);
  }
  void addPress(String s, char c) {
    keysName.put(s, c);
    keysPress.put(c, false);
  }

  void setKey(char c, boolean val) {
    if (keysHold.containsKey(c)) keysHold.put(c, val);
    if (keysPress.containsKey(c)&&val) keysPress.put(c, !keysPress.get(c));
  }
  void setKey(String s, boolean val) {
    if (keysName.containsKey(s)) setKey(keysName.get(s), val);
  }

  boolean getKey(char c) {
    if (keysPress.containsKey(c)) return keysPress.get(c);
    if (keysHold.containsKey(c)) return keysHold.get(c);
    return false;
  }
  boolean getKey(String s) {
    if (keysName.containsKey(s)) return getKey(keysName.get(s));
    return false;
  }
}

void keyPressed() { // When the user presses a key.
  keys.setKey(Character.toLowerCase(key), true);
}

void keyReleased() { // When the user releases a key.
  keys.setKey(Character.toLowerCase(key), false);
}
