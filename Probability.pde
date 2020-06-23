class Probability {

  int votedDown;
  int upValue;
  int downValue;
  int value;
  int votedUp;

  int cellNumber;

  Probability(JSONObject data, int cellNumber) {
    this.votedDown = data.getInt("votedDown");
    this.upValue = data.getInt("upValue");
    this.downValue = data.getInt("downValue");
    this.value = data.getInt("value");
    this.votedUp = data.getInt("votedUp");
    this.cellNumber = cellNumber;
  }

  Probability(int votedDown, int upValue, int downValue, int value, int votedUp) {
    this.votedDown = votedDown;
    this.upValue = upValue;
    this.downValue = downValue;
    this.value = value;
    this.votedUp = votedUp;
    this.cellNumber = -1;
  }
  
  void setProbabilityValue(int value) {
    setProbabilityValueBy(value - this.value);
  }
  
  void setProbabilityValueBy(int change) {
    this.value += change;
    if (change > 0) {
      this.upValue += change;
      this.votedUp ++;
    }
    if (change < 0) {
      this.downValue += change;
      this.votedDown ++;
    }
  }

  JSONObject probabilityJSON() {

    JSONObject data = new JSONObject();
    data.setInt("votedDown", this.votedDown);
    data.setInt("upValue", this.upValue);
    data.setInt("downValue", this.downValue);
    data.setInt("value", this.value);
    data.setInt("votedUp", this.votedUp);

    return data;
  }
}
