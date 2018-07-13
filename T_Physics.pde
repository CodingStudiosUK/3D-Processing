

class PhysicsThread extends Thread { //A custom thread class to easily multithread
  private Thread t;
  String name = "Physics";
  final int TICKRATE = 30;

  PhysicsThread() {
  }

  public void run() { //Takes it's own section of the game array

    while (true) {
      //Do physics
      map.physics();

      player.physics();
      delay(1000/TICKRATE);
    }
  }

  public void start () {
    if (t == null) {
      t = new Thread (this, name);
      t.start ();
    }
  }
}
