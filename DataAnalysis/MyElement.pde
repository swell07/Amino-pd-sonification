class MyElement {

  int H_correctnum, H_totalnum, C_correctnum, C_totalnum, O_correctnum, O_totalnum, N_correctnum, N_totalnum;

  MyElement() {
    H_correctnum = 0;
    H_totalnum = 0;
    C_correctnum = 0;
    C_totalnum = 0;
    O_correctnum = 0;
    O_totalnum = 0;
    N_correctnum = 0;
    N_totalnum = 0;
  }

  void Total(String tempEN) {
    if (tempEN.equals("H")) {
      H_totalnum ++;
    }
    if (tempEN.equals("C")) {
      C_totalnum ++;
      print(C_totalnum);
    }
    if (tempEN.equals("O")) {
      O_totalnum ++;
    }
    if (tempEN.equals("N")) { 
      N_totalnum ++;
    }
  }

  void Correct(String tempEN) {
    if (tempEN.equals("H")) {
      H_correctnum ++;
    }
    if (tempEN.equals("C")) {
      C_correctnum ++;
    }
    if (tempEN.equals("O")) {
      O_correctnum ++;
    }
    if (tempEN.equals("N")) { 
      N_correctnum ++;
    }
  }


  int getResult(String tempEN) {
    if (tempEN.equals("H")) {
      return H_totalnum;
    }
    if (tempEN.equals("C")) {
      return C_totalnum;
    }
    if (tempEN.equals("O")) {
      return O_totalnum;
    }
    return N_totalnum;
  }

  int getCorrect(String tempEN) {
    if (tempEN.equals("H")) {
      return H_correctnum;
    }
    if (tempEN.equals("C")) {
      return C_correctnum;
    }
    if (tempEN.equals("O")) {
      return O_correctnum;
    }
    return N_correctnum;
  }

  //  int ElementCorrect() {
  //    return correctnum++;
  //  }
  //}
  //int ElementTotal() {
  //  return totalnum++;
}
