class Setup {
  
  String FILENAME = "data/states.json";
  String FILENAME_EXPERT = "data/states_expert.json";
  int INITIAL_PROBABILITY_VALUE = 1000;
  int BOARD_SIZE = 600;
  int TEXT_SIZE = 150;
  int PLAYER_SWITCH = 0;
  boolean PLAYER;
  boolean LEARN;
  boolean BCI;
  
  Announcements announcements;
  Score score;
  BCITrigger bciTrigger;
  
  Setup() {
    this(null, null, -1, -1, -1, 0, true, false, false);
  }
  
  Setup(String FILENAME) {
    this(FILENAME, null, -1, -1, -1, 0, true, false, false);
  }
  
  Setup(String FILENAME, int INITIAL_PROBABILITY_VALUE) {
    this(FILENAME, null, INITIAL_PROBABILITY_VALUE, -1, -1, 0, true, false, false);
  }
  
  Setup(String FILENAME, int INITIAL_PROBABILITY_VALUE, int BOARD_SIZE) {
    this(FILENAME, null, INITIAL_PROBABILITY_VALUE, BOARD_SIZE, -1, 0, true, false, false);
  }
  
  Setup(String FILENAME, String FILENAME_EXPERT, int INITIAL_PROBABILITY_VALUE, int BOARD_SIZE, int TEXT_SIZE, int PLAYER_SWITCH, boolean PLAYER, boolean LEARN, boolean BCI) {
    if (FILENAME != null) this.FILENAME = FILENAME;
    if (FILENAME_EXPERT != null)this.FILENAME_EXPERT = FILENAME_EXPERT;
    if (INITIAL_PROBABILITY_VALUE != -1) this.INITIAL_PROBABILITY_VALUE = INITIAL_PROBABILITY_VALUE;
    if (BOARD_SIZE != -1) this.BOARD_SIZE = BOARD_SIZE;
    if (TEXT_SIZE != -1) this.TEXT_SIZE = TEXT_SIZE;
    this.PLAYER_SWITCH = PLAYER_SWITCH;
    this.PLAYER = PLAYER;
    this.LEARN = LEARN;
    this.BCI = BCI;
    
    if (this.BCI) this.bciTrigger = new BCITrigger();
    
    this.announcements = new Announcements(this, this.TEXT_SIZE);
    this.score = new Score();
  }
  
  void setupFile() {
    this.setupJSONFile();
    this.setupMainStates();
    this.setupGameOver();
  }
  
  Game setupNewGame() {
    return new Game(this);
  }
  
