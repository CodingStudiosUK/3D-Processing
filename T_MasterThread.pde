abstract class MasterThread extends Thread{
  private Thread t;
  String name;
  int TICKRATE;
  boolean noDelay = false;
  boolean stop = false;

  MasterThread(){
    TICKRATE = 60;
    name = "Random Thread";
  }

  abstract void runLoop();

  void run(){
    while(!stop){
      int fstart = millis(); //Frame start time
      runLoop();
      if(!noDelay){
        delay(constrain( 1000/TICKRATE-(millis()-fstart) , 0, 1000/TICKRATE)); //To maintain a consistent tickrate, it's 1/60 seconds - frame time
      }
    }
  }

  void create(){
    if(t == null){
      t = new Thread(this, name);
      t.start();
    }
  }
}
