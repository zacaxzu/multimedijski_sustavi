class Score {
  int points = 0;

  //20 bodova po liniji, ako odjednom srušiš 4 i više linija dobivaš 200 bodova - kakti combo -->uvijek puta level
  void addLinePoints(int nb) {
    if (nb == 4) {
      points += level * 10 * 20;
    } else {
      points += level * nb * 20;
    }
  }

  //5 bodova po obliku skalarno po levelima, 5,10,5.....
  void addPiecePoints() {
    points += level * 5;
  }

  //100 bodova po levelu puta level
  void addLevelPoints() {
    points += level * 100;
  }

  void display() {
    pushMatrix();
    translate(40, 60);

    textAlign(LEFT);
    //score
    fill(textColor);
    text("score: ", 0, 0);
    fill(230, 230, 12);
    text(""+formatPoint(points), 0, txtSize);

    //level
    fill(textColor);
    text("level: ", 0, 3*txtSize);
    fill(230, 230, 12);
    text("" + level, 0, 4*txtSize);

    //lines
    fill(textColor);
    text("lines: ", 0, 6*txtSize);
    fill(230, 230, 12);
    text("" + numberOfFullLines, 0, 7*txtSize);
    popMatrix();

    pushMatrix();
    translate(600, 60);

    //score
    fill(textColor);
    text("next: ", 0, 0);

    translate(1.2*sizeOfCube, 1.5*sizeOfCube);
    nextPiece.display(true);
    popMatrix();
  }

  String formatPoint(int p) {
    String txt = "";
    int temp = int(p/1000000);
    if (temp > 0) {
      txt += temp + ".";
      p -= temp * 1000000;
    }

    temp = int(p/1000);
    if (txt != "") {
      if (temp == 0) {
        txt += "000";
      } else if (temp < 10) {
        txt += "00";
      } else if (temp < 100) {
        txt += "0";
      }
    }
    if (temp > 0) {
      txt += temp;
      p -= temp * 1000;
    }
    if (txt != "") {
      txt += ".";
    }

    if (txt != "") {
      if (p == 0)
        txt += "000";
      else if (p < 10)
        txt += "00" + p;
      else if (p < 100)
        txt += "0" + p;
      else
        txt += p;
    }
    else
      txt += p;

    return txt;
  }
}
