final int TICKRATE = 30;
final PVector GRAVITY = new PVector(0, 1); //ACCELERATION due to gravity

class PhysicsThread extends Thread { //A custom thread class to easily multithread
  private Thread t;
  String name = "Physics";

  PhysicsThread() {
  }

  public void run() { //Takes it's own section of the game array

    while(true){
      //Do physics
      for (MasterObject mo : level){
        mo.collide(player);
      }
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
