class Cell {
  
  int row;
  int collum;
  int number;
  int value;
  int probability;
  
  Cell(int number) {
    this.row = number / 3;
    this.collum = number % 3;
    this.number = number;
  }
  
  Cell(int number, int value) {
    this.row = number / 3;
    this.collum = number % 3;
    this.number = number;
    this.value = value;
  }
  
  Cell(int row, int collum, int value) {
    this.row = row;
    this.collum = collum;
    this.number = 3 * row + collum;
    this.value = value;
  }
  
  Cell(int row, int collum, int value, int probability) {
    this.row = row;
    this.collum = collum;
    this.number = 3 * row + collum;
    this.value = value;
    this.probability = probability;
  }
  
  Cell getOriginalPosition(int position) {
    
    if (position == 0) return new Cell(number);
    if (position == 1) return new Cell(3 * (collum) + (row));
    if (position == 2) return new Cell(3 * (row) + (2 - collum));
    if (position == 3) return new Cell(3 * (2 - collum) + (row));
    if (position == 4) return new Cell(3 * (collum) + (2 - row));
    if (position == 5) return new Cell(3 * (2 - row) + (collum));
    if (position == 6) return new Cell(3 * (2 - collum) + (2 - row));
    if (position == 7) return new Cell(3 * (2 - row) + (2 - collum));
    return null;
  }
  
  Cell getMainPosition(int position) {
    
    if (position == 0) return new Cell(number);
    if (position == 1) return new Cell(3 * (collum) + (row));
    if (position == 2) return new Cell(3 * (row) + (2 - collum));
    if (position == 3) return new Cell(3 * (collum) + (2 - row));
    if (position == 4) return new Cell(3 * (2 - collum) + (row));
    if (position == 5) return new Cell(3 * (2 - row) + (collum));
    if (position == 6) return new Cell(3 * (2 - collum) + (2 - row));
    if (position == 7) return new Cell(3 * (2 - row) + (2 - collum));
    return null;
  }
  
  String toString() {
    return str(this.value);
  }
  
  String toOppositeString() {
    //0->0
    if (this.value == 0) return str(0);
    //1->2
    //2->1
    return str(-this.value+3);
  }
}
