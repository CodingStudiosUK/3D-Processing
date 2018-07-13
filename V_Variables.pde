int serverFrames;

int mx, my, screenX, screenY;


Player player;
HashMap<String, PlayerOther> players = new HashMap<String, PlayerOther>();
HashMap<String, Model> models;

Robot robot; //Java robot object for keeping the mouse centered
PhysicsThread physics = new PhysicsThread(); //Physics thread to improve FPS

UDP udp;
MapStorage map;

InputStorage keys;
