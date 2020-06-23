import java.util.Iterator;

String FILENAME = "data/states.json";
String FILENAME_EXPERT = "data/states_expert.json";
int INITIAL_PROBABILITY_VALUE = 1000;
int PLAYER_SWITCH = -1;
boolean PLAYER = true;
boolean LEARN = false;
boolean BCI = true;

int BOARD_SIZE = 600;
int TEXT_SIZE = 150;

int SCREEN_SIZE = 850;

Game game;
Setup setup;

void setup() {
  
  size(850, 850);
  background(255);
  setup = new Setup(FILENAME, FILENAME_EXPERT, INITIAL_PROBABILITY_VALUE, BOARD_SIZE, TEXT_SIZE, PLAYER_SWITCH, PLAYER, LEARN, BCI);
  //setup.setupFile();
  game = setup.setupNewGame();
}

void draw() {
  if (!game.gameOver) {
    background(255);
    strokeWeight(4);
    setup.announcements.drawScore(setup.score);
    fill(255);
    game.board.drawGrid();
    strokeWeight(10);
    game.board.drawState(game.currState);
    game.checkGameOver();
    if (abs(mouseX - SCREEN_SIZE/2) < BOARD_SIZE/2 && abs(mouseY - SCREEN_SIZE/2) < BOARD_SIZE/2) {
      stroke(200);
      strokeWeight(2);
      game.hoverBoard();
      stroke(0);
      strokeWeight(10);
    }
  }
  else {
    if (!PLAYER) game = setup.setupNewGame();
  }
}

void keyReleased() {
  if (setup.LEARN && game.moveUnrated && 48 < key && key < 58) {
    game.rateMoveManually(key-48-5);
  }
  if (game.gameOver && key == 32) {
    game = setup.setupNewGame();
  }
}

void mouseReleased() {
  if (game.gameOver) {
    game = setup.setupNewGame();
  }
  else if (!game.gameOver && abs(mouseX - SCREEN_SIZE/2) < BOARD_SIZE/2 && abs(mouseY - SCREEN_SIZE/2) < BOARD_SIZE/2) { 
    game.nextPlayerMove();
  }
}
