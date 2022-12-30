
import ddf.minim.*;

int WALL=0;
int BORDER=1;
int PAS=2;


color white = color (0xFF, 0xFF, 0xFF);
color blue = color (0x00, 0x00, 0xFF);
color red = color (0xFF, 0x00, 0x00);
color gray = color (0x80, 0x80, 0x80);
color green = color (0x00, 0xFF, 0x00);
color black = color (0x00, 0x00, 0x00);

int w = 12;
int h = 25;
int sizeOfCube = 30;
int dt; // delay between each move
int currentTime;
Grid grid;
Piece piece;
Piece nextPiece;
Pieces pieces;
Score score;
int rotation = 0;//rotation status, from 0 to 3
int level = 1;
int numberOfFullLines = 0;

int txtSize = 25;
int textColor = color(34, 230, 190);

Boolean gameOver = false;
Boolean gameOn = false;
Boolean isSoundOn = true;


int state_init = 0;
int state_run = 1;
int state_end = 2;

int velicina_kvadrata = 20;
int broj_kvadrata_x = 40;
int broj_kvadrata_y = 35;
int dim_tekst_okvira = 100;
int tekst_pomak = dim_tekst_okvira / 4;
int sirina = 800;
int pocetak_teksta_y = (broj_kvadrata_y + 2) * velicina_kvadrata;

String[] figureNames = {"figure-one.png"
        ,"figure-two.png"
        ,"figure-three.png"
        ,"figure-four.png"
        ,"figure-five.png"
        ,"figure-six.png"
        ,"figure-seven.png"};
// elementi polja su sličice koje predstavljaju kvadratić n-te figurice
PImage[] figures = new PImage[figureNames.length];

Menu mainMenu;
MazeGame mazeGame;
TetrisGame tetrisGame;

PImage menu_background;
PImage icon_speaker;
PImage icon_muted;
int selectedItem=100;
PFont font;
Button muteButton;

Minim minim;
AudioPlayer tetrisPlayer;
AudioPlayer mazePlayer;
AudioPlayer mazePlayer_win;
String music_maze = "theme_music_maze.mp3";
String music_maze_win = "music_maze_win.mp3";
String music_tetris = "theme_music.mp3";
String menu_background_path = "menu_background.jpg";
String icon_speaker_path = "icon_speaker.png";
String icon_muted_path = "icon_muted.png";

color bg;


void setup(){
  size(800, 800, P2D);
  smooth(4);
  // images loading
  icon_speaker = loadImage(icon_speaker_path);
  icon_muted = loadImage(icon_muted_path);
  menu_background = loadImage(menu_background_path);
  for (int i = 0; i < figureNames.length; ++i){
    figures[i] = loadImage(figureNames[i]);
  }
  // konstruktor: Menu(int textSize, PImage background)
  mainMenu = new Menu(22, menu_background);
  // dodavanje Menu itema
  mainMenu.AddMenuItem("Tetris");
  mainMenu.AddMenuItem("Pravila tetrisa");
  mainMenu.AddMenuItem("Labirint");
  mainMenu.AddMenuItem("Pravila labirinta");
  // dodavanje Sound gumba
  muteButton = new Button(width - 1 * mainMenu.GetItemHeight()
    , height - 1 * mainMenu.GetItemHeight()
    , mainMenu.GetItemHeight()
    , mainMenu.GetItemHeight()
    , icon_speaker
    , icon_muted
    );
  mainMenu.AddButton(muteButton);

  tetrisGame = new TetrisGame();
  mazeGame = new MazeGame ();

  // sound loading
  minim = new Minim(this);
  mazePlayer = minim.loadFile(music_maze);
  mazePlayer_win = minim.loadFile(music_maze_win);
  tetrisPlayer = minim.loadFile(music_tetris);
  
  bg = color(60);

  font = createFont("Arial",20,true);  // Loading font
  textFont(font);
  background(white);
  noFill();
  noStroke ();
}

