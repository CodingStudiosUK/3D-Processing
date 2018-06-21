import java.awt.Robot;
import java.awt.AWTException;
import hypermedia.net.*;

final boolean FULLSCREEN = true;
final int PLAYER_WIDTH = 40;
final int PLAYER_DEPTH = 40;
final int PLAYER_HEIGHT = 140;
final int PLAYER_EYE_OFFSET = 10;

ArrayList<MasterObject> level;
Player player;
HashMap<String, PlayerOther> players = new HashMap<String, PlayerOther>();

Robot robot; //Java robot object for keeping the mouse centered
PhysicsThread physics = new PhysicsThread(); //Physics thread to improve FPS

UDP udp;

void settings(){
  if (FULLSCREEN) {
    fullScreen(OPENGL);
  }
  else {
    size(800,600,P3D);
  }
  noSmooth(); // Antialiasing on the shadowMap leads to weird artifacts
}

void setup() {
  config();
  initNet();
  level = loadLevel("l0m0");

  player = new Player(0,-PLAYER_HEIGHT/2,0,PLAYER_WIDTH,PLAYER_HEIGHT,PLAYER_DEPTH); //Create the player

  physics.start(); //Start the physics thread
}


void draw() {
  player.run(); //Do Player interaction

  setLights();

  for (MasterObject mo : level){ //Run loop and draw loop of level objects
    mo.display();
  }
  for(Player p : players.values()){ //Draws other players
    p.display();
  }

  player.display(); //Draws the hud and moves the camera.
}
