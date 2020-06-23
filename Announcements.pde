class Announcements {
  
  int size;
  int screenCenterX;
  int screenCenterY;
  Setup setup;
  
  Announcements(Setup setup, int size) {
    this.size = size;
    this.setup = setup;
  }
  
  void drawWin() {
    textSize(size);
    fill(0, 255, 0);
    String text = "YOU WON";
    text(text, getTextPositionX(text), getTextPositionY());
  }
  void drawDefeat() {
    textSize(size);
    fill(255, 0, 0);
    String text = "YOU LOST";
    text(text, getTextPositionX(text), getTextPositionY());
  }
  void drawDraw() {
    textSize(size);
    fill(0, 0, 255);
    String text = "DRAW";
    text(text, getTextPositionX(text), getTextPositionY());
  }
  
  void drawScore(Score score) {
    textSize(20);
    fill(0);
    String text = "Won: " + score.playerWins + " | Draw: " + score.draws + " | Lost: " + score.computerWins + " | Score: " + score.getScore();
    text(text, this.getTextPositionX(text), 20);
  }
  
  int getTextPositionX(String text) {
    return int(width/2 - textWidth(text)/2);
  }
  int getTextPositionY() {
    return int(height/2 + size/2);
  }
}
