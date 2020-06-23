class Board {
  
  int w; //width
  int h; //height
  
  Board() {
    this(600, 600);
  }
  
  Board(int w, int h) {
    this.w = w;
    this.h = h;
    
  }
  
  void drawState(State state) {
    for (int i = 0; i < 9; i++) {
      if (state.getCellValue(i) == 1) drawCross(i);
      if (state.getCellValue(i) == 2) drawCircle(i);
    }
  }
  
  void drawGrid() {
    //upper horizontal line
    line(this.getLeftBorder(), this.getUpperLineHeight(), this.getRightBorder(), this.getUpperLineHeight());
    //down horizontal line);
    line(this.getLeftBorder(), this.getLowerLineHeight(), this.getRightBorder(), this.getLowerLineHeight());
    //left vertical line
    line(this.getLeftLineWidth(), this.getUpperBorder(), this.getLeftLineWidth(), this.getLowerBorder());
    //right vertical line
    line(this.getRightLineWidth(), this.getUpperBorder(), this.getRightLineWidth(), this.getLowerBorder());
  }
  
  void drawCross(int cellNumber) {
    this.drawCross(cellNumber, getCRadius());
  }
  
  void drawCross(int cellNumber, int r) {
    int cW = getCellCenterWidth(cellNumber);
    int cH = getCellCenterHeight(cellNumber);
    this.drawCross(cW - r, cH - r, cW - r, cH + r, cW + r, cH - r, cW + r, cH + r);
  }
  
  void drawCross(int xUL, int yUL, int xLL, int yLL, int xUR, int yUR, int xLR, int yLR) {
    line(xUL, yUL, xLR, yLR);
    line(xLL, yLL, xUR, yUR);
  }
  
  void drawCircle(int cellNumber) {
    this.drawCircle(cellNumber, getCDiameter());
  }
  
  void drawCircle(int cellNumber, int d) {
    ellipse(this.getCellCenterWidth(cellNumber), this.getCellCenterHeight(cellNumber), d, d);
  }
  
  int getHoverCell() {
    int horizontalCell = (mouseX - (width-this.w)/2) / (this.w/3);
    int verticalCell = (mouseY - (height-this.h)/2) / (this.h/3);
    //zwischen center-r und center+r
    return 3 * verticalCell + horizontalCell;
  }
  
  int getCDiameter() {
    return this.w/24*7;
  }
  
  int getCRadius() {
    return getCDiameter()/2;
  }
  
  int getLeftBorder() {
    return width/2 - this.w/2;
  }
  int getRightBorder() {
    return width/2 + this.w/2;
  }
  int getUpperBorder() {
    return height/2 - this.h/2;
  }
  int getLowerBorder() {
    return height/2 + this.h/2;
  }
  int getUpperLineHeight() {
    return height/2 - this.h/6;
  }
  int getLowerLineHeight() {
    return height/2 + this.h/6;
  }
  int getLeftLineWidth() {
    return width/2 - this.w/6;
  }
  int getRightLineWidth() {
    return width/2 + this.w/6;
  }
  int getCellCenterWidth(int cellNumber) {
    if (cellNumber % 3 == 0) return getLeftBorder() + this.w/6;
    if (cellNumber % 3 == 1) return getLeftBorder() + this.w/2;
    if (cellNumber % 3 == 2) return getRightBorder() - this.w/6;
    return -1;
  }
  int getCellCenterHeight(int cellNumber) {
    if (cellNumber / 3 == 0) return getUpperBorder() + this.h/6;
    if (cellNumber / 3 == 1) return getUpperBorder() + this.h/2;
    if (cellNumber / 3 == 2) return getLowerBorder() - this.h/6;
    return -1;
  }
}