void draw(){
  PFont f;
  f = createFont("Calibri", 20, true);
  String pravila;
  String naslov;
  switch(selectedItem){
    case 0:
      // pokreni tetris
      textSize(txtSize);
      tetrisGame.Manage();
      break;
    case 1:
      // pravila tetrisa
       background(#00BFA5);
       naslov = "Pravila tetrisa: ";
       pravila = "Dijelovi koji se sastoje od četiri kvadratića padaju s vrha ekrana. "
                 + "Igrač ih može \nrotirati i slagati na način da između dijelova ne ostaje prazan prostor.\n"

                 + "Rotacija se obavlja strelicom prema GORE, a pomicanje ulijevo ili udesno \nstrelicom LIJEVO odnosno DESNO.\n"
                 + "Padanje dijelova može se ubrzati pritiskom na strelicu prema DOLJE \nili pritiskom na tipku SPACE.\n"
                 + "Cilj igre je popuniti cijeli redak čime taj redak nestaje i igrač dobiva bodove.\n"
                 + "Igra prestaje kada više nema mjesta za nove figurice\n\n"
                 + "Tipke:\n"
                 + "-> Za početak igre pritisnite SPACE.\n"
                 + "-> Za ponovno iscrtavanje pritisnite R.\n"
                 + "-> Za pauziranje igre pritisnite P.\n"
                 //+ "-> Za povratak u glavni izbornik pritisnite ESCAPE.\n"

                 //+ "Rotacija se obavlja strelicom prema gore, a pomicanje ulijevo ili udesno \n strelicom ulijevo odnosno udesno.\n"
                 //+ "Padanje dijelova može se ubrzati pritiskom na strelicu prema dolje \n ili pritiskom na tipku 'shift'.\n"
                 //+ "Cilj igre je ne dozvoliti da se popuni cijelo polje za igru\n bez mogućnosti da se pojavi novi dio.\n"
                 //+ "-> Za početak igre pritisnite 's'.\n"
                 //+ "-> Za ponovno iscrtavanje pritisnite 'r'.\n"
                 //+ "-> Za pauziranje igre pritisnite 'p'.\n"
                 + "-> Za povratak u glavni izbornik pritisnite 'BACKSPACE'.\n"

                 + "\nSretno!";
      textAlign(LEFT);
      textFont(f, 40);
      fill(0);
      text(naslov, 30, 70);
      textFont(f, 23);
      fill(0);
      text(pravila, 30, 120);
      break;
    case 2:
      // pokreni labirint
      //colorMode(RGB, height, height, height);
      if (mazeGame.getState() == state_init) {
        mazeGame._maze.show(velicina_kvadrata);
        mazeGame._needToRedraw = true;

        mazeGame._startTime = 0;
        mazeGame._endTime = 0;

        mazeGame.ClearTextArea();

        textAlign(CENTER);
        fill(black);
        text("Press SPACE to start", sirina / 2, pocetak_teksta_y);
        textAlign(LEFT);
      }
      mazeGame.Manage();
      break;
    case 3:
      // pravila labirinta
      background(#00BFA5);
      naslov = "Pravila labirinta: ";
      pravila= "Labirint je igra u kojoj je cilj doći od početne točke (crvena) \ndo krajnje (zelena).\n"
                + "Igrač se po labirintu pomiče pomoću strelica.\n"
                + "Gore, dolje, lijevo i desno.\n\n"
                + "Tipke:\n"
                + "-> Za početak igre pritisnite SPACE. \n"
                + "-> Za ponovno iscrtavanje pritisnite R ili SPACE. \n"
                + "-> Za povratak u glavni izbornik iz pritisnite ESCAPE. \n\n"
                + "Sretno!";
      textAlign(LEFT);
      textFont(f, 40);
      fill(0);
      text(naslov, 30, 70);
      textFont(f, 30);
      fill(0);
      text(pravila, 25, 120);
      break;
    default:
      mainMenu.Display();
      break;
  }
}

 
int [][] dirset = {
    { 1, 2, 3, 4},
    { 1, 2, 4, 3},
    { 1, 3, 2, 4},
    { 1, 3, 4, 2},
    { 1, 4, 2, 3},
    { 1, 4, 3, 2},

    { 2, 1, 3, 4},
    { 2, 1, 4, 3},
    { 2, 3, 1, 4},
    { 2, 3, 4, 1},
    { 2, 4, 1, 3},
    { 2, 4, 3, 1},

    { 3, 1, 2, 4},
    { 3, 1, 4, 2},
    { 3, 2, 1, 4},
    { 3, 2, 4, 1},
    { 3, 4, 1, 2},
    { 3, 4, 2, 1},

    { 4, 1, 2, 3},
    { 4, 1, 3, 2},
    { 4, 2, 1 ,3},
    { 4, 2, 3, 1},
    { 4, 3, 1, 2},
    { 4, 3, 2, 1}
};


void mouseClicked(){
  // koji item je kliknut?
  int selection = mainMenu.SelectedItem();
  switch(selection){
    case 0:
      // pokreni tetris
      println("Gumb 1");
      // tetrisGame.Manage();
      selectedItem=0;
      break;
    case 1:
      // pravila tetrisa
      println("Gumb 2");
      selectedItem=1;
      break;
    case 2:
      // pokreni labirint
      println("Gumb 3");
      selectedItem=2;
      break;
    case 3:
      // pravila labirinta
      println("Gumb 4");
      selectedItem=3;
      break;
    // mute sound
    case -5:
      if (isSoundOn){
        isSoundOn = false;
        println("Sound muted");
      } else {
        isSoundOn = true;
        println("Sound ON");
      }
      break;
    // itd...
  }
}


void keyPressed() {
  switch(selectedItem){
    // tumači pritisnutu tipku unutar Tetrisa
    case 0:
      tetrisGame.KeyPressed(key);
      key = 0;
      break;
    // tumači pritisnutu tipku unutar Mazea
    case 2:
      mazeGame.KeyPressed(key);
      key = 0;
      break;
    // ako smo u opcijama 1/3 (pravila)
    case 1:
    case 3:
      key = 0;
      selectedItem = -1;
      mainMenu.Display();
      break;
    default:
      // -1 je kod za povratak u main menu
      selectedItem = -1;
      // vrati se u Main menu
      //mainMenu.Display();
      break;
  }
}
