class MapStorage {
  ArrayList<MasterObject> geometry;


  MapStorage() {
    geometry = loadLevel("l0m0");
  }

  void render() {
    for (MasterObject mo : geometry) { //Run loop and draw loop of level objects
      mo.display();
    }
  }

  void physics() {
    for (MasterObject mo : geometry) {
      mo.run();
      mo.collide(player);
    }
  }
}
