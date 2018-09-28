class PhysThread extends MasterThread { //A custom thread class to easily multithread

  PhysThread(String n) {
    TICKRATE = 120;
    name = n;
  }

  public void runLoop() { //Takes it's own section of the game array
    map.physics();
    player.physics();

  }
}

class MoveThread extends MasterThread {

  MoveThread(String n){
    TICKRATE = 600;
    name = n;
    //noDelay = true; //The thread will run as fast as is possible
  }

  void runLoop(){
    player.movement();
  }
}

class NetThread extends MasterThread { //Buffers and sends the network packets, 64 tick
  NetThread(String n){
    TICKRATE = 64;
    name = n;
  }

  void runLoop(){
    player.buffer();
    buffer.flush();
  }
}
