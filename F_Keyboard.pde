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
  keysName.put("jump", ' ');
  keysName.put("mouseLock", 'l');

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
  keysPress.put(keysName.get("jump"), false);
  keysPress.put(keysName.get("mouseLock"), true);
}

void keyPressed() {
  char k = Character.toLowerCase(key);

  if (keysHold.containsKey(k)) keysHold.put(k, true);
  if (keysPress.containsKey(k)) keysPress.put(k, !keysPress.get(k));
}

void keyReleased() {
  char k = Character.toLowerCase(key);
  if (keysHold.containsKey(k)) keysHold.put(k, false);
}
