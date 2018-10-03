class ThreadHandler {
  HashMap<String, MasterThread> threads = new HashMap<String, MasterThread>();

  ThreadHandler() {
    threads.put("physics", new PhysThread("Physics"));
    threads.put("camera", new CamThread("Camera"));
    threads.put("network", new NetThread("Network"));
    threads.put("movement", new MoveThread("Movement"));
  }

  // void stopAll(){
  //   for(MasterThread mt : threads.values()){
  //     mt.stop = true;
  //   }
  // }

  void start() {
    for (MasterThread mt : threads.values()) { //Starts all the threads
      mt.create();
    }
  }
}
