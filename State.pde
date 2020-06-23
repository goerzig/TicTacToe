class State {
  
  Cell[] content;
  Setup setup;
  int zeroCount;
  
  State(Setup setup) {
    this(setup, "000000000");
  }
  
  State(Setup setup, String contentString) {
    this.setup = setup;
    this.content = new Cell[9];
    this.setContent(contentString);
    setZeroCount();
  }
  
  void setZeroCount() {
    JSONObject states = loadJSONObject(setup.FILENAME);
    JSONObject state = states.getJSONObject(this.getContentString());
    String mainString = state.getString("main");
    if (mainString == null) return; //main states not set up
    JSONObject mainState = states.getJSONObject(mainString);
    this.zeroCount = mainState.getInt("zeroCount");
  }
  
  void setContent(String contentString) {
    for (int i = 0; i < 9; i++) { //<>//
      int cellValue = int(contentString.charAt(i)-48);
      this.content[i] = new Cell(i, cellValue);
    }
  }
  /**
    Always reads value out of last variable
  **/
  void setCell(int cellNumber, int value) {
    this.content[cellNumber] = new Cell(cellNumber, value);
    setZeroCount();
  }
  
  void setCell(Cell cell) {
    this.setCell(cell.number, cell.value);
  }
  
  void setCell(Cell cell, int value) {
    this.setCell(cell.number, value);
  }
  
  void setCell(int row, int collum, int value) {
    this.setCell(row*3+collum, value);
  }
  
  void setCell(int row, int collum, Cell cell) {
    this.setCell(row*3+collum, cell.value);
  }
  
  void setCell(int cellNumber, Cell cell) {
    this.setCell(cellNumber, cell.value);
  }
  
  Cell[] getRow(int row) {
    return new Cell[] {this.getCell(row, 0), this.getCell(row, 1), this.getCell(row, 2)};
  }
  
  Cell[] getCollum(int collum) {
    return new Cell[] {this.getCell(0, collum), this.getCell(1, collum), this.getCell(2, collum)};
  }
  
  int getCellValue(int i) {
    return this.getCell(i).value;
  }
  
  Cell getCell(int i) {
    return this.content[i];
  }
  
  Cell getCell(int row, int collum) {
    return this.getCell(toCellNumber(row, collum));
  }
  
  Cell[] getContentIntArray() {
    return new Cell[] {this.getCell(0,0), this.getCell(0,1), this.getCell(0,2), this.getCell(1,0), this.getCell(1,1), this.getCell(1,2), this.getCell(2,0), this.getCell(2,1), this.getCell(2,2)};
  }
  
  Cell[] getContent() {
    return this.content;
  }
  
  String getContentString() {
    return this.getCell(0,0).toString() + this.getCell(0,1).toString() + this.getCell(0,2).toString() + this.getCell(1,0).toString() + this.getCell(1,1).toString() + this.getCell(1,2).toString() + this.getCell(2,0).toString() + this.getCell(2,1).toString() + this.getCell(2,2).toString(); //<>//
  }
  
  int getContentInt() {
    return int(getContentString());
  }
  
  String getOppositeContentString() {
    return this.getCell(0,0).toOppositeString() + this.getCell(0,1).toOppositeString() + this.getCell(0,2).toOppositeString() + this.getCell(1,0).toOppositeString() + this.getCell(1,1).toOppositeString() + this.getCell(1,2).toOppositeString() + this.getCell(2,0).toOppositeString() + this.getCell(2,1).toOppositeString() + this.getCell(2,2).toOppositeString();
  }
  
  State flipVertical() {
    State state = new State(this.setup);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        state.setCell(i, j, this.getCell(i, -j+2));
      }
    }
    return state;
  }
  
  State flipHorizontal() {
    State state = new State(this.setup);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        state.setCell(i, j, this.getCell(-i+2, j));
      }
    }
    return state;
  }
  
  State flipDiagonalLeftRight() {
    State state = new State(this.setup);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        state.setCell(i, j, this.getCell(j,i));
      }
    }
    return state;
  }
  
  State flipDiagonalRightLeft() {
    State state = new State(this.setup);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        state.setCell(i, j, this.getCell(-j+2,-i+2));
      }
    }
    return state;
  }
  
  State turn90degreesRight() {
    State state = new State(this.setup);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        state.setCell(i, j, this.getCell(-j+2, i));
      }
    }
    return state;
  }
  
  State turn90degreesLeft() {
    State state = new State(this.setup);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        state.setCell(i, j, this.getCell(j, -i+2));
      }
    }
    return state;
  }
  
  State turn180degrees() {
    State state = new State(this.setup);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        state.setCell(i, j, this.getCell(-i+2, -j+2));
      }
    }
    return state;
  }
  
  State[] getEquivalentStates() {
    State[] states = new State[8];
    states[0] = this;
    states[1] = this.flipDiagonalLeftRight();
    states[2] = this.flipVertical();
    states[3] = this.turn90degreesLeft();
    states[4] = this.turn90degreesRight();
    states[5] = this.flipHorizontal();
    states[6] = this.flipDiagonalRightLeft();
    states[7] = this.turn180degrees();
    return states;
  }
  
  String[] getEquivalentStatesStrings() {
    String[] strings = new String[8];
    State[] states = this.getEquivalentStates();
    for (int i = 0; i < 8; i++) {
      strings[i] = states[i].getContentString();
    }
    return strings;
  }
  
  int toCellNumber(int row, int collum) {
    return 3 * row + collum;
  }
}
