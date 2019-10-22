class MyRect {

  int x, y, size, i, j;
  color cr, ce;
  String e, ed;
  boolean rectOver = false;
  boolean selected = false;

  MyRect(int tempX, int tempY, int tempSize, color tempCr, String tempE, color tempCe, String tempEd) {
    x = tempX;
    y = tempY;
    //i = tempI;
    //j = tempJ;
    size = tempSize;
    cr = tempCr;
    ce = tempCe;
    e = tempE;
    ed = tempEd;
  }

  void display() {
    fill(cr);
    rect(x, y, size, size);  
    textSize(20);
    fill(ce);
    text(e, x+size/4, y+size*2/3);
  }


  void update() {
    if (overRect()) {
      rectOver = true;
    } else {
      rectOver = false;
    }
  }

  void colorChange(color _cr, color _ce) {
    cr = _cr;
    ce = _ce;
  }

  String elementDirectionStatus() {
    return ed;
  }

  boolean overRect() {
    if (mouseX >= x && mouseX <= x + size && mouseY >= y && mouseY <= y + size) {
      return true;
    } else {
      return false;
    }
  }

  void elementSelected(int a) {
    if (a == 1) {
      selected = true;
    } else {
      selected = false;
    }
  }

  boolean SelectedCheck() {
    if (selected) {
      return true;
    } else {
      return false;
    }
  }
}
