//=============== NODE ================
class Node {
  int _x;
  int _y;
  int _dir;
  int _distance;

  Node (int x, int y, int dir, int distance)  {
    _x = x;
    _y = y;
    _dir = dir;
    _distance = distance;
  }

  int getX () { return _x; }
  int getY () { return _y; }
  int getDir () { return _dir; }
  int getDistance () { return _distance; }

};
