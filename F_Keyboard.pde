HashMap<Character, Boolean> keysHold = new HashMap<Character, Boolean>(),
  keysPress = new HashMap<Character, Boolean>();
HashMap<String, Character> keysName = new HashMap<String, Character>();

void setKeys() {
  keysName.put("left", 'a');
  keysName.put("forward", 'w');
  keysName.put("right", 'd');
  keysName.put("backward", 's');
  keysName.put("up", 'q');
  keysName.put("down", 'z');
  keysName.put("rotleft", 'j');
  keysName.put("rotright", 'l');
  keysName.put("rotup", 'i');
  keysName.put("rotdown", 'k');

  keysName.put("debug", 'p');

  keysHold.put(keysName.get("forward"), false);
  keysHold.put(keysName.get("left"), false);
  keysHold.put(keysName.get("backward"), false);
  keysHold.put(keysName.get("right"), false);
  keysHold.put(keysName.get("up"), false);
  keysHold.put(keysName.get("down"), false);
  keysHold.put(keysName.get("rotleft"), false);
  keysHold.put(keysName.get("rotright"), false);
  keysHold.put(keysName.get("rotup"), false);
  keysHold.put(keysName.get("rotdown"), false);
  keysPress.put(keysName.get("debug"), true);
}

void keyPressed() {
  key = Character.toLowerCase(key);
  if (keysHold.containsKey(key)) keysHold.put(key, true);
  if (keysPress.containsKey(key)) keysPress.put(key, !keysPress.get(key));
}

void keyReleased() {
  key = Character.toLowerCase(key);
  if (keysHold.containsKey(key)) keysHold.put(key, false);
}
