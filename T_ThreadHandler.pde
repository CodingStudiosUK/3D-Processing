class ThreadHandler{
  HashMap<String, MasterThread> threads = new HashMap<String, MasterThread>();

  ThreadHandler(){
    threads.put("physics", new PhysThread("Physics"));
    threads.put("movement", new MoveThread("Movement"));
    threads.put("network", new NetThread("Network"));
  }

  // void stopAll(){
  //   for(MasterThread mt : threads.values()){
  //     mt.stop = true;
  //   }
  // }

  void start(){
    for(MasterThread mt : threads.values()){ //Starts all the threads
      mt.create();
    }
  }
}
