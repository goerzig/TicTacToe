class Score {
  int playerWins;
  int computerWins;
  int draws;
  
  Score() {
    this.playerWins = 0;
    this.computerWins = 0;
    this.draws = 0;
  }
  
  /**
    * win -1 if player won, 1 if computer won
    *
  **/
  void addWin(int win) {
    if (win == 1) {
      this.computerWins ++;
    }
    else if (win == -1) {
      this.playerWins ++;
    }
    else if (win == 0) {
      this.draws ++;
    }
  }
  
  /**
    * if the computer won the player is playing really bad....
    *
    **/
  int getScore() {
    return 100*this.playerWins - 50*this.draws - 500*this.computerWins;
  }
}
