class TetrisGame {

 TetrisGame() {
      //initialize();
  }

  void initialize() {
    level = 1;
    numberOfFullLines = 0;
    dt = 1000;
    currentTime = millis();
    score = new Score();
    grid = new Grid();
    pieces = new Pieces();
    piece = new Piece(-1);
    nextPiece = new Piece(-1);
  }

  void Manage() {
    background(bg);

    textAlign(LEFT);
    if(grid != null) {
      grid.drawGrid();
      int timer = millis();

      if (gameOn) {
        //promjena vremena ide po sekundama, svaku sekundu se spušta oblik
        if (timer - currentTime > dt) {
          currentTime = timer;
          piece.oneStepDown();
        }

      }
      piece.display(false);
      score.display();
      // glazba se ponavlja (loop)
      if (!tetrisPlayer.isPlaying()){
        if (isSoundOn){
          tetrisPlayer.loop();
        }
      }
      
    //puzle ne izlaze iz grida na početnu
    noStroke();
    fill(bg);
    rect(200,0,sizeOfCube*w,40);
    }
    if (gameOver) {
        noStroke();
        fill(255, 60);
        rect(200, 260, 240, 2*txtSize, 3);
        fill(textColor);
        text("Game Over", 225, 290);

        // pauziranje glazbe
        tetrisPlayer.pause();
        tetrisPlayer.rewind();
      }
      if (!gameOn) {
        noStroke();
        fill(255, 60);
        rect(200, 190, 500, 2*txtSize, 3);
        textAlign(LEFT);
        textSize(txtSize / 2);
        fill(textColor);
        text("Press SPACE to start playing!", 210, 220);
      }
  }
      

  void KeyPressed(int k) {
      if (k == BACKSPACE){

        tetrisPlayer.pause();
        tetrisPlayer.rewind();
        if (!looping) {
          loop();
        }
        selectedItem = -1;
        gameOn = false;
        gameOver = false;
        grid = null;
      }
      

      
      if (k == CODED && gameOn) {
        switch(keyCode) {
        case LEFT:
        case RIGHT:
        case DOWN:
        case UP:
          piece.inputKey(keyCode);
          break;
        }
      } else if (key == ' ' && gameOn){
          piece.inputKey(keyCode);
      //} else if (keyCode == 83) {// "s"
      } else if (key == ' ' && !gameOn) {// "s"
        initialize();
        gameOver = false;
        gameOn = true;
      } else if (keyCode == 80) {// "p"
          if(gameOn) {
            if(looping) {
            noStroke();
            fill(255, 60);
            rect(200, 190, 500, 2*txtSize, 3);
            fill(textColor);
            textSize(16);
            textAlign(LEFT);
            text("Press P to resume playing!", 210, 220);
            tetrisPlayer.pause();
            noLoop();
            }
            else {
              loop();
              if (isSoundOn){
                tetrisPlayer.loop();
              }
            }
          }
      }
      else if (k == 'r') {
          gameOn = false;
          gameOver = false;
          grid = null;
          tetrisPlayer.rewind();
      }
  }
}
