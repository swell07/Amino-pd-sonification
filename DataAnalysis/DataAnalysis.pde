String filename, fileresult, filecal;
Table table, table_result, table_cal;
String Q_T_pre, R_T_pre, Q_L_pre, R_L_pre, Q_B_pre, R_B_pre, Q_R_pre, R_R_pre, Q_T_post, R_T_post, Q_L_post, R_L_post, Q_B_post, R_B_post, Q_R_post, R_R_post;
int totalQ, score_T_pre, score_L_pre, score_B_pre, score_R_pre, score_T_post, score_L_post, score_B_post, score_R_post;
int time_pre, time_post, participant, dev, duration;

String [] element = {"H", "C", "N", "O", "-"};
//String [] questions = {"Q1", "Q2", "Q3", "Q4", "Q5", "Q6", "Q7", "Q8", "Q9", "Q10", "Q11", "Q12", "Q13", "Q14", "Q15", "Q16", "Q17", "Q18", "Q19", "Q20", "Q21", "Q22", "Q23", "Q24", "Q25", "Q26", "Q27", "Q28"};
//String [] results = {"R1", "R2", "R3", "R4", "R5", "R6", "R7", "R8", "R9", "R10", "R11", "R12", "R13", "R14", "R15", "R16", "R17", "R18", "R19", "R20", "R21", "R22", "R23", "R24", "R25", "R26", "R27", "R28"};
String [] files = {"201912201327.csv", "201912201529.csv", "201912201613.csv", "201912201651.csv", "202001071254.csv", "202001071458.csv", 
  "202001091323.csv", "202001091617.csv", "202001091745.csv", "202001131348.csv", "202001131557.csv", "202001131732.csv", "202001141237.csv", "202001141310.csv", 
  "202001141346.csv", "202001141413.csv", "202001141443.csv", "202001151520.csv", "202001151620.csv", "202001151654.csv", "202001151720.csv", "202001161110.csv", 
  "202001161148.csv", "202001161306.csv", "202001161338.csv", "202001161404.csv", "202001161452.csv"};
float [][] ep_correct, ep_total;
int[][] CheckElement;
float[] qscore;

String type = "pre";
int _dev = 8;
String [] _position = {"T", "L", "B", "R"};
//String [] position = {"T1", "L1", "B1", "R1"};
//String type = "post";
//int _dev = 5;
String [] position = {"T2", "L2", "B2", "R2"};

MyElement myelement;

void setup() {
  // selectInput("Select a file:", "fileSelected");
  participant = 0;
  //filename = files[participant-1];//"202001141413.csv";
  println(filename);
  dev = _dev+(participant-1)*8;
  fileresult = "question-post-beta.csv";
  filecal = "cal-post-beta.csv";
  //table = loadTable(filename, "header");
  table_result = loadTable(fileresult, "header"); 
  table_cal =loadTable(filecal, "header");
  totalQ = 28;

  myelement =  new MyElement();

  CheckElement = new int[5][5];
  qscore = new float[totalQ];

  //table_cal.addColumn("q");
  //table_cal.addColumn("r");
  //table_result.addColumn("P"+participant);
  //table_cal.addColumn("P"+participant);



  for (int i = 0; i < element.length; i ++) {
    for (int j = 0; j < element.length; j ++) {
      CheckElement[i][j] = 0;
      CheckElement[i][j] = 0;
    }
  }
  
  //drawtable();
}

void draw() {
}

