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

class CamThread extends MasterThread {

  CamThread(String n){
    TICKRATE = 900;
    name = n;
    //noDelay = true; //The thread will run as fast as is possible
  }

  void runLoop(){
    player.mouseCheck();
  }
}

class NetThread extends MasterThread { //Buffers and sends the network packets, 64 tick
  NetThread(String n){
    TICKRATE = 30;
    name = n;
  }

  void runLoop(){
    player.buffer();
    buffer.flush();
  }
}
  //if (FULLSCREEN) {

class MoveThread extends MasterThread {

  MoveThread(String n){
    TICKRATE = 100;
    name = n;
  }

  void runLoop(){
    player.move();
  }
}
