class Grid {
  int [][] cells = new int[w][h];

  Grid() {
    for (int i = 0; i < w; i ++)
      for (int j = 0; j < h; j ++)
        cells[i][j] = 0;
  }

  void goToNextPiece() {
    //nextPiece je globalna varijabla, u init je postavljena na random piece
    piece = new Piece(nextPiece.kind);
    nextPiece = new Piece(-1);
    rotation = 0;
  }

  void goToNextLevel() {
    score.addLevelPoints();
    level = 1 + int(numberOfFullLines / 10);
    //sa svakim levelom idu kockice još malo brže :)
    dt *= .8;
  }

  int ColorToInt(color c){
    if (c == color(128, 12, 128))
        return 0;
    else if (c == color(230, 12, 12)) //red
        return 1;
    else if (c == color(12, 230, 12)) //green
        return 2;
    else if (c == color(9, 239, 230)) //cyan
        return 3;
    else if (c == color(230, 230, 9)) //yellow
        return 4;
    else if (c == color(230, 128, 9)) //orange
        return 5;
    else if (c == color(12, 12, 230)) //blue
        return 6;
    else
      return -1;
  }

  Boolean isFree(int x, int y) {
    if (x > -1 && x < w && y > -1 && y < h)
      return cells[x][y] == 0;
    else if (y < 0)
      return true;
    //println("WARNING: trying to access out of bond cell, x: "+x+" y: "+y);
    return false;
  }

  Boolean pieceFits() {
    int x = piece.x;
    int y = piece.y;
    int[][][] pos = piece.pos;
    Boolean pieceOneStepDownOk = true;
    for (int i = 0; i < 4; i ++) {
      int tmpx = pos[rotation][i][0]+x;
      int tmpy = pos[rotation][i][1]+y;
      if (tmpy >= h || !isFree(tmpx, tmpy)) {
        pieceOneStepDownOk = false;
        break;
      }
    }
    return pieceOneStepDownOk;
  }

  void addPieceToGrid() {
    int x = piece.x;
    int y = piece.y;
    //println("addPieceToGrid x: "+x+" y: "+y);
    int[][][] pos = piece.pos;
    for (int i = 0; i < 4; i ++) {
      if(pos[rotation][i][1]+y >= 0){
        cells[pos[rotation][i][0]+x][pos[rotation][i][1]+y] = piece.c;
      }else{
        gameOn = false;
        gameOver = true;
        //println("game over");
        return;
      }
    }
    score.addPiecePoints();
    checkFullLines();
    goToNextPiece();
    drawGrid();
  }

  //check for full lines and delete them
  void checkFullLines() {
    int nb = 0; //number of full lines
    for (int j = 0; j < h; j ++) {
      Boolean fullLine = true;
      for (int i = 0; i < w; i++) {
        fullLine = cells[i][j] != 0;
        if (!fullLine)
          break;
      }
      // this jth line if full, delete it
      if (fullLine) {
        nb++;
        for (int k = j; k > 0; k--) {
          for (int i = 0; i < w; i++)
            cells[i][k] = cells[i][k-1];
        }
        // top line will be empty
        for (int i = 0; i < w; i++) {
          cells[i][0] = 0;
        }
      }
    }
    checkLevelAddPoints(nb);
  }

  void checkLevelAddPoints(int nb) {
    //println("deleted lines: "+nb);
    numberOfFullLines += nb;
    if (int(numberOfFullLines / 10) > level-1) {
      goToNextLevel();
    }
    score.addLinePoints(nb);
  }

  void setToBottom() {
    //int originalY = piece.y;
    int j = 0;
    for (j = 0; j < h; j ++) {
      if (!pieceFits())
        break;
      else
        piece.y++;
    }
    piece.y--;
    addPieceToGrid();
  }

  void drawGrid() {
    stroke(120);
    pushMatrix();
    translate(200, 40);
    for (int i = 0; i <= w; i ++)
      line(i*sizeOfCube, 0, i*sizeOfCube, h*sizeOfCube);
    for (int j = 0; j <= h; j ++)
      line(0, j*sizeOfCube, w*sizeOfCube, j*sizeOfCube);

    stroke(80);
    for (int i = 0; i < w; i ++) {
      for (int j = 0; j < h; j ++) {
        if (cells[i][j] != 0) {
          image(figures[ColorToInt(cells[i][j])], i*sizeOfCube, j*sizeOfCube, sizeOfCube, sizeOfCube);
        }
      }
    }
    popMatrix();
  }
}
