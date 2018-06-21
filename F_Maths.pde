String readable(PVector p){
  return round(p.x)+" . "+round(p.y)+" . "+round(p.z);
}

void startDrawHud(){
  camera();
  noLights();
  hint(DISABLE_DEPTH_TEST);
  //frustum(-10, 0, 0, 10, 10, 10000);
}

void endDrawHud(){
  hint(ENABLE_DEPTH_TEST);
}
