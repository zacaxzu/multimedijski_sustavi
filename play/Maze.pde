class Maze {
  Maze (int h, int w, int p) {
    _h = h;
    _w = w;
    _sx = 1;
    _sy = 1;
    _dirs = 0;
    _p = p;

    _m = new int [_h][_w];
    _nodes = new ArrayList();

   // reset();
  }


  void show (int velicina_kvadrata) {
  _d = velicina_kvadrata;
  // Maze
  for (int j = 0; j < _h; ++j) {
    for (int k = 0; k < _w; ++k) {
      color col = red;
      int val = _m[j][k];
      if (val == WALL || val == BORDER) col = gray;
      else if (val == PAS) col = white;

      rectMode(CORNER);
      fill(col);
      rect(k*_d, j*_d, _d, _d);
    }
  }

  // Starting point
  fill(red);
  rect(_sx*_d, _sy*_d, _d, _d);

  // Ending point
  fill(green);
  rect(_ex*_d, _ey*_d, _d, _d);
  }

  void checkNode (Node aNode) {
      int x = aNode.getX();
      int y = aNode.getY();
      int distance = aNode.getDistance();

      switch (aNode.getDir()) {
      case 1: if (TestN (x, y-1)) addNode (x, y-1, distance+1); break; // North
      case 2: if (TestE (x+1, y)) addNode (x+1, y, distance+1); break; // East
      case 3: if (TestS (x, y+1)) addNode (x, y+1, distance+1); break; // South
      case 4: if (TestW (x-1, y)) addNode (x-1, y, distance+1); break; // West
      default: break;
      }
  }

  boolean TestN (int x, int y) {
    if (_m[y][x] != WALL) return false;
    if (_m[y-1][x] == PAS) return false;
    if (_m[y][x-1] == PAS) return false;
    if (_m[y][x+1] == PAS) return false;
    return true;
  }

  boolean TestE (int x, int y) {
    if (_m[y][x] != WALL) return false;
    if (_m[y][x+1] == PAS) return false;
    if (_m[y-1][x] == PAS) return false;
    if (_m[y+1][x] == PAS) return false;
    return true;
  }

  boolean TestS (int x, int y) {
    if (_m[y][x] != WALL) return false;
    if (_m[y][x-1] == PAS) return false;
    if (_m[y][x+1] == PAS) return false;
    if (_m[y+1][x] == PAS) return false;
    return true;
  }

  boolean TestW (int x, int y){
    if (_m[y][x] != WALL) return false;
    if (_m[y][x-1] == PAS) return false;
    if (_m[y-1][x] == PAS) return false;
    if (_m[y+1][x] == PAS) return false;
    return true;
  }

  void reset () {
    for (int y = 0; y < _h; ++y) {
      for (int x = 0; x < _w; ++x) {
        _m[y][x]= WALL;
      }
    }

    for (int y= 0; y < _h; ++y) {
      _m[y][0] = BORDER;
      _m[y][_w-1] = BORDER;
    }

    for (int x= 0; x < _w; ++x) {
      _m[0][x] = BORDER;
      _m[_h-1][x] = BORDER;
    }

    _sx = int (random (1, _w-1));
    _sy = int (random (1, _h-1));
    _ex = _sx;
    _ey = _sy;
    _mx = _sx;
    _my = _sy;

    _maxdistance=0;

     _d = 4;
    _dirs = int (random (0, 24));
  }

  void addNode (int x, int y, int distance) {
    // Compute new directions
    if (_p > 1) {
      if (int(random (0, _p)) == 0) {
          _dirs = int(random (0, 24)); // Select moves order
      }
    }
    else {
      _dirs = int (random (0, 24)); // Select moves order
    }

    for (int idx = 0; idx < 4; ++idx) {
      int direction = dirset[_dirs][idx];
      _nodes.add (new Node (x, y, direction, distance));  // Adds 4 Nodes
    }

    _m[y][x] = PAS; // OK we walked on it

    if (distance > _maxdistance) {
      _maxdistance = distance;
      _ex = x;
      _ey = y;
    }
  }

  void compute () {
    reset ();

    addNode (_sx, _sy, 0); // inserting first node
    while (true) {
      int n = _nodes.size();
      if (n == 0) return; // The end

      Node node = (Node) _nodes.get(n - 1); // Taking last one
      _nodes.remove (n - 1);
      checkNode (node);
    }
  }

  int getCell (int y, int x) {
    if (x >= _w || x < 0) return 0;
    if (y >= _h || y < 0) return 0;
    return _m[y][x];
  }

  int getMaxDistance () { return _maxdistance; }
  int getStep () { return _step; }

  boolean AtEnd() {
    if (_my != _ey) return false;
    if (_mx != _ex) return false;
    return true;
  }

  void goLeft () {
     if (_m[_my][_mx-1]==PAS) {
        _step++;
       fill(0xFF, 0xFF, 0xFF);
       rect(_mx*_d, _my*_d, _d, _d);
       _mx--;
       fill(blue);
       rect(_mx*_d, _my*_d, _d, _d);
     }
  }

  void goRight () {
    if (_m[_my][_mx+1]==PAS) {
      _step++;
      fill(0xFF, 0xFF, 0xFF);
      rect(_mx*_d, _my*_d, _d, _d);
      _mx++;
      fill(blue);
      rect(_mx*_d, _my*_d, _d, _d);
    }
  }

  void goUp () {
     if (_m[_my-1][_mx]==PAS) {
        _step++;
       fill(0xFF, 0xFF, 0xFF);
       rect(_mx*_d, _my*_d, _d, _d);
       _my--;
       fill(blue);
       rect(_mx*_d, _my*_d, _d, _d);
     }
  }

   void goDown () {
     if (_m[_my+1][_mx]==PAS) {
        _step++;
       fill(0xFF, 0xFF, 0xFF);
       rect(_mx*_d, _my*_d, _d, _d);
       _my++;
       fill(blue);
       rect(_mx*_d, _my*_d, _d, _d);
     }
  }

  int [][]_m;
  int _h, _w; // H & W
  int _sx, _sy; // Starting point
  int _ex, _ey; // Ending point

  int _maxdistance; // Max distance between starting and ending point

  int _d; // Drawing size for cells

  // Navigation
  int _step; // user steps
  int _mx, _my; // Current user position

  int _dirs;
  int _p; // Change direction probablility : 1->each step, 4-> 1/4 step
  ArrayList _nodes;
};