void drawtable() {

  filename = files[participant-1];//"202001141413.csv";
  fileresult = "question-post-beta.csv";
  filecal = "cal-post.csv";
  table = loadTable(filename, "header");
  table_result = loadTable(fileresult, "header"); 
  table_cal =loadTable(filecal, "header");

  table_result.addColumn("P"+participant);
  table_cal.addColumn("P"+participant);

  for (int i = 0; i < totalQ; i++) {

    TableRow rowQ = table.findRow("Q"+i, "file_order");
    Q_T_pre = rowQ.getString(position[0]);
    Q_L_pre = rowQ.getString(position[1]);
    Q_B_pre = rowQ.getString(position[2]);
    Q_R_pre = rowQ.getString(position[3]);
    duration = rowQ.getInt("time_pre");

    TableRow rowR = table.findRow("R"+i, "file_order");
    R_T_pre = rowR.getString(position[0]);
    R_L_pre = rowR.getString(position[1]);
    R_B_pre = rowR.getString(position[2]);
    R_R_pre = rowR.getString(position[3]);
    
    qscore[i]=0;

    for (int j = 0; j < 5; j++) {
      if (element[j].equals(Q_T_pre)) {
        //TableRow newRow = table_result.addRow();
        // newRow.setInt("participant", participant);
        //newRow.setInt("time", duration);
        //newRow.setString("question", "Q"+i);
        //newRow.setString("element", element[j]);
        //newRow.setString("position", _position[0]+i);
        TableRow newRow = table_result.findRow(_position[0]+i, "position");

        if ( R_T_pre.equals(Q_T_pre) == true) {
          CheckElement[j][j] ++;
          //newRow.setString("correct", element[j]);
          newRow.setFloat("P"+participant, 0.25);
          qscore[i] += 0.25;
        } else {
          for (int k = 0; k < element.length; k++) {
            if (element[k].equals(R_T_pre)) {
              newRow.setString("P"+participant, element[k]);
              CheckElement[j][k]++;
            }
          }
        }
      }
      if (element[j].equals(Q_L_pre)) {
        //TableRow newRow = table_result.addRow();
        // newRow.setInt("participant", participant);
        //newRow.setString("question", "Q"+i);
        //newRow.setInt("time", duration);
        //newRow.setString("element", element[j]);
        //newRow.setString("position", _position[1]+i);
        TableRow newRow = table_result.findRow(_position[1]+i, "position");
        if ( R_L_pre.equals(Q_L_pre) == true) {
          CheckElement[j][j] ++;
          // newRow.setString("correct", element[j]);
          newRow.setFloat("P"+participant, 0.25);
          qscore[i] += 0.25;
        } else {
          for (int k = 0; k < element.length; k++) {
            if (element[k].equals(R_L_pre)) {
              //newRow.setString("wrong", element[k]);
              newRow.setString("P"+participant, element[k]);
              CheckElement[j][k]++;
            }
          }
        }
      }
      if (element[j].equals(Q_B_pre)) {
        //TableRow newRow = table_result.addRow();
        TableRow newRow = table_result.findRow(_position[2]+i, "position");
        //newRow.setInt("participant", participant);
        //newRow.setString("question", "Q"+i);
        //newRow.setInt("time", duration);
        //newRow.setString("element", element[j]);
        //newRow.setString("position", _position[2]+i);
        if ( R_B_pre.equals(Q_B_pre) == true) {
          CheckElement[j][j] ++;
          //newRow.setString("correct", element[j]);
          newRow.setFloat("P"+participant, 0.25);
          qscore[i] += 0.25;
        } else {
          for (int k = 0; k < element.length; k++) {
            if (element[k].equals(R_B_pre)) {
              //newRow.setString("wrong", element[k]);
              newRow.setString("P"+participant, element[k]);
              CheckElement[j][k]++;
            }
          }
        }
      }
      if (element[j].equals(Q_R_pre)) {
        //TableRow newRow = table_result.addRow();
        TableRow newRow = table_result.findRow(_position[3]+i, "position");
        // newRow.setInt("participant", participant);
        //newRow.setInt("time", duration);
        //newRow.setString("question", "Q"+i);
        //newRow.setString("element", element[j]);
        //newRow.setString("position", _position[3]+i);
        if ( R_R_pre.equals(Q_R_pre) == true) {
          CheckElement[j][j] ++;
          //newRow.setString("correct", element[j]);
          newRow.setFloat("P"+participant, 0.25);
          qscore[i] += 0.25;
        } else {
          for (int k = 0; k < element.length; k++) {
            if (element[k].equals(R_R_pre)) {
              // newRow.setString("wrong", element[k]);
              newRow.setString("P"+participant, element[k]);
              CheckElement[j][k]++;
            }
          }
        }
      }
       saveTable (table_result, "data/"+fileresult);
    }
    TableRow scoreRow = table_cal.findRow("Q"+i, "question");
    //scoreRow.setString("question", "Q"+i);
    //scoreRow.setInt("time", duration);
    scoreRow.setFloat("P"+participant, qscore[i]);

    //int c = 0;
    //for (int a = 0; a < element.length; a ++) {
    //  for (int b = 0; b < element.length; b ++) {

    //    TableRow newRow = table_cal.getRow(c);
    //    //newRow.setString("q", element[a]);
    //    //newRow.setString("r", element[b]);
    //    newRow.setInt("P"+participant, CheckElement[a][b]);
    //    c++;
    //  }
  }
  //saveTable (table_cal, "data/cal.csv");
  saveTable (table_cal, "data/"+filecal);
}


void keyPressed() {
  switch (keyCode) {
  case ENTER:
    participant++;
    drawtable();
    println(participant + " , and file: " + filename);
    break;
  }
}
