import java.awt.*;
import java.awt.AWTException;
import hypermedia.net.*;

final boolean FULLSCREEN = true;

final int PLAYER_WIDTH = 30;
final int PLAYER_DEPTH = 30;
final int PLAYER_HEIGHT = 110;
final int PLAYER_EYE_OFFSET = 6; //Arbitrary values.

final float CAM_RADIUS = 1000; // How far away the camera center is.

final int TOUCH_NOT = -1,
  TOUCH_LEFT = 0,
  TOUCH_RIGHT = 1,
  TOUCH_FRONT = 2,
  TOUCH_BACK = 3,
  TOUCH_TOP = 4,
  TOUCH_BOTTOM = 5;
final color DEFAULT_COLOR = color(255, 2);
final color DEFAULT_STROKE = color(255);


final int PLAYER_VELOCITY_TERMINAL = 25;
final float MOUSE_SENSITIVITY = 0.2;

final String SERVER_IP = "10.56.99.105";
final int SEND_PORT = 2323;
final int REC_PORT = 2324;

final Vector GRAVITY = new Vector(0, 0.1); //ACCELERATION due to gravity

Buffer buffer;

int serverFrames;

Point mouse = new Point(0, 0), pmouse = new Point(0, 0), screen = new Point(0, 0);

Player player;
HashMap<Integer, PlayerOther> players = new HashMap<Integer, PlayerOther>();
HashMap<String, Model> models;

Robot robot; //Java robot object for keeping the mouse centered
ThreadHandler th = new ThreadHandler();

UDP udp;
MapStorage map;

InputStorage keys;


void settings() {
  if (FULLSCREEN) {
    fullScreen(P3D);
  } else {
    size(1400, 600, P3D);
  }
  smooth(2);

}

void setup() {
  frameRate(60);
  config();
  buffer = new Buffer();
  map = new MapStorage();
  keys = loadKeys();
  models = loadModels("models/modelList");

  player = new Player(0, -PLAYER_HEIGHT/2, 0, PLAYER_WIDTH, PLAYER_HEIGHT, PLAYER_DEPTH); //Create the player

  th.start(); //Start the thread handler
  noCursor();
}

void draw() {
  player.run(); //Do Player interaction

  setLights();
  map.render();
  for (Player p : players.values()) { //Draws other players
    p.display();
  }

  player.display(); //Draws the hud and moves the camera.

}
