class Game {
  
  State currState;
  int currStatePosition;
  int gameOutcome;
  boolean gameOver;
  ProbabilityGrid probabilityGridComputer;
  ProbabilityGrid probabilityGridPlayer;
  ArrayList<ProbabilityGrid> gridMemoryComputer;
  ArrayList<ProbabilityGrid> gridMemoryPlayer;
  ArrayList<Integer> moveMemoryComputer;
  ArrayList<Integer> moveMemoryPlayer;
  int lastComputerMoveMain;
  int lastPlayerMoveMain;
  boolean moveUnrated;
  int startPlayer;
  
  Board board;
  Setup setup;
  
  Game(Setup setup) {
    this.setup = setup;
    this.currState = new State(this.setup);
    this.board = new Board();
    this.gameOver = false;
    this.gameOutcome = -2;
    this.moveUnrated = false;
    this.gridMemoryComputer = new ArrayList<ProbabilityGrid>();
    this.moveMemoryComputer = new ArrayList<Integer>();
    this.gridMemoryPlayer = new ArrayList<ProbabilityGrid>();
    this.moveMemoryPlayer = new ArrayList<Integer>();
    if (this.setup.PLAYER_SWITCH == 1 || (this.setup.PLAYER_SWITCH == 0 && int(random(10)) % 2 == 0)) {
      this.startPlayer = 1;
      this.nextComputerMove();
    }
    else {
      this.startPlayer = -1;
      if (!PLAYER) this.nextComputerPlayerMove();
    }
  }
  
  void nextPlayerMove() {
    if (this.gameOutcome != -2) return;
    int chosenCell = this.board.getHoverCell();
    if (this.currState.getCellValue(chosenCell) != 0) return;
    this.probabilityGridPlayer = new ProbabilityGrid(this.setup, this.currState.getOppositeContentString());
    this.lastPlayerMoveMain = new Cell(chosenCell).getMainPosition(this.probabilityGridPlayer.position).number;
    this.currState.setCell(chosenCell, 1);
    this.checkGameOutcome();
    println("Player Move: " + this.classifyMove(this.probabilityGridPlayer.mainString, this.lastPlayerMoveMain));
    if (this.setup.BCI) this.setup.bciTrigger.send(10 + this.classifyMove(this.probabilityGridPlayer.mainString, this.lastPlayerMoveMain));
    this.gridMemoryPlayer.add(this.probabilityGridPlayer);
    this.moveMemoryPlayer.add(this.lastPlayerMoveMain);
    this.nextComputerMove(); //<>//
  }
  
  /**
    * used to show a preview of where the user is putting his cross
    */
  void hoverBoard() {
    int chosenCell = this.board.getHoverCell();
    if (this.currState.getCellValue(chosenCell) != 0) return;
    this.board.drawCross(chosenCell);
  }
  
  void nextComputerMove() {
    if (this.gameOutcome != -2) return;
    this.currState.setCell(decideNextMove(), 2);
    this.checkGameOutcome();
    println("Comuter Move: " + this.classifyMove(this.probabilityGridComputer.mainString, this.lastComputerMoveMain));
    if (this.setup.BCI) this.setup.bciTrigger.send(this.classifyMove(this.probabilityGridComputer.mainString, this.lastComputerMoveMain));
    this.gridMemoryComputer.add(this.probabilityGridComputer);
    this.moveMemoryComputer.add(this.lastComputerMoveMain);
    this.moveUnrated = true;
    if (!PLAYER) this.nextComputerPlayerMove();
  }
  
  void nextComputerPlayerMove() {
    if (this.gameOutcome != -2) return;
    this.currState.setCell(decideNextMove(-1), 1);
    this.checkGameOutcome();
    println("ComputerPlayer Move: " + this.classifyMove(this.probabilityGridPlayer.mainString, this.lastPlayerMoveMain));
    if (this.setup.BCI) this.setup.bciTrigger.send(this.classifyMove(this.probabilityGridPlayer.mainString, this.lastPlayerMoveMain));
    this.gridMemoryPlayer.add(this.probabilityGridPlayer);
    this.moveMemoryPlayer.add(this.lastPlayerMoveMain);
    this.nextComputerMove();
  }
  
  void rateMoveChain(ArrayList<ProbabilityGrid> gridMemory, ArrayList<Integer> moveMemory, int rate) {
    for (int i = 0; i < moveMemory.size(); i++) {
      this.rateMove(gridMemory.get(i), moveMemory.get(i), rate);
    }
  }
  
  void rateMove(ProbabilityGrid grid, int move, int rate) {
    int rateValue = 0;
    for (int i = 1; i <= abs(rate); i++) {
      rateValue += sq(2*i);
    }
    grid.changeProbabilityValueBy(move, (rate > 0) ? rateValue : -rateValue); //if player likes move move is bad
    
    //  0    1    2    3    4    5    6    7    8    9  
    //——————————————————————————————————————————————————
    //  0    0    4   20   56  120  220  341  537  793
    //  +    +    +    +    +    +    +    +    +    +
    //  0    2^2  4^2  6^2  8^2 10^2 12^2 14^2 16^2 18^2
    //——————————————————————————————————————————————————
    //  0    0    4   20   56  120  220  341  537  793
    //  +    +    +    +    +    +    +    +    +    +
    //  0    4   16   36   64  100  121  196  256  324
    //——————————————————————————————————————————————————
    //  0    4   18   43   76  140  341  537  793 1117
  }
  