  void setupJSONFile() {
    
    JSONObject states = new JSONObject();
    
    for (int i0=0; i0<3; i0++) {
      for (int i1=0; i1<3; i1++) {
        for (int i2=0; i2<3; i2++) {
          for (int i3=0; i3<3; i3++) {
            for (int i4=0; i4<3; i4++) {
              for (int i5=0; i5<3; i5++) {
                for (int i6=0; i6<3; i6++) {
                  for (int i7=0; i7<3; i7++) {
                    for (int i8=0; i8<3; i8++) {
                      
                      JSONObject state = new JSONObject();
                      
                      String id = str(i0)+str(i1)+str(i2)+str(i3)+str(i4)+str(i5)+str(i6)+str(i7)+str(i8);
                      state.setString("main", null);
                      state.setJSONArray("probabilities", null);
                      
                      states.setJSONObject(id, state);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    //JSONObject json = new JSONObject();
    //json.setJSONObject("states", states);
    saveJSONObject(states, FILENAME);
    println("created JSON file");
  }
  
  void setupMainStates() {
    
    JSONObject allStatesJSON = loadJSONObject(this.FILENAME);
    
    //for (int i = 0; i < statesJSON.size(); i++) {
    //for (JSONObject j : statesJSON) {
    Iterator keys = allStatesJSON.keyIterator();
    //print(allStatesJSON.size());
    //int count = 0;
    while (keys.hasNext()) {
      String mainStateString = (String) keys.next();
      JSONObject mainStateJSON = allStatesJSON.getJSONObject(mainStateString);
      if (mainStateJSON.getString("main") != null) continue;
      
      mainStateJSON = setInitialStateProbability(mainStateJSON, mainStateString);
      State state = new State(this, mainStateString);
      String[] subStateStrings = state.getEquivalentStatesStrings();
      ArrayList<Integer> sameStrings = new ArrayList<Integer>();
      
      for (int i = 0; i < 8; i++) {
        
        JSONObject subStateJSON = allStatesJSON.getJSONObject(subStateStrings[i]);
        if (subStateJSON.getString("main") != null) {
          if (subStateStrings[i].equals(mainStateString)) sameStrings.add(i);
          continue;
        }
        subStateJSON.setString("main", mainStateString);
        subStateJSON.setInt("position", i);
        
        allStatesJSON.setJSONObject(subStateStrings[i], subStateJSON);     
      }
      //println(mainStateString + " " + sameStrings);
      if (!sameStrings.isEmpty()) {
        if (mainStateString.equals("000000000")) println(mainStateJSON.getInt("zeroCount"));
        mainStateJSON = removeSameProbabilities(mainStateJSON, sameStrings);
        if (mainStateString.equals("000000000")) println(mainStateJSON.getInt("zeroCount"));
      }
      //count++;
      //println(count);
    }
    //println("9");
    saveJSONObject(allStatesJSON, this.FILENAME);
    println("main states set up");
  }
  
  JSONObject removeSameProbabilities(JSONObject mainStateJSON, ArrayList<Integer> sameStrings) {
    JSONArray probabilities = mainStateJSON.getJSONArray("probability");
    
    JSONObject prob2 = probabilities.getJSONObject(2);
    JSONObject prob3 = probabilities.getJSONObject(3);
    JSONObject prob5 = probabilities.getJSONObject(5);
    JSONObject prob6 = probabilities.getJSONObject(6);
    JSONObject prob7 = probabilities.getJSONObject(7);
    JSONObject prob8 = probabilities.getJSONObject(8);
    
    int zeroCount = mainStateJSON.getInt("zeroCount");
    
    if (sameStrings.contains(3) || sameStrings.contains(4)) {
      prob2.setInt("value", 0);
      prob3.setInt("value", 0);
      prob5.setInt("value", 0);
      prob6.setInt("value", 0);
      prob7.setInt("value", 0);
      prob8.setInt("value", 0);
      //println(mainStateJSON.getInt("zeroCount"));
      //4 -> 1 |((2*4) % 9) + 1 = (8  / 9) + 1 = 0 + 1 = 1
      //5 -> 2 |((2*5) % 9) + 1 = (10 / 9) + 1 = 1 + 1 = 2
      //8 -> 2 |((2*8) % 9) + 1 = (16 / 9) + 1 = 1 + 1 = 2
      //9 -> 3 |((2*9) % 9) + 1 = (18 / 9) + 1 = 2 + 1 = 3
      zeroCount = (zeroCount*2 / 9) + 1;
    }
    else if (sameStrings.contains(7)) {
      prob5.setInt("value", 0);
      prob6.setInt("value", 0);
      prob7.setInt("value", 0);
      prob8.setInt("value", 0);
      //println(mainStateJSON.getInt("zeroCount"));
      zeroCount = (zeroCount % 2) + (zeroCount / 2);
      //if it's also flippable vertically
      if (sameStrings.contains(2) || sameStrings.contains(5)) {
        if (prob2.getInt("value") != 0) {
          zeroCount --;
          prob2.setInt("value", 0);
        }
      }
      //if it's also flippable diagonally
      if (sameStrings.contains(1) || sameStrings.contains(6)) {
        if (prob3.getInt("value") != 0) {
          zeroCount --;
          prob3.setInt("value", 0);
        }
      }
    }
    else if (sameStrings.contains(1)) {
      if (prob3.getInt("value") != 0) {
          zeroCount --;
          prob3.setInt("value", 0);
      }
      if (prob6.getInt("value") != 0) {
          zeroCount --;
          prob6.setInt("value", 0);
      }
      if (prob7.getInt("value") != 0) {
          zeroCount --;
          prob7.setInt("value", 0);
      }
      
    }
    else if (sameStrings.contains(2)) {
      if (prob2.getInt("value") != 0) {
        zeroCount --;
        prob2.setInt("value", 0);
      }
      if (prob5.getInt("value") != 0) {
        zeroCount --;
        prob5.setInt("value", 0);
      }
      if (prob8.getInt("value") != 0) {
          zeroCount --;
          prob8.setInt("value", 0);
      }
    }
    else if (sameStrings.contains(5)) {
      if (prob6.getInt("value") != 0) {
          zeroCount --;
          prob6.setInt("value", 0);
      }
      if (prob7.getInt("value") != 0) {
          zeroCount --;
          prob7.setInt("value", 0);
      }
      if (prob8.getInt("value") != 0) {
          zeroCount --;
          prob8.setInt("value", 0);
      }
    }
    else if (sameStrings.contains(6)) {
      if (prob5.getInt("value") != 0) {
        zeroCount --;
        prob5.setInt("value", 0);
      }
      if (prob7.getInt("value") != 0) {
          zeroCount --;
          prob7.setInt("value", 0);
      }
      if (prob8.getInt("value") != 0) {
          zeroCount --;
          prob8.setInt("value", 0);
      }
      //println(mainStateJSON.getInt("zeroCount"));
    }
    mainStateJSON.setInt("zeroCount", zeroCount);
    return mainStateJSON;
  }
  
  JSONObject setInitialStateProbability(JSONObject stateJSON, String stateString) {
    
    JSONArray probability = new JSONArray();
    
    int zeroCount = 0;
    for (int i = 0; i < stateString.length(); i++) {
      int value = stateString.charAt(i) - 48;
      if (value == 0) zeroCount++;
      probability.setJSONObject(i, initialCellProbability(value));
    }
    stateJSON.setJSONArray("probability", probability);
    stateJSON.setInt("zeroCount", zeroCount);
    if (zeroCount == 0) stateJSON.setInt("gameOver", 0);
    return stateJSON;
  } 
  
  JSONObject initialCellProbability(int free) {
    int probabilityValue = free == 0 ? this.INITIAL_PROBABILITY_VALUE : 0;
    return new Probability(0, 0, 0, probabilityValue, 0).probabilityJSON();
  }
  
  void setupGameOver() {
    
    JSONObject allStatesJSON = loadJSONObject(FILENAME);
  
    int[][] allWinIndices = {{0, 4, 8},{0, 1, 2},{3, 4, 5}};
    
    for (int iW = 0; iW < 3; iW++) { //iW: indexWin
      for (int iT = 1; iT < 3; iT++) { //iT: indexTurn
        int s0 = allWinIndices[iW][0] != 0 ? 0 : iT; //start zero index
        int e0 = allWinIndices[iW][0] != 0 ? 3 : iT+1; //end zero index
        int s1 = allWinIndices[iW][1] != 1 ? 0 : iT; //start one index
        int e1 = allWinIndices[iW][1] != 1 ? 3 : iT+1; //end one index
        int s2 = allWinIndices[iW][2] != 2 ? 0 : iT; //start two index
        int e2 = allWinIndices[iW][2] != 2 ? 3 : iT+1; //end two index
        int s3 = allWinIndices[iW][0] != 3 ? 0 : iT; //start three index
        int e3 = allWinIndices[iW][0] != 3 ? 3 : iT+1; //end three index
        int s4 = allWinIndices[iW][1] != 4 ? 0 : iT; //start four index
        int e4 = allWinIndices[iW][1] != 4 ? 3 : iT+1; //end four index
        int s5 = allWinIndices[iW][2] != 5 ? 0 : iT; //start five index
        int e5 = allWinIndices[iW][2] != 5 ? 3 : iT+1; //end frive index
        int s8 = allWinIndices[iW][2] != 8 ? 0 : iT; //starte eight index
        int e8 = allWinIndices[iW][2] != 8 ? 3 : iT+1; //end eight index
        for (int i0=s0; i0<e0; i0++) {
          for (int i1=s1; i1<e1; i1++) {
            for (int i2=s2; i2<e2; i2++) {
              for (int i3=s3; i3<e3; i3++) {
                for (int i4=s4; i4<e4; i4++) {
                  for (int i5=s5; i5<e5; i5++) {
                    for (int i6=0; i6<3; i6++) {
                      for (int i7=0; i7<3; i7++) {
                        for (int i8=s8; i8<e8; i8++) {
                           String id = str(i0)+str(i1)+str(i2)+str(i3)+str(i4)+str(i5)+str(i6)+str(i7)+str(i8);
                           allStatesJSON.getJSONObject(allStatesJSON.getJSONObject(id).getString("main")).setInt("gameOver", iT == 1 ? -1 : 1);
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    
    saveJSONObject(allStatesJSON, this.FILENAME);
    println("game over set up");
  }
}
