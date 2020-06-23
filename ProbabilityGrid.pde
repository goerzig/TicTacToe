class ProbabilityGrid {
  
  String FILENAME;
  int INITIAL_PROBABILITY_VALUE;
  
  Probability[] probabilities;
  String stateString;
  String mainString;
  ArrayList<Cell> untouchedCells;
  int position;
  int zeroCount;
  
  ProbabilityGrid(Game game) {
    this(game.setup.FILENAME, game.currState.getContentString(), game.setup.INITIAL_PROBABILITY_VALUE);
  }
  
  ProbabilityGrid(Setup setup, State state) {
    this(setup.FILENAME, state.getContentString(), setup.INITIAL_PROBABILITY_VALUE);
  }
  
  ProbabilityGrid(String FILENAME, State state,int INITIAL_PROBABILITY_VALUE) {
    this(FILENAME, state.getContentString(), INITIAL_PROBABILITY_VALUE);
  }
  
  ProbabilityGrid(Setup setup, String stateString) {
    this(setup.FILENAME, stateString, setup.INITIAL_PROBABILITY_VALUE);
  }
  
  ProbabilityGrid(Game game, String stateString) {
    this(game.setup.FILENAME, stateString, game.setup.INITIAL_PROBABILITY_VALUE);
  }
  
  ProbabilityGrid(String FILENAME, String stateString, int INITIAL_PROBABILITY_VALUE) {
    this.FILENAME = FILENAME;
    untouchedCells = new ArrayList<Cell>();
    this.stateString = stateString;
    this.INITIAL_PROBABILITY_VALUE = INITIAL_PROBABILITY_VALUE;
    setProbabilities();
  }
  
  void setState(State state) {
    this.stateString = state.getContentString();
    setProbabilities();
  }
  
  void setProbabilities() {
    
    JSONObject states = loadJSONObject(this.FILENAME);
    
    JSONObject stateJSON = states.getJSONObject(this.stateString);
    
    JSONArray probabilitiyData;
    this.position = stateJSON.getInt("position");
    this.mainString = stateJSON.getString("main");
    
    if (position != 0) {
      JSONObject mainStateJSON = states.getJSONObject(this.mainString);
      probabilitiyData = mainStateJSON.getJSONArray("probability");
      this.zeroCount = mainStateJSON.getInt("zeroCount");
    }
    else {
      probabilitiyData = stateJSON.getJSONArray("probability");
      this.zeroCount = stateJSON.getInt("zeroCount");
    }
    
    this.probabilities = new Probability[9];
    
    for (int i = 0; i < 9; i++) {
      this.probabilities[i] = new Probability(probabilitiyData.getJSONObject(i), i);
      if (probabilitiyData.getJSONObject(i).getInt("votedUp") == 0 && probabilitiyData.getJSONObject(i).getInt("votedDown") == 0) {
        untouchedCells.add(new Cell(i));
      }
    }
  }
  
  void changeProbabilityValue(int cell, int value) {
    this.changeProbabilityValueBy(cell, value - this.probabilities[cell].value);
  }
  
  void changeProbabilityValueBy(int cell, int vote) {
    changeProbabilityValueBy(cell, vote, false);
  }
  
  void changeProbabilityValueBy(int cell, int vote, boolean won) {
    //if vote is negative the target cells value could potentially get a negative new value
    //if vote is positive one of the other cells could potentially get a negative new value
    //both should instead be set to 1
    
    int multiplier = 0;
    int offset = 0;
    for (int i = 0; i < 9; i++) {
      if (i == cell) continue;
      if (this.probabilities[i].value == 0) continue;
      //if (this.probabilities[i].value == 1) continue; //should a cell set 1 ever recover ?
      if (won && vote > 0) {
        offset += this.probabilities[i].value;
        this.probabilities[i].value = 0;
      }
      else if (this.probabilities[i].value - vote > 0) this.probabilities[i].value -= vote;
      else {
        offset += vote - this.probabilities[i].value + 1; //wenn nicht der komplette change abgezogen werden kann darf auch nur die Differenz raufgerechnet werden
        this.probabilities[i].value = 1;
      }
      multiplier ++;
    }
    if (multiplier == 0) {
      this.writeProbabilities();
      return;
    }
    int change = vote*multiplier-offset;
    if (won && vote > 0) this.probabilities[cell].setProbabilityValueBy(offset);
    else if (this.probabilities[cell].value + change > 0) this.probabilities[cell].setProbabilityValueBy(change);
    else {
      if (won) offset = this.probabilities[cell].value + change;
      else offset = this.probabilities[cell].value + change - 1;
      int remainder = abs(offset) % multiplier;
      if (won) this.probabilities[cell].setProbabilityValue(0);
      else this.probabilities[cell].setProbabilityValue(1);
      //die restlichen Punkte wieder gleichmäßig verteilen
      for (int i = 0; i < 9; i++) {
        if (i == cell || this.probabilities[i].value == 0) continue;
        //if (this.probabilities[i].value == 1) continue; //should a cell set 1 ever recover ?
        this.probabilities[i].value += offset/multiplier;
        if (remainder > 0) {
          this.probabilities[i].value--;
          remainder--;
        }
      }
    }
    this.writeProbabilities();
  }
  
  void writeProbabilities() {
    
    JSONObject states = loadJSONObject(this.FILENAME);
    
    JSONObject mainStateJSON = states.getJSONObject(this.mainString);
    
    JSONArray probabilitiyData = new JSONArray();
    
    for (int i = 0; i < 9; i++) {
      probabilitiyData.setJSONObject(i, this.probabilities[i].probabilityJSON());
    }
    
    mainStateJSON.setJSONArray("probability", probabilitiyData);
    states.setJSONObject(this.mainString, mainStateJSON);
    saveJSONObject(states, this.FILENAME);
  }
} 
