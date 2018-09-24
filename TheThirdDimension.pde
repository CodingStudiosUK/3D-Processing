import java.awt.*;
import java.awt.AWTException;
import hypermedia.net.*;

void settings() {
  if (FULLSCREEN) {
    fullScreen(P3D);
  } else {
    size(1400, 600, P3D);
  }
  smooth(8);
}

void setup() {
  config();
  initNet();
  map = new MapStorage();
  keys = loadKeys();
  models = loadModels("models/modelList");

  player = new Player(0, -PLAYER_HEIGHT/2, 0, PLAYER_WIDTH, PLAYER_HEIGHT, PLAYER_DEPTH); //Create the player

  physics.start(); //Start the physics thread
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
