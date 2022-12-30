class Piece {
  final color[] colors = {
    color(128, 12, 128), //purple
    color(230, 12, 12), //red
    color(12, 230, 12), //green
    color(9, 239, 230), //cyan
    color(230, 230, 9), //yellow
    color(230, 128, 9), //orange
    color(12, 12, 230) //blue
  };

  // [rotation][block nb][x or y]
  final int[][][] pos;
  int x = int(w/2);
  int y = 0;
  int kind;
  int c;

  Piece(int k) {
    kind = k < 0 ? int(random(0, 7)) : k;
    c = colors[kind];
    rotation = 0;
    pos = pieces.pos[kind];
  }

  void display(Boolean still) {
    stroke(250);
    fill(c);
    pushMatrix();
    if (!still) {
      translate(200, 40);
      translate(x*sizeOfCube, y*sizeOfCube);
    }
    int rot = still ? 0 : rotation;
    for (int i = 0; i < 4; i++) {
      image(figures[kind], pos[rot][i][0] * sizeOfCube, pos[rot][i][1] * sizeOfCube, sizeOfCube, sizeOfCube);
    }
    popMatrix();
  }

  // goes down if can else piece is added to grid
  void oneStepDown() {
    y += 1;
    if(!grid.pieceFits()){
      piece.y -= 1;
      grid.addPieceToGrid();
    }
  }
  //go one step left
  void oneStepLeft() {
    x -= 1;
  }

  //go one step right
  void oneStepRight() {
    x += 1;
  }

  void goToBottom() {
    grid.setToBottom();
  }

  void inputKey(int k) {
    switch(k) {
    case LEFT:
      oneStepLeft();
      if(grid.pieceFits()){
      } else {
         oneStepRight();
      }
      break;
    case RIGHT:
      oneStepRight();
      if(grid.pieceFits()){
      } else {
         oneStepLeft();
      }
      break;
    case DOWN:
      oneStepDown();
      break;
    case UP:
      rotation = (rotation+1)%4;
      if(!grid.pieceFits()){
         rotation = rotation-1 < 0 ? 3 : rotation-1;
         //soundRotationFail();
      } else {
        //soundRotation();
      }
      break;
    case ' ':
      goToBottom();
      break;
    }
  }
}
