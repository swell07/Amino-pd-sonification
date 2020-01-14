String filename;
Table table;
String Q_T_pre, R_T_pre, Q_L_pre, R_L_pre, Q_B_pre, R_B_pre, Q_R_pre, R_R_pre, Q_T_post, R_T_post, Q_L_post, R_L_post, Q_B_post, R_B_post, Q_R_post, R_R_post;
int totalQ, score_T_pre, score_L_pre, score_B_pre, score_R_pre, score_T_post, score_L_post, score_B_post, score_R_post;
int time_pre, time_post;

String [] position = {"T1", "L1", "B1", "R1"};
//String [] position = {"T2", "L2", "B2", "R2"};
MyElement myelement;

void setup() {
  // selectInput("Select a file:", "fileSelected");
  filename = "201912201529.csv";
  table = loadTable(filename, "header");
  totalQ = 28;

  myelement =  new MyElement();
  score_T_pre = 0;
  score_L_pre = 0;
  score_B_pre = 0;
  score_R_pre = 0;

  time_pre = 0;
  time_post = 0;

  //myelement[0] = new MyElement("H");


  for (int i = 0; i < totalQ; i++) {

    TableRow rowQ = table.getRow(i*2);
    Q_T_pre = rowQ.getString(position[0]);
    Q_L_pre = rowQ.getString(position[1]);
    Q_B_pre = rowQ.getString(position[2]);
    Q_R_pre = rowQ.getString(position[3]);

    TableRow rowR = table.getRow(i*2+1);
    R_T_pre = rowR.getString(position[0]);
    R_L_pre = rowR.getString(position[1]);
    R_B_pre = rowR.getString(position[2]);
    R_R_pre = rowR.getString(position[3]);

    String fileorder = rowQ.getString("file_order");
    float filescore = 0;

    time_pre = time_pre + rowR.getInt("time_pre");
    time_post = time_post + rowR.getInt("time_post");

    //println( rowR.getInt("time_pre") + " and " + time_pre + " THEN " +rowR.getInt("time_post") + " and " + time_post);

    print(fileorder);

    if (R_T_pre.equals(Q_T_pre) == true) {
      score_T_pre += 1;
      filescore+=0.25;
      if (Q_T_pre.equals("-") != true) {
        myelement.Total(Q_T_pre);
        myelement.Correct(Q_T_pre);
      }
    } else {
      score_T_pre += 0;
      if (Q_T_pre.equals("-") != true) {
        myelement.Total(Q_T_pre);
      }
    }


    if (R_L_pre.equals(Q_L_pre) == true) {
      score_L_pre += 1;
      filescore+=0.25;
      if (Q_L_pre.equals("-") != true) {
        myelement.Total(Q_L_pre);
        myelement.Correct(Q_L_pre);
      }
    } else {
      score_L_pre += 0;
      if (Q_L_pre.equals("-") != true) {
        myelement.Total(Q_L_pre);
      }
    }

    if (R_B_pre.equals(Q_B_pre) == true) {
      score_B_pre += 1;
      filescore+=0.25;
      if (Q_B_pre.equals("-") != true) {
        myelement.Total(Q_B_pre);
        myelement.Correct(Q_B_pre);
      }
    } else {
      score_B_pre += 0;
      if (Q_B_pre.equals("-") != true) {
        myelement.Total(Q_B_pre);
      }
    }

    if (R_R_pre.equals(Q_R_pre) == true) {
      score_R_pre += 1;
      filescore+=0.25;
      if (Q_R_pre.equals("-") != true) {
        myelement.Total(Q_R_pre);
        myelement.Correct(Q_R_pre);
      }
    } else {
      score_R_pre += 0;
      if (Q_R_pre.equals("-") != true) {
        myelement.Total(Q_R_pre);
      }
    }

  }


  println("finalscore for T: " + score_T_pre);
  println("finalscore for L: " + score_L_pre);
  println("finalscore for B: " + score_B_pre);
  println("finalscore for R: " + score_R_pre);
  println("correct percentage H: " + myelement.getCorrect("H") + " / " + myelement.getResult("H"));
  println("correct percentage C: " + myelement.getCorrect("C") + " / " + myelement.getResult("C"));
  println("correct percentage N: " + myelement.getCorrect("N") + " / " + myelement.getResult("N"));
  println("correct percentage O: " + myelement.getCorrect("O") + " / " + myelement.getResult("O"));
  println("total time for pretest : " + time_pre);
  println("total time for posttest : " + time_post);
}

//void fileSelected(File selection) {
//  if (selection == null) {
//    println("Window was closed or the user hit cancel.");
//  } else {
//    filename = selection.getAbsolutePath(); 
//    println("User selected " + filename);
//    table = loadTable(filename, "csv");
//  }
//}