  void rateMoveManually(int rate) {
    this.moveUnrated = false;
    this.rateMove(this.probabilityGridComputer, this.lastComputerMoveMain, -rate);
    println("Computer move rated (" + rate + ")!"); //<>//
  }
  
  Cell decideNextMove() {
    return this.decideNextMove(1);
  }
  
  Cell decideNextMove(int player) {
    
    ProbabilityGrid grid;
    if (player == -1) {
      this.probabilityGridPlayer = new ProbabilityGrid(this, this.currState.getOppositeContentString());
      grid = this.probabilityGridPlayer;
      
    }
    else {
      this.probabilityGridComputer = new ProbabilityGrid(this);
      grid = this.probabilityGridComputer;
    }
    
    int random = int(random(this.setup.INITIAL_PROBABILITY_VALUE * grid.zeroCount)); //<>//
    //int saveRandom = random; //delete this after debugging
    int currCellNumber = -1;
    do {
      currCellNumber++;
      int value = grid.probabilities[currCellNumber].value;
      random = random - value;
    } while (0 <= random);
    
    int procentProbability = grid.probabilities[currCellNumber].value*100 / (grid.zeroCount * this.setup.INITIAL_PROBABILITY_VALUE);
    Cell originalCell = new Cell(currCellNumber).getOriginalPosition(grid.position);
    println("Decided for cell " + originalCell.number + ", out of " + grid.zeroCount + " cells, by probability " + procentProbability + "%.");
    //println("(" + currCellNumber + ", " + grid.probabilities[currCellNumber].value + ", " + saveRandom + ", " + random + ")");
    //add to decide between chosen cell and untouched cells
    if (player == -1) this.lastPlayerMoveMain = currCellNumber;
    else this.lastComputerMoveMain = currCellNumber;
    return originalCell;
  }
  
  void checkGameOver() {
    if (this.gameOutcome != -2) {
      this.gameOver = true;
      this.setup.score.addWin(this.gameOutcome);
      if (this.gameOutcome == 0) {
        this.setup.announcements.drawDraw();
        if (this.setup.LEARN) {
          int drawRate = 1;
          rateMove(this.probabilityGridComputer, this.lastComputerMoveMain, -this.startPlayer*drawRate);
          rateMoveChain(this.gridMemoryComputer, this.moveMemoryComputer, -this.startPlayer*drawRate);
          rateMove(this.probabilityGridPlayer, this.lastPlayerMoveMain, this.startPlayer*drawRate);
          rateMoveChain(this.gridMemoryPlayer, this.moveMemoryPlayer, this.startPlayer*drawRate);
        }
      }
      else {
        
        if (this.gameOutcome == -1) this.setup.announcements.drawWin();
        else if (this.gameOutcome == 1) this.setup.announcements.drawDefeat();
        
        if (this.setup.LEARN) {
          int rate = (this.gameOutcome*this.startPlayer < 0) ? 2 : 3;
          rateMoveChain(this.gridMemoryComputer, this.moveMemoryComputer, this.gameOutcome*rate);
          this.probabilityGridComputer.changeProbabilityValueBy(this.lastComputerMoveMain, this.gameOutcome*this.setup.INITIAL_PROBABILITY_VALUE, true); //if computer wins or looses, rate last move ultimatly high
          //println("Computer move rated (" + -this.gameOutcome*this.setup.INITIAL_PROBABILITY_VALUE + ")!");
          //learn from player perspective outcome
          rateMoveChain(this.gridMemoryPlayer, this.moveMemoryPlayer, -this.gameOutcome*rate);
          this.probabilityGridPlayer.changeProbabilityValueBy(this.lastPlayerMoveMain, -this.gameOutcome*this.setup.INITIAL_PROBABILITY_VALUE, true); //if computer wins or looses, rate last move ultimatly high
        }
      }
    }
  }
  
  void checkGameOutcome() {
    JSONObject allStates = loadJSONObject(this.setup.FILENAME);
    String mainString = allStates.getJSONObject(this.currState.getContentString()).getString("main");
    JSONObject main = allStates.getJSONObject(mainString);
    this.gameOutcome = -2;
    if (!main.isNull("gameOver")) this.gameOutcome = main.getInt("gameOver");
  }
  
  /**
   * classifies if a move was bad or good by comparing it to the expert decision file
   * expects the string of the state before the move and the cell index the move was set in
   * 
   * returns a number between 1 and 9
   * 9 if the move was very good
   * 1 if the move war very bad
   **/
  int classifyMove(String lastState, int move) {
    
    ProbabilityGrid grid = new ProbabilityGrid(this.setup.FILENAME_EXPERT, lastState, this.setup.INITIAL_PROBABILITY_VALUE);
    int probability = (grid.probabilities[move].value * 100) / (grid.zeroCount * this.setup.INITIAL_PROBABILITY_VALUE);
    
    if (probability == 0) {
      return 1;
    }
    if (0 < probability && probability <= 14) {
      return 2;
    }
    if (14 < probability && probability <= 28) {
      return 3;
    }
    if (28 < probability && probability <= 42) {
      return 4;
    }
    if (42 < probability && probability <= 56) {
      return 5;
    }
    if (56 < probability && probability <= 70) {
      return 6;
    }
    if (70 < probability && probability <= 84) {
      return 7;
    }
    if (84 < probability && probability <= 98) {
      return 8;
    }
    if (grid.zeroCount != 0 && probability >= 99) {
      return 9;
    }
    return 10;
  }
}
