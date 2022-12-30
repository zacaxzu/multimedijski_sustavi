class MazeGame {
  MazeGame () {
      _state = state_init;

       int p = int (random(1,6));
       //veći p = lakši labirint (u smislu glađih zidova)

      _maze = new Maze(broj_kvadrata_y, broj_kvadrata_x , p);
      _maze.compute ();
  }

  void Reset () {
    _state = state_init;

     int p = int (random(1,6));
     //veći p = lakši labirint (u smislu glađih zidova)

    _maze = new Maze(broj_kvadrata_y, broj_kvadrata_x , p);
    _maze.compute ();
    _maze.show (velicina_kvadrata);

    _needToRedraw = true;

    _startTime = 0;
    _endTime = 0;

    ClearTextArea();

    textAlign(CENTER);
    fill(black);
    text("Press SPACE to start", sirina / 2, pocetak_teksta_y);
  }

  int getState() {
    return _state;
  }

  void Start() {
   if (_state == state_init) {
     Run();

     // glazba se ponavlja (loop)
     if (!mazePlayer.isPlaying()){
       if (isSoundOn){
         mazePlayer.loop();
       }
     }
     return;
   }
  }

  void Move () {
    if (_state == state_run) {
      if (keyCode == LEFT) _maze.goLeft();
      else if (keyCode == RIGHT) _maze.goRight();
      else if (keyCode == DOWN) _maze.goDown();
      else if (keyCode == UP) _maze.goUp();
    }
  }

  void Run() {
    _state = state_run;
    _startTime = millis();

    // Clear and draw score
    ClearTextArea();
  }

  void End() {
    _state = state_end;
    _endTime = millis();

    ClearTextArea();

    textAlign(CENTER);
    fill(black);
    text("FINISHED in",sirina / 2, pocetak_teksta_y);
    int delta = (_endTime - _startTime) / 1000;
    int m = delta / 60;
    int s = (delta - m*60);
    String ti = "Time : " + m + "'" + s + "\"";
    text(ti ,sirina / 2, pocetak_teksta_y + tekst_pomak);
    String p = "Current : " + _maze.getStep() + " steps";
    text(p , sirina / 2, pocetak_teksta_y + 2*tekst_pomak);
    String d = "Best : " + _maze.getMaxDistance () + " steps";
    text(d , sirina / 2, pocetak_teksta_y + 3*tekst_pomak);

    // pauziranje pozadinske glazbe
    mazePlayer.pause();
    mazePlayer.rewind();
    // pobjednička glazba
    if (isSoundOn){
      mazePlayer_win.play();
      mazePlayer_win.rewind();
    }
  }

  void ClearTextArea () {
    fill (white);
    rect(0, velicina_kvadrata * broj_kvadrata_y ,broj_kvadrata_x * velicina_kvadrata , dim_tekst_okvira);
  }

  void KeyPressed (int k) {
    if ( (k == 'r') || (_state == state_run && k == ' ') ) // Resetting game
      Reset();
    if (k == ' ') Start(); // Start
    if (k == ESC){ // return to menu
      this.Reset();
      mazePlayer.pause();
      mazePlayer.rewind();
      selectedItem = -1;
    } 
    Move();
  }

  void Manage() {
    if (_state == state_run) {
      if (_maze.AtEnd()) End();
      else { // Updating current time
        fill (white);
        rect(0, velicina_kvadrata * broj_kvadrata_y ,broj_kvadrata_x * velicina_kvadrata , dim_tekst_okvira);
        fill (black);
        int delta = (millis() - _startTime) / 1000;
        int m = delta / 60;
        int s = (delta - m*60);
        String ti = "Time : " + m + "'" + s + "\"";
        text(ti ,sirina / 2, pocetak_teksta_y + tekst_pomak-30);
      }
    }
 }

    int _state;
    boolean _needToRedraw;

    int _startTime;
    int _endTime;

    Maze _maze;
};
